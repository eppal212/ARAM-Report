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

        // TableView
        viewModel.matchListRelay
            .filter({ [weak self] data in
                data.count == self?.viewModel.matchListCount
            })
            .bind(to: tableView.rx.items(cellIdentifier: "MatchListCell")) { index, item, cell in
            // TODO: cell 처리
        }.disposed(by: disposeBag)
    }

    private func initBinding() {
        // 상단 프로필 파트
        viewModel.profileRelay.subscribe({ [weak self] iconId in
            self?.profileImage.sd_setImage(with: URL(string: Const.profileIcon + "\(iconId.element ?? 0).jpg"))
        }).disposed(by: disposeBag)
        viewModel.nickRelay.bind(to: headerNick.rx.text).disposed(by: disposeBag)
        viewModel.nickRelay.bind(to: profileNick.rx.text).disposed(by: disposeBag)
        viewModel.tagRelay.map({"#\($0)"}).bind(to: headerTag.rx.text).disposed(by: disposeBag)
        viewModel.tagRelay.map({"#\($0)"}).bind(to: profileTag.rx.text).disposed(by: disposeBag)
        viewModel.levelRelay.bind(to: profileLevel.rx.text).disposed(by: disposeBag)
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
