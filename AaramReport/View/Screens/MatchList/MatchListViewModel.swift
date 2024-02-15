import Foundation
import RxSwift
import RxCocoa

class MatchListViewModel {
    var account: AccountDto? {
        didSet {
            nickRelay.accept(account?.gameName ?? "")
            tagRelay.accept(account?.tagLine ?? "")
        }
    }
    var server: RiotServer?

    // 프로필 부분
    let profileRelay = PublishRelay<Int>()
    let nickRelay = BehaviorRelay<String>(value: "")
    let tagRelay = BehaviorRelay<String>(value: "")
    let levelRelay = PublishRelay<String>()

    private let disposeBag = DisposeBag()

    // 소환사 정보 가져오기
    func getSummoner() {
        guard let puuid = account?.puuid, let serverId = server?.id else { return hadleError(code: .badRequest)}
        ApiClient.default.getSummoner(serverId: serverId, puuid: puuid).subscribe(onNext: { [weak self] summoner in

            self?.profileRelay.accept(summoner.profileIconId ?? 0)
            self?.levelRelay.accept("Lv.\(summoner.summonerLevel ?? 0) I \(summoner.name ?? "0")")

        }, onError: { [weak self] error in
            guard let error = error as? ErrorResponse else { return }
            self?.hadleError(code: error.statusCode)
        }).disposed(by: disposeBag)
    }

    // API 처리 도중 발생하는 error 대응
    private func hadleError(code: ErrorStatusCode?) {
        // TODO:
    }
}

// https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/assets/items/icons2d/ 아이템
// https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/content/src/leagueclient/rankedcrests/ 랭크 이미지
// https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/data/spells/icons2d/ 스펠
// https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/v1/champion-icons/ 챔피언 아이콘
// https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/v1/champion-splashes/ 챔피언 일러스트
// https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/v1/perk-images/styles/ 룬
