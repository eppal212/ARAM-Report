import Foundation
import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class MatchListViewController: UIViewController {
    // 상단 탭 바
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerNick: UILabel!
    @IBOutlet weak var headerTag: UILabel!

    // 프로필 부분
    @IBOutlet weak var profileSplash: StretchTableViewHeader! // 상단 챔피언 스플래시 아트
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNick: UILabel!
    @IBOutlet weak var profileTag: UILabel!
    @IBOutlet weak var profileLevel: UILabel!

    @IBOutlet weak var tableView: UITableView! // 테이블뷰

    private let tableViewObserverKey = "contentSize"

    private let viewModel = MatchListViewModel()

    private let disposeBag = DisposeBag()

    // MARK: - Override & Init
    // 이동 전 호출되는 기본값 세팅 함수
    func setAccountData(accountData: AccountDto, server: RiotServer?) {
        viewModel.account = accountData
        viewModel.server = server
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
        initBinding()

        viewModel.getSummoner() // 데이터 조회 API 호출
    }

    private func initLayout() {

        // 그라데이션
        let gradient = CAGradientLayer()
        gradient.frame = gradientView.bounds
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.colors = [UIColor.black.withAlphaComponent(1.0).cgColor, UIColor.black.withAlphaComponent(0.0).cgColor]
        gradientView.layer.addSublayer(gradient)

        profileImage.layer.cornerRadius = 16

        headerNick.text = viewModel.account?.gameName
        profileNick.text = viewModel.account?.gameName
        headerTag.text = "#\(viewModel.account?.tagLine ?? "")"
        profileTag.text = "#\(viewModel.account?.tagLine ?? "")"

        // TableView
        tableView.rowHeight = 100
        tableView.showsVerticalScrollIndicator = false
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
            .map({ $0.sorted(by: { $0.info?.gameStartTimestamp ?? 0 > $1.info?.gameStartTimestamp ?? 0 }) })
            .bind(to: tableView.rx.items(cellIdentifier: "MatchListCell")) { [weak self] index, item, cell in
                guard let cell = cell as? MatchListCell else { return }
                cell.setData(puuid: self?.viewModel.account?.puuid ?? "", data: item)
            }.disposed(by: disposeBag)

        // Scroll 처리
        profileSplash.imageView.sd_setImage(with: URL(string: "https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w1200/2023/10/free-images.jpg"))
        tableView.rx.contentOffset.subscribe { [weak self] offset in
            guard let self = self else { return }
            self.profileSplash.scrollViewDidScroll(offset: offset, inset: self.tableView.contentInset)

//            if offset > 
        }.disposed(by: disposeBag)
    }

    // MARK: -

    // MARK: - IBAction
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
