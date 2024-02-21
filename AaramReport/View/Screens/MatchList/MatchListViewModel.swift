import Foundation
import RxSwift
import RxCocoa

protocol RiotApiDelegate {
    func handleError(code: ErrorStatusCode)
}

class MatchListViewModel {
    var delegate: RiotApiDelegate?

    // 초기화 데이터
    var account: AccountDto?
    var server: RiotServer?

    let isLoading = BehaviorRelay<Bool>(value: true)
    let summonerRelay = PublishRelay<SummonerDto>() // 프로필 부분
    let splashSkinList = PublishRelay<[String]>() // 챔피언 스킨 ID 배열
    let masteryRelay = PublishRelay<[ChampionMasteryDto]>() // 숙련도

    // 매치 목록 부분
    let listCount = 10 // 한 번에 불러올 갯수
    let maxListCount = 30 // 최대 목록 갯수
    var targetListCount = 0 // 한 싸이클에 목표로 할 목록 갯수 (매치상세를 반복호출 해야해서 비교할 값이 필요)
    let matchListRelay = BehaviorRelay<[MatchDto]>(value: [])

    private let disposeBag = DisposeBag()

    // MARK: - API
    // 소환사 정보 가져오기
    func getSummoner() {
        guard let puuid = account?.puuid, let serverId = server?.id else { return handleError()}
        ApiClient.default.getSummoner(serverId: serverId, puuid: puuid).subscribe(onNext: { [weak self] summoner in
            self?.summonerRelay.accept(summoner)
            self?.getMastery()
            self?.getMatchList()
        }, onError: { [weak self] error in
            self?.handleError(error: error)
        }).disposed(by: disposeBag)
    }

    // 숙련도 정보 가져오기
    private func getMastery() {
        guard let puuid = account?.puuid, let serverId = server?.id else { return handleError()}
        ApiClient.default.getMastery(serverId: serverId, puuid: puuid).subscribe(onNext: { [weak self] mastery in
            self?.masteryRelay.accept(mastery)
            self?.getChampionSkins(id: mastery.first?.championId)
        }, onError: { [weak self] error in
            self?.handleError(error: error)
        }).disposed(by: disposeBag)
    }

    // 챔피언 스킨 목록 가져오기
    private func getChampionSkins(id: Int?) {
        let version = DataDragon.default.version
        let name = DataDragon.default.getChampionName(id: id)
        ApiClient.default.getChampionDetailMetadata(version: version, name: name).subscribe(onNext: { [weak self] detail in
            var skinList: [String] = []
            for (_, data) in detail.data ?? [:] where data.key == String(id ?? 0) {
                let name = data.id ?? ""
                data.skins?.forEach({ skinList.append("\(name)_\($0.num ?? 0)") })
            }
            self?.splashSkinList.accept(skinList)
        }, onError: { [weak self] error in
            self?.handleError(error: error)
        }).disposed(by: disposeBag)

    }

    // 매치 목록 가져오기
    func getMatchList() {
        guard let puuid = account?.puuid else { return handleError()}
        if matchListRelay.value.count >= maxListCount { return } // 이미 한계치까지 호출했으면 더이상 목록을 가져오지 않음

        // 조회할 목록 갯수 계산
        let callCount = targetListCount == 0 ? listCount : listCount / 2
        let startCount = matchListRelay.value.count
        targetListCount += callCount

        ApiClient.default.getMatchList(puuid: puuid, start: startCount, count: callCount).subscribe(onNext: { [weak self] matchList in
            for matchId in matchList {
                self?.getMatchDetail(matchId: matchId) // 매치 상세 조회
            }
        }, onError: { [weak self] error in
            self?.handleError(error: error)
        }).disposed(by: disposeBag)
    }

    // 매치 상세 가져오기
    private func getMatchDetail(matchId: String) {
        ApiClient.default.getMatchDetail(matchId: matchId).subscribe(onNext: { [weak self] matchData in
            guard let self = self else { return }
            var arr = matchListRelay.value
            arr.append(matchData)
            matchListRelay.accept(arr)
        }, onError: { [weak self] error in
            self?.handleError(error: error)
        }).disposed(by: disposeBag)
    }

    // API 처리 도중 발생하는 error 대응
    private func handleError(error: Any? = nil, code: ErrorStatusCode = .badGateway) {
        let errorCode: ErrorStatusCode = (error as? ErrorResponse)?.statusCode ?? code
        delegate?.handleError(code: errorCode)
    }
}
