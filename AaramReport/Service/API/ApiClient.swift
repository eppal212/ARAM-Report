import Foundation
import RxSwift
import Alamofire

class ApiClient: ApiService {
    static let `default`: ApiClient = {
        return ApiClient()
    }()

    // 계정 정보 조회
    // https://developer.riotgames.com/apis#account-v1/GET_getByRiotId
    func getAccount(gameName: String, tagLine: String) -> Observable<AccountDto> {
        var apiRequest = ApiRequest()
        apiRequest.method = .get
        apiRequest.prefix = .asia
        apiRequest.path = "riot/account/v1/accounts/by-riot-id"
        apiRequest.pathParam = [gameName, tagLine]

        return self.request(apiRequest: apiRequest)
    }

    // 소환사 정보 조회
    // https://developer.riotgames.com/apis#summoner-v4/GET_getByPUUID
    func getSummoner(serverId: RiotServerId, puuid: String) -> Observable<SummonerDto> {
        var apiRequest = ApiRequest()
        apiRequest.method = .get
        apiRequest.prefix = .server(serverId)
        apiRequest.path = "lol/summoner/v4/summoners/by-puuid"
        apiRequest.pathParam = [puuid]

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
