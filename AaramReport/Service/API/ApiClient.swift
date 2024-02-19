import Foundation
import RxSwift
import Alamofire

class ApiClient: ApiService {
    static let `default`: ApiClient = {
        return ApiClient()
    }()

    // MARK: - RIOT API
    // 계정 정보 조회
    // https://developer.riotgames.com/apis#account-v1/GET_getByRiotId
    func getAccount(gameName: String, tagLine: String) -> Observable<AccountDto> {
        var apiRequest = ApiRequest()
        apiRequest.method = .get
        apiRequest.prefix = .asia
        apiRequest.path = "riot/account/v1/accounts/by-riot-id"
        apiRequest.pathParam = [gameName, tagLine]

        return self.riotApi(apiRequest: apiRequest)
    }

    // 소환사 정보 조회
    // https://developer.riotgames.com/apis#summoner-v4/GET_getByPUUID
    func getSummoner(serverId: RiotServerId, puuid: String) -> Observable<SummonerDto> {
        var apiRequest = ApiRequest()
        apiRequest.method = .get
        apiRequest.prefix = .server(serverId)
        apiRequest.path = "lol/summoner/v4/summoners/by-puuid"
        apiRequest.pathParam = [puuid]

        return self.riotApi(apiRequest: apiRequest)
    }

    // 매치 목록 조회
    // https://developer.riotgames.com/apis#match-v5/GET_getMatchIdsByPUUID
    func getMatchList(puuid: String, count: Int) -> Observable<[String]> {
        var apiRequest = ApiRequest()
        apiRequest.method = .get
        apiRequest.prefix = .asia
        apiRequest.path = "lol/match/v5/matches/by-puuid"
        apiRequest.pathParam = [puuid, "ids"]
        apiRequest.parameters = ["queueId": 450, "count": count]

        return self.riotApi(apiRequest: apiRequest)
    }

    // 매치 상세 조회
    // https://developer.riotgames.com/apis#match-v5/GET_getMatch
    func getMatchDetail(matchId: String) -> Observable<MatchDto> {
        var apiRequest = ApiRequest()
        apiRequest.method = .get
        apiRequest.prefix = .asia
        apiRequest.path = "lol/match/v5/matches"
        apiRequest.pathParam = [matchId]

        return self.riotApi(apiRequest: apiRequest)
    }

    // 진행중인 게임 조회
    // https://developer.riotgames.com/apis#spectator-v4/GET_getCurrentGameInfoBySummoner
    func getCurrentGame(serverId: RiotServerId, encryptedSummonerId: String) -> Observable<CurrentGameInfo> {
        var apiRequest = ApiRequest()
        apiRequest.method = .get
        apiRequest.prefix = .server(serverId)
        apiRequest.path = "lol/spectator/v4/active-games/by-summoner"
        apiRequest.pathParam = [encryptedSummonerId]

        return self.riotApi(apiRequest: apiRequest)
    }

    // 소환사 티어 조회
    // https://developer.riotgames.com/apis#league-v4/GET_getLeagueEntriesForSummoner
    func getSummonerTier(serverId: RiotServerId, encryptedSummonerId: String) -> Observable<LeagueEntryDto> {
        var apiRequest = ApiRequest()
        apiRequest.method = .get
        apiRequest.prefix = .server(serverId)
        apiRequest.path = "lol/league/v4/entries/by-summoner"
        apiRequest.pathParam = [encryptedSummonerId]

        return self.riotApi(apiRequest: apiRequest)
    }

    // 챔피언별 숙련도 조회
    // https://developer.riotgames.com/apis#champion-mastery-v4/GET_getAllChampionMasteriesByPUUID
    func getSummonerTier(serverId: RiotServerId, puuid: String) -> Observable<ChampionMasteryDto> {
        var apiRequest = ApiRequest()
        apiRequest.method = .get
        apiRequest.prefix = .server(serverId)
        apiRequest.path = "lol/champion-mastery/v4/champion-masteries/by-puuid"
        apiRequest.pathParam = [puuid]

        return self.riotApi(apiRequest: apiRequest)
    }

    // MARK: - Data Dragon
    // 최신 버전 획득
    // https://ddragon.leagueoflegends.com/api/versions.json
    func getVersion() -> Observable<[String]> {
        var apiRequest = ApiRequest()
        apiRequest.method = .get
        apiRequest.path = "api/versions.json"

        return self.dataDragon(apiRequest: apiRequest)
    }

    // 소환사 주문 데이터 확인
    // https://ddragon.leagueoflegends.com/cdn/14.3.1/data/ko_KR/summoner.json
    func getSpellMetadata(version: String) -> Observable<SpellMetadata> {
        var apiRequest = ApiRequest()
        apiRequest.method = .get
        apiRequest.path = "cdn/\(version)/data/ko_KR/summoner.json"

        return self.dataDragon(apiRequest: apiRequest)
    }

    // 룬 데이터 확인
    // https://ddragon.leagueoflegends.com/cdn/14.3.1/data/ko_KR/runesReforged.json
    func getRuneMetadata(version: String) -> Observable<[RuneMetadata]> {
        var apiRequest = ApiRequest()
        apiRequest.method = .get
        apiRequest.path = "cdn/\(version)/data/ko_KR/runesReforged.json"

        return self.dataDragon(apiRequest: apiRequest)
    }
}
