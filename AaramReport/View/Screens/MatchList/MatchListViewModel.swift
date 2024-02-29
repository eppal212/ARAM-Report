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
    let summonerRelay = BehaviorRelay<SummonerDto?>(value: nil) // 프로필 부분
    let splashSkinList = PublishRelay<[String]>() // 챔피언 스킨 ID 배열
    let masteryRelay = PublishRelay<[ChampionMasteryDto]>() // 숙련도
    let currentGame = BehaviorRelay<CurrentGameInfo?>(value: nil) // 진행중인 게임

    // 매치 목록 부분
    let listCount = 10 // 한 번에 불러올 갯수
    let maxListCount = 20 // 최대 목록 갯수
    var targetListCount = 0 // 한 싸이클에 목표로 할 목록 갯수 (매치상세를 반복호출 해야해서 비교할 값이 필요)
    let matchListRelay = BehaviorRelay<[MatchDto]>(value: [])

    // 티어추측 부분
    let playerDetailRelay = BehaviorRelay<[LeagueEntry]>(value: [])
    let averageMmrRelay = PublishRelay<Int>() // 전체 매치 평균 MMR

    private let disposeBag = DisposeBag()

    init() {
        // 매치목록 로딩 여부 판단
        matchListRelay.subscribe { [weak self] data in
            if data.count > 0, data.count >= self?.targetListCount ?? 0 {
                self?.isLoading.accept(false)
            }
        }.disposed(by: disposeBag)

        // 티어추측 로딩 여부 판단
        playerDetailRelay.subscribe { [weak self] data in
            if data.count > 0, data.count >= self?.targetListCount ?? 0, self?.isLoading.value ?? true{
                self?.calcTierData()
            }
        }.disposed(by: disposeBag)
    }

    // MARK: - 매치 목록 API
    // 소환사 정보 가져오기
    func getSummoner() {
        guard let puuid = account?.puuid, let serverId = server?.id else { return handleError() }
        isLoading.accept(true)
        ApiClient.default.getSummoner(serverId: serverId, puuid: puuid).subscribe(onNext: { [weak self] summoner in
            self?.summonerRelay.accept(summoner)
            self?.getMastery()
            self?.getCurrentGame(id: summoner.id)
            self?.getMatchList()
        }, onError: { [weak self] error in
            self?.handleError(error: error)
        }).disposed(by: disposeBag)
    }

    // 숙련도 정보 가져오기
    private func getMastery() {
        guard let puuid = account?.puuid, let serverId = server?.id else { return handleError() }
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

    // 현재 게임 정보 가져오기
    private func getCurrentGame(id: String?) {
        guard let serverId = server?.id, let id = id else { return currentGame.accept(nil) }
        ApiClient.default.getCurrentGame(serverId: serverId, encryptedSummonerId: id).subscribe(onNext: { [weak self] current in
            self?.currentGame.accept(current)
        }, onError: { [weak self] _ in
            self?.currentGame.accept(nil)
        }).disposed(by: disposeBag)
    }

    // 매치 목록 가져오기
    func getMatchList() {
        guard let puuid = account?.puuid else { return handleError() }
        if matchListRelay.value.count >= maxListCount { return } // 이미 한계치까지 호출했으면 더이상 목록을 가져오지 않음
        isLoading.accept(true)

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

    // MARK: - 티어 추측 API
    // 소환사 티어 정보 가져오기
    func getTiers() {
        guard let serverId = server?.id else { return handleError() }

        isLoading.accept(true)

        for (index, match) in matchListRelay.value.enumerated() {
            let teamId = match.info?.participants?.filter{ $0.puuid == account?.puuid }.first?.teamId
            guard let teamId = teamId else { return handleError() }

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (CGFloat(index) * 0.5)) { [weak self] in
                guard let self = self else { return self?.handleError() ?? () }

                for enemy in match.info?.participants ?? [] where (enemy.teamId != teamId) && (enemy.summonerId != nil) {
                    ApiClient.default.getSummonerTier(serverId: serverId, encryptedSummonerId: enemy.summonerId!).subscribe(onNext: { [weak self] enemyDetail in
                        guard let self = self, let data = enemyDetail.first else { return }

                        var arr = playerDetailRelay.value
                        if arr.count > index {
                            arr[index].leagueEntry?.append(data)
                        } else {
                            arr.append(LeagueEntry(gameStartTimestamp: match.info?.gameStartTimestamp, leagueEntry: [data]))
                        }
                        playerDetailRelay.accept(arr)
                    }, onError: {  [weak self] error in
                        self?.handleError(error: error)
                    }).disposed(by: disposeBag)
                }
            }
        }
    }

    // 티어 데이터 분석
    private func calcTierData() {
        var data = playerDetailRelay.value
        var allTotalMmr = 0// 매치목록 전체 MMR
        var allCount = 0

        for (index, match) in data.enumerated() {
            var totalMmr = 0
            var count = 0

            for player in match.leagueEntry ?? [] {
                let mmr = getMmr(tier: player.tier, rank: player.rank)
                if mmr != -1 {
                    totalMmr += mmr
                    count += 1
                }
            }

            // 매치 단위 계산
            let average = count == 0 ? 0 : totalMmr / count
            data[index].mmrAverage = average

            // 전체 계산
            if average != 0 {
                allTotalMmr += average
                allCount += 1
            }
        }

        print("zzz : \(allTotalMmr), \(allCount) | \(data) ")

        isLoading.accept(false)
        averageMmrRelay.accept(allCount == 0 ? 0 : allTotalMmr / allCount)
        playerDetailRelay.accept(data)
    }

    // MARK: - 에러 처리
    // API 처리 도중 발생하는 error 대응
    private func handleError(error: Any? = nil) {
        let errorCode: ErrorStatusCode = (error as? ErrorResponse)?.statusCode ?? .badGateway
        delegate?.handleError(code: errorCode)
    }
}
