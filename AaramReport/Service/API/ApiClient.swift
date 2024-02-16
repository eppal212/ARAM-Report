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

    // 매치 목록 조회
    // https://developer.riotgames.com/apis#match-v5/GET_getMatchIdsByPUUID
    func getMatchList(puuid: String) -> Observable<[String]> {
        var apiRequest = ApiRequest()
        apiRequest.method = .get
        apiRequest.prefix = .asia
        apiRequest.path = "lol/match/v5/matches/by-puuid"
        apiRequest.pathParam = [puuid, "ids"]
        apiRequest.parameters = ["queueId": 450, "count": 20]

        return self.request(apiRequest: apiRequest)
    }

    // 매치 상세 조회
    // https://developer.riotgames.com/apis#match-v5/GET_getMatch
    func getMatchDetail(matchId: String) -> Observable<MatchDto> {
        var apiRequest = ApiRequest()
        apiRequest.method = .get
        apiRequest.prefix = .asia
        apiRequest.path = "lol/match/v5/matches"
        apiRequest.pathParam = [matchId]

        return self.request(apiRequest: apiRequest)
    }

    // 진행중인 게임 조회
    // https://developer.riotgames.com/apis#spectator-v4/GET_getCurrentGameInfoBySummoner
    func getCurrentGame(serverId: RiotServerId, encryptedSummonerId: String) -> Observable<CurrentGameInfo> {
        var apiRequest = ApiRequest()
        apiRequest.method = .get
        apiRequest.prefix = .server(serverId)
        apiRequest.path = "lol/spectator/v4/active-games/by-summoner"
        apiRequest.pathParam = [encryptedSummonerId]

        return self.request(apiRequest: apiRequest)
    }

    // 소환사 티어 조회
    // https://developer.riotgames.com/apis#league-v4/GET_getLeagueEntriesForSummoner
    func getSummonerTier(serverId: RiotServerId, encryptedSummonerId: String) -> Observable<LeagueEntryDto> {
        var apiRequest = ApiRequest()
        apiRequest.method = .get
        apiRequest.prefix = .server(serverId)
        apiRequest.path = "lol/league/v4/entries/by-summoner"
        apiRequest.pathParam = [encryptedSummonerId]

        return self.request(apiRequest: apiRequest)
    }

    // 챔피언별 숙련도 조회
    // https://developer.riotgames.com/apis#champion-mastery-v4/GET_getAllChampionMasteriesByPUUID
    func getSummonerTier(serverId: RiotServerId, puuid: String) -> Observable<ChampionMasteryDto> {
        var apiRequest = ApiRequest()
        apiRequest.method = .get
        apiRequest.prefix = .server(serverId)
        apiRequest.path = "lol/champion-mastery/v4/champion-masteries/by-puuid"
        apiRequest.pathParam = [puuid]

        return self.request(apiRequest: apiRequest)
    }
}
