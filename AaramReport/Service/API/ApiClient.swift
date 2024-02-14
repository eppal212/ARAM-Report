import Foundation
import RxSwift
import Alamofire

class ApiClient: ApiService {
    static let `default`: ApiClient = {
        return ApiClient()
    }()

    func getAccount(gameName: String, tagLine: String) -> Observable<AccountDto> {
        var apiRequest = ApiRequest()
        apiRequest.method = .get
        apiRequest.path = "account/v1/accounts/by-riot-id/\(gameName)/\(tagLine)"

        return self.request(apiRequest: apiRequest)
    }

//    func getBlockUsers(pageNo: Int, pageSize: Int, type: String? = nil) -> Observable<PagedManagedUser> {
//        var apiRequest = ApiRequest()
//        apiRequest.method = .get
//        apiRequest.path = "/api/users/block-users"
//        apiRequest.header = ApiRequestHeader.auth
//        apiRequest.encoding = URLEncoding.queryString
//        apiRequest.parameters = ["page": pageNo, "size": pageSize]
//
//        if let type = type {
//            apiRequest.parameters?["type"] = type
//        }
//
//        return self.request(apiRequest: apiRequest, loaderType: .page)
//    }
//
//    func addBlockUser(id: Int) -> Observable<ManagedUser> {
//        var apiRequest = ApiRequest()
//        apiRequest.method = .post
//        apiRequest.path = "/api/users/block-users"
//        apiRequest.header = ApiRequestHeader.auth
//        apiRequest.parameters = ["targetId": id]
//
//        return self.request(apiRequest: apiRequest, loaderType: .page)
//    }
//
//    func deleteBlockUser(id: Int) -> Observable<DefaultResponse> {
//        var apiRequest = ApiRequest()
//        apiRequest.method = .delete
//        apiRequest.path = "/api/users/block-users/\(id)"
//        apiRequest.header = ApiRequestHeader.auth
//
//        return self.request(apiRequest: apiRequest, loaderType: .page)
//    }
//
//    func updateAccountInfo(email: String? = nil,
//                                  isChangedPassword: Bool = false,
//                                  password: String? = nil) -> Observable<User> {
//        var apiRequest = ApiRequest()
//        apiRequest.method = .patch
//        apiRequest.path = "/api/users/my-account"
//        apiRequest.header = ApiRequestHeader.auth
//        apiRequest.parameters = [
//            "changePassword": isChangedPassword
//        ]
////        apiRequest.parameters = try? request.asDictionary()
//
//        if let email = email {
//            apiRequest.parameters?["email"] = email
//        }
//        if isChangedPassword,
//            let password = password,
//            let authorized = Utils.createAuthorizedData(authorizingField: password, salt: NetworkConst.passwordSalt) {
//            apiRequest.parameters?["password"] = authorized
//        }
//
//        return self.request(apiRequest: apiRequest, loaderType: .page)
//    }
}
