import Foundation
import UIKit

class MatchListViewController: UIViewController {
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

    private let viewModel = MatchListViewModel()

    // MARK: - Override & Init
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
        initBinding()

        viewModel.getSummoner()
    }

    private func initLayout() {

    }

    private func initBinding() {

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
