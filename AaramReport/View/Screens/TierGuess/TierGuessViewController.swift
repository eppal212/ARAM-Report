import Foundation
import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class TierGuessViewController: UIViewController {
    // 상단 탭 바
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerNick: UILabel!
    @IBOutlet weak var headerTag: UILabel!
    
    // 프로필 부분
    @IBOutlet weak var profileSplash: StretchTableViewHeader! // 상단 챔피언 스플래시 아트
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var tierImage: UIImageView!
    @IBOutlet weak var tierLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNick: UILabel!
    @IBOutlet weak var profileTag: UILabel!
    @IBOutlet weak var profileLevel: UILabel!

    @IBOutlet weak var tableView: UITableView! // 테이블뷰

    var viewModel: MatchListViewModel?
    private let loadingView = LoadingView()

    private var isShowHeaderBg = false

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.delegate = self
        viewModel?.getTiers() // 참가자 티어 조회

        initLayout()
        initBinding()
    }

    private func initLayout() {
        guard let viewModel = viewModel else { return }

        // 그라데이션
        let gradient = CAGradientLayer()
        gradient.frame = gradientView.bounds
        gradient.startPoint = CGPoint(x: 0.5, y: 1)
        gradient.endPoint = CGPoint(x: 0.5, y: 0)
        gradient.colors = [UIColor.black.withAlphaComponent(1).cgColor, UIColor.black.withAlphaComponent(0).cgColor]
        gradientView.layer.addSublayer(gradient)

        profileImage.layer.cornerRadius = 16
        profileSplash.imageView.image = UIImage(named: "clientBg")

        headerNick.text = viewModel.account?.gameName
        profileNick.text = viewModel.account?.gameName
        headerTag.text = "#\(viewModel.account?.tagLine ?? "")"
        profileTag.text = "#\(viewModel.account?.tagLine ?? "")"

        // TableView
        tableView.rowHeight = 110
        tableView.showsVerticalScrollIndicator = false
    }

    private func initBinding() {
        guard let viewModel = viewModel else { return }

        // 상단 프로필 정보
        viewModel.summonerRelay.subscribe(onNext: { [weak self] summoner in
            guard let self = self, let summoner = summoner else { return }
            profileImage.sd_setImage(with: DataDragon.default.getProfileImageUrl(id: summoner.profileIconId))
            profileLevel.text = "Lv.\(summoner.summonerLevel ?? 0) I \(summoner.name ?? "0")"
        }).disposed(by: disposeBag)

        viewModel.averageMmrRelay.subscribe(onNext: { [weak self] average in
            guard let self = self, average > 0 else { return }
            tierImage.image = UIImage(named: getTierFromMmr(mmr: average, skipRank: true))
            tierLabel.text = getTierFromMmr(mmr: average, skipRank: false)
        }).disposed(by: disposeBag)

        // TableView cellForRowAt
        viewModel.playerDetailRelay
            .filter { [weak self] data in
                data.count == self?.viewModel?.targetListCount
            }
            .map { $0.sorted(by: { $0.gameStartTimestamp ?? 0 > $1.gameStartTimestamp ?? 0 }) } // TODO: 정렬 오류
            .bind(to: tableView.rx.items(cellIdentifier: "TierGuessCell")) { index, item, cell in
                guard let cell = cell as? TierGuessCell else { return }
                cell.setData(puuid: viewModel.account?.puuid ?? "",
                             summonerId: viewModel.summonerRelay.value?.id ?? "",
                             match: viewModel.matchListRelay.value[index],
                             enemy: item)
            }.disposed(by: disposeBag)

        // Scroll 처리
        tableView.rx.contentOffset.subscribe(onNext: { [weak self] offset in
            guard let self = self else { return }
            // 스플래시아트 스크롤 처리
            profileSplash.scrollViewDidScroll(offset: offset, inset: tableView.contentInset)

            // 헤더 처리
            let scrollEnough = offset.y > (profileSplash.frame.height / 2)
            if isShowHeaderBg != scrollEnough {
                isShowHeaderBg = scrollEnough
                UIView.animate(withDuration: 0.1) { [weak self] in
                    self?.headerView.backgroundColor = scrollEnough ? .black : .clear
                    self?.headerNick.isHidden = !scrollEnough
                    self?.headerTag.isHidden = !scrollEnough
                }
            }
        }).disposed(by: disposeBag)

        // 로딩 처리
        viewModel.isLoading.subscribe(onNext: { [weak self] isLoading in
            self?.showLoading(isShow: isLoading)
        }).disposed(by: disposeBag)
    }

    // MARK: - Function
    private func showLoading(isShow: Bool) {
        if isShow {
            if !self.view.subviews.contains(where: { $0 == loadingView}) {
                self.view.addSubview(loadingView)
                loadingView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    loadingView.topAnchor.constraint(equalTo: self.view.topAnchor),
                    loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                    loadingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                    loadingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
                ])
            }
        } else {
            loadingView.remove()
        }
    }

    // MARK: - IBAction
    // 뒤로가기 버튼 클릭
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - RiotApiDelegate
extension TierGuessViewController: RiotApiDelegate {
    func handleError(code: ErrorStatusCode) {
        switch code {
        case .rateLimitExceeded:
            showToast("현재 사용량이 많아 이용이 불가능합니다.\n잠시 후 다시 시도해 주세요.")
        default:
            showToast("Riot API 통신에 문제가 발생했습니다.\n이용에 불편을 드려 죄송합니다.")
        }

        viewModel?.isLoading.accept(false)
        navigationController?.popViewController(animated: true)
    }
}
