import Foundation
import RxSwift

class MatchListViewModel {
    var account: AccountDto?
    var server: RiotServer?

    var disposeBag = DisposeBag()

    // 소환사 정보 가져오기
    func getSummoner() {
        guard let puuid = account?.puuid, let serverId = server?.id else { return hadleError(code: .badRequest)}
        ApiClient.default.getSummoner(serverId: serverId, puuid: puuid).subscribe(onNext: { account in
            print(account)
        }, onError: { [weak self] error in
            guard let error = error as? ErrorResponse else { return }
            self?.hadleError(code: error.statusCode)
        }).disposed(by: disposeBag)
    }

    // API 처리 도중 발생하는 error 대응
    func hadleError(code: ErrorStatusCode?) {
        // TODO:
    }
}
