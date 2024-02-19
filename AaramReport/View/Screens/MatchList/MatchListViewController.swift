import Foundation
import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class MatchListViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView! // 화면을 꽉채우는 스크롤뷰

    // 상단 탭 바
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerNick: UILabel!
    @IBOutlet weak var headerTag: UILabel!

    @IBOutlet weak var splashImage: UIImageView! // 상단 챔피언 스플래시 아트

    // 프로필 부분
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNick: UILabel!
    @IBOutlet weak var profileTag: UILabel!
    @IBOutlet weak var profileLevel: UILabel!

    @IBOutlet weak var tableView: UITableView! // 테이블뷰

    private let viewModel = MatchListViewModel()
    
    private let disposeBag = DisposeBag()

    // MARK: - Override & Init
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
        initBinding()

        viewModel.getSummoner()
    }

    private func initLayout() {
        profileImage.layer.cornerRadius = 16

        headerNick.text = viewModel.account?.gameName
        profileNick.text = viewModel.account?.gameName
        headerTag.text = viewModel.account?.tagLine
        profileTag.text = viewModel.account?.tagLine
    }

    private func initBinding() {
        // 상단 프로필 파트
        viewModel.summonerRelay.subscribe(onNext: { [weak self] summoner in
            self?.profileImage.sd_setImage(with: DataDragon.default.getProfileImageUrl(id: summoner.profileIconId))
            self?.profileLevel.text = "Lv.\(summoner.summonerLevel ?? 0) I \(summoner.name ?? "0")"
        }).disposed(by: disposeBag)

        // TableView
        viewModel.matchListRelay
            .filter({ [weak self] data in
                data.count == self?.viewModel.matchListCount
            })
            .bind(to: tableView.rx.items(cellIdentifier: "MatchListCell")) { [weak self] index, item, cell in
                guard let cell = cell as? MatchListCell else { return }
                cell.setData(puuid: self?.viewModel.account?.puuid ?? "", data: item)
        }.disposed(by: disposeBag)
    }

    // 이동 전 호출되는 기본값 세팅 함수
    func setAccountData(accountData: AccountDto, server: RiotServer?) {
        viewModel.account = accountData
        viewModel.server = server
    }

    // MARK: -

    // MARK: - IBAction
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
