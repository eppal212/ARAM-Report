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
        case .server(let id): return "\(id.rawValue.lowercased())."
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
    var header: HTTPHeaders = ["Content-Type": "application/json; charset=utf-8"]
}


class ApiService {
    var session: Session = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = 60
        configuration.httpMaximumConnectionsPerHost = 6

        return Session(configuration: configuration)
    }()
    let apiKey = Bundle.main.RIOT_API_KEY
    let maxRiotApiCallCount = 100 // 2분에 100번
    var riotApiCallCount = 0

    // Riot API 호출 제한 계산
    private func addRiotApiCallCount() {
        riotApiCallCount += 1
        print("RiotApiCallCount : \(riotApiCallCount)")

        // 2분 뒤 증가치 감산
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 120) { [weak self] in
            self?.riotApiCallCount -= 1
        }
    }

    func riotApi<T: Codable>(apiRequest: ApiRequest) -> Observable<T> {
        var apiRequest = apiRequest

        let baseUrl: URL? = URL(string: "https://" + apiRequest.prefix.getValue() + Const.riotUrl)
        guard var url = URL(string: apiRequest.path, relativeTo: baseUrl) else {
            print("URL creation is failed: \(apiRequest.path)")
            let error = ErrorResponse(message: "URL creation is failed", path: apiRequest.path)
            return Observable.error(error)
        }

        for param in apiRequest.pathParam ?? [] {
            url.appendPathComponent(param)
        }

        apiRequest.header["X-Riot-Token"] = apiKey

        addRiotApiCallCount()

        return request(apiRequest: apiRequest, url: url)
    }

    func dataDragon<T: Codable>(apiRequest: ApiRequest) -> Observable<T> {
        let baseUrl: URL? = URL(string: Const.dataDragon)

        guard let url = URL(string: apiRequest.path, relativeTo: baseUrl) else {
            print("URL creation is failed: \(apiRequest.path)")
            let error = ErrorResponse(message: "URL creation is failed", path: apiRequest.path)
            return Observable.error(error)
        }

        return request(apiRequest: apiRequest, url: url)
    }

    private func request<T: Codable>(apiRequest: ApiRequest, url: URL) -> Observable<T>  {
        return Observable<T>.create { [weak self] observer in
            let dataRequest = self?.session.request(url,
                                                    method: apiRequest.method,
                                                    parameters: apiRequest.parameters,
                                                    encoding: apiRequest.encoding,
                                                    headers: apiRequest.header)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        print("request \"\(url.absoluteString)\" success: \(String(decoding: data, as: UTF8.self))")

                        do {
                            let model: T = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(model)
                        } catch let error {
                            print("decoding error!: \(error)")
                            observer.onError(error)
                        }

                    case .failure(let error):
                        print("request fail \"\(url.absoluteString)\" error: \(error) params: \(String(describing: apiRequest.parameters))")

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

            return Disposables.create { dataRequest?.cancel() }
        }
    }
}
