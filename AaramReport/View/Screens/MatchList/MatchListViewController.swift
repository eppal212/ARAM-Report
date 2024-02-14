import Foundation
import UIKit

class MatchListViewController: UIViewController {
    @IBOutlet weak var wallpaperImageView: UIImageView!

    private let viewModel = MatchListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setAccountData(accountData: AccountDto) {
        viewModel.account = accountData
    }

    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
