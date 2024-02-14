import Foundation
import RxSwift
import Alamofire

struct ApiRequest {
    var method: HTTPMethod!
    var path: String = ""
    var parameters: [String: Any]?
    var encoding: ParameterEncoding = URLEncoding.queryString // JSONEncoding.default
    var header: HTTPHeaders {
        ["Content-Type": "application/json; charset=utf-8",
         "X-Riot-Token": "RGAPI-8210e3e5-57fa-4a7e-830c-3858b69038b4"]
    }
}

//    {
//        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36",
//        "Accept-Language": "ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7",
//        "Accept-Charset": "application/x-www-form-urlencoded; charset=UTF-8",
//        "Origin": "https://developer.riotgames.com",
//        "X-Riot-Token": "RGAPI-8210e3e5-57fa-4a7e-830c-3858b69038b4"
//    }


class ApiService {
    private var baseUrl: URL? = URL(string: Const.riotUrl)

    var session: Session = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = 60
        configuration.httpMaximumConnectionsPerHost = 6

        return Session(configuration: configuration)
    }()

    func request<T: Codable>(apiRequest: ApiRequest) -> Observable<T> {
        guard let url = URL(string: apiRequest.path, relativeTo: baseUrl) else {
            print("URL creation is failed: \(apiRequest.path)")
            let error = ErrorResponse(message: "URL creation is failed", path: apiRequest.path)
            return Observable.error(error)
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
