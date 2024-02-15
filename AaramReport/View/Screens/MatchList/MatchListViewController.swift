import Foundation
import UIKit

class MatchListViewController: UIViewController {
    @IBOutlet weak var wallpaperImageView: UIImageView!

    private let viewModel = MatchListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getSummoner()
    }

    func setAccountData(accountData: AccountDto, server: RiotServer?) {
        viewModel.account = accountData
        viewModel.server = server
    }

    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
