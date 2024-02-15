import Foundation
import RxSwift
import Alamofire

enum PrefixPath {
    case none
    case lol
    case asia
    case server(RiotServerId)

    func getValue() -> String {
        switch self {
        case .none: return ""
        case .lol: return "lol."
        case .asia: return "asia."
        case .server(let id): return id.rawValue.lowercased()
        }
    }
}

struct ApiRequest {
    var method: HTTPMethod = .get
    var prefix: PrefixPath = .none
    var path: String = ""
    var pathParam: [String]?
    var parameters: [String: Any]?
    var encoding: ParameterEncoding = URLEncoding.queryString // JSONEncoding.default
    var header: HTTPHeaders {
        ["Content-Type": "application/json; charset=utf-8",
         "X-Riot-Token": "RGAPI-8210e3e5-57fa-4a7e-830c-3858b69038b4"] // TODO: 숨겨야 함
    }
}


class ApiService {
    var session: Session = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = 60
        configuration.httpMaximumConnectionsPerHost = 6

        return Session(configuration: configuration)
    }()

    func request<T: Codable>(apiRequest: ApiRequest) -> Observable<T> {
        let baseUrl: URL? = URL(string: "http://" + apiRequest.prefix.getValue() + Const.riotUrl)

        guard var url = URL(string: apiRequest.path, relativeTo: baseUrl) else {
            print("URL creation is failed: \(apiRequest.path)")
            let error = ErrorResponse(message: "URL creation is failed", path: apiRequest.path)
            return Observable.error(error)
        }

        for param in apiRequest.pathParam ?? [] {
            url.appendPathComponent(param)
        }

        return Observable<T>.create { observer in
            let dataRequest = self.session.request(url,
                                                   method: apiRequest.method,
                                                   parameters: apiRequest.parameters,
                                                   encoding: apiRequest.encoding,
                                                   headers: apiRequest.header)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        print("request \"\(apiRequest.path)\" success: \(String(decoding: data, as: UTF8.self))")

                        do {
                            let model: T = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(model)
                        } catch let error {
                            print("decoding error!")
                            observer.onError(error)
                        }

                    case .failure(let error):
                        print("request fail \"\(apiRequest.path)\" error: \(error) params: \(String(describing: apiRequest.parameters))")

                        if let data = response.data {
                            do {
                                var model: ErrorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                                model.errorCode = response.response?.statusCode
                                observer.onError(model)
                            } catch {
                                observer.onError(error)
                            }
                        } else {
                            observer.onError(error)
                        }
                    }

                    observer.onCompleted()
                }

            return Disposables.create { dataRequest.cancel() }
        }
    }
}
