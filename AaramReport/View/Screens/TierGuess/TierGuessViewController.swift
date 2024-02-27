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

        initLayout()
        initBinding()
    }

    private func initLayout() {
        // TableView
//        tableView.rowHeight = 100
//        tableView.showsVerticalScrollIndicator = false
    }

    private func initBinding() {
        guard let viewModel = viewModel else { return }

        // TableView cellForRowAt
//        viewModel.matchListRelay
//            .filter { [weak self] data in
//                data.count == self?.viewModel.targetListCount
//            }
//            .map { $0.sorted(by: { $0.info?.gameStartTimestamp ?? 0 > $1.info?.gameStartTimestamp ?? 0 }) }
//            .bind(to: tableView.rx.items(cellIdentifier: "MatchListCell")) { [weak self] index, item, cell in
//                guard let cell = cell as? MatchListCell else { return }
//                cell.setData(puuid: self?.viewModel.account?.puuid ?? "", data: item)
//            }.disposed(by: disposeBag)

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
//        switch code {
//        case .dataNotFound:
//            showToast("소환사 정보를 찾을 수 없습니다.\n서버를 확인해주세요.")
//        case .rateLimitExceeded:
//            showToast("현재 사용량이 많아 이용이 불가능합니다.\n잠시 후 다시 시도해 주세요.")
//        default:
//            showToast("Riot API 통신에 문제가 발생했습니다.\n이용에 불편을 드려 죄송합니다.")
//        }
//
//        // 초기 로딩일 경우에만 실패시 돌아감
//        if viewModel.targetListCount == viewModel.listCount {
//            navigationController?.popToRootViewController(animated: true)
//        }
    }
}
