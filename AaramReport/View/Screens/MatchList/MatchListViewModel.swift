import Foundation
import RxSwift
import RxCocoa

class MatchListViewModel {
    // 초기화 데이터
    var account: AccountDto?
    var server: RiotServer?

    // 프로필 부분
    let summonerRelay = PublishRelay<SummonerDto>()

    // 매치 목록 부분
    let matchListCount = 10
    let matchListRelay = BehaviorRelay<[MatchDto]>(value: [])

    private let disposeBag = DisposeBag()

    // MARK: - API
    // 소환사 정보 가져오기
    func getSummoner() {
        guard let puuid = account?.puuid, let serverId = server?.id else { return handleError()}
        ApiClient.default.getSummoner(serverId: serverId, puuid: puuid).subscribe(onNext: { [weak self] summoner in
            self?.summonerRelay.accept(summoner)
            self?.getMatchList()
        }, onError: { [weak self] error in
            self?.handleError(error: error)
        }).disposed(by: disposeBag)
    }

    // 매치 목록 가져오기
    private func getMatchList() {
        guard let puuid = account?.puuid else { return handleError()}
        ApiClient.default.getMatchList(puuid: puuid, count: matchListCount).subscribe(onNext: { [weak self] matchList in
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

            guard var arr = self?.matchListRelay.value else { return }
            arr.append(matchData)
            self?.matchListRelay.accept(arr)

        }, onError: { [weak self] error in
            self?.handleError(error: error)
        }).disposed(by: disposeBag)
    }

    // API 처리 도중 발생하는 error 대응
    private func handleError(error: Any? = nil, code: ErrorStatusCode = .badGateway) {
        let errorCode: ErrorStatusCode = (error as? ErrorResponse)?.statusCode ?? code
        // TODO:
    }
}
