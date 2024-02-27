import UIKit

class TierGuessCell: UITableViewCell {

    @IBOutlet weak var winView: UIView!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var teamStack: UIStackView!
    @IBOutlet weak var enemyDivider: UIView!
    @IBOutlet weak var enemyStack: UIStackView!
    @IBOutlet weak var enemyTierImage: UIImageView!

    var data: MatchDto? // 게임 정보
    
    let itemRadius = 4.0
    let winColor = UIColor.systemBlue
    let loseColor = UIColor.systemRed

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 6)) // Cell 간격

        // 이미지들 라운드
//        item6Image.layer.cornerRadius = itemRadius
    }

    // 데이터 세팅
    func setData(puuid: String, summonerId: String, data: MatchDto, player: [LeagueEntryDto]) {
        self.data = data
        setupChampion(puuid: puuid)
    }

    // 게임 데이터 관련 처리
    private func setupChampion(puuid: String) {
        let matchData = data?.info?.participants?.filter({$0.puuid == puuid}).first

        // 승패뷰 그라데이션
        let gradient = CAGradientLayer()
        gradient.frame = winView.bounds
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        let color = matchData?.win ?? false ? winColor : loseColor
        gradient.colors = [color.withAlphaComponent(1).cgColor, color.withAlphaComponent(0).cgColor]
        winView.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        winView.layer.addSublayer(gradient)

        winLabel.text = matchData?.win ?? false ? "승" : "패"

        // 

        enemyDivider.backgroundColor = matchData?.win ?? false ? loseColor : winColor
    }
}
