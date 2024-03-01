import UIKit

class TierGuessCell: UITableViewCell {

    @IBOutlet weak var winView: UIView!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var teamStack: UIStackView!
    @IBOutlet weak var enemyDivider: UIView!
    @IBOutlet weak var enemyStack: UIStackView!
    @IBOutlet weak var enemyTierStack: UIStackView!
    @IBOutlet weak var enemyTierImage: UIImageView!

    var match: MatchDto? // 게임 정보
    var enemyEntry: [LeagueEntryDto]? // 적팀 랭크 정보

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 6)) // Cell 간격
    }

    // 데이터 세팅
    func setData(puuid: String, summonerId: String, match: MatchDto, enemyEntry: [LeagueEntryDto]) {
        self.match = match
        self.enemyEntry = enemyEntry
        setupMatch(puuid: puuid)
    }

    // 게임 데이터 관련 처리
    private func setupMatch(puuid: String) {
        let matchData = match?.info?.participants?.filter({$0.puuid == puuid}).first

        // 승패뷰 그라데이션
        let gradient = CAGradientLayer()
        gradient.frame = winView.bounds
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        let color = matchData?.win ?? false ? Const.winColor : Const.loseColor
        gradient.colors = [color.withAlphaComponent(1).cgColor, color.withAlphaComponent(0).cgColor]
        winView.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        winView.layer.addSublayer(gradient)

        winLabel.text = matchData?.win ?? false ? "승" : "패"

        // 아군 적군 팀
        teamStack.subviews.forEach{ $0.removeFromSuperview() }
        enemyStack.subviews.forEach{ $0.removeFromSuperview() }
        enemyDivider.backgroundColor = matchData?.win ?? false ? Const.loseColor : Const.winColor

        // 이번 매치 평균 티어 계산 변수
        var totalMmr = 0
        var count = 0

        // 게임 플레이어 스택뷰 채우기
        for player in match?.info?.participants ?? [] {
            let isMe = player.puuid == puuid

            // 챔피언 썸네일
            let champ = UIImageView()
            champ.sd_setImage(with: DataDragon.default.getChampionFaceUrl(id: player.championId))
            champ.layer.cornerRadius = 4.0
            champ.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                champ.widthAnchor.constraint(equalToConstant: 18),
                champ.heightAnchor.constraint(equalToConstant: 18)
            ])

            // 닉네임
            let nickname = UILabel()
            nickname.text = player.riotIdGameName
            nickname.font = UIFont(name: isMe ? "HelveticaNeue-Bold" : "HelveticaNeue", size: 12.0)
            nickname.textColor = .white

            let content = UIStackView()
            content.axis = .horizontal
            content.spacing = 4
            content.addArrangedSubview(champ)
            content.addArrangedSubview(nickname)

            if player.teamId == match?.info?.participants?.filter({ $0.puuid == puuid }).first?.teamId {
                // 아군일 경우
                isMe ? teamStack.insertArrangedSubview(content, at: 0) : teamStack.addArrangedSubview(content)
            } else {
                // 적군일 경우 티어 정보 추가
                if let tierData = enemyEntry?.filter({ $0.summonerId == player.summonerId}).first {
                    let tierLabel = UILabel()
                    tierLabel.text = getTierFromMmr(mmr: getMmr(tier: tierData.tier, rank: tierData.rank), skipRank: false)
                    tierLabel.font = UIFont(name: tierData.queueType == "RANKED_SOLO_5x5" ? "HelveticaNeue-Bold" : "HelveticaNeue", size: 12.0)
                    tierLabel.textColor = .white
                    tierLabel.setContentCompressionResistancePriority(UILayoutPriority(751), for: .horizontal)
                    content.addArrangedSubview(tierLabel)

                    totalMmr += getMmr(tier: tierData.tier, rank: tierData.rank)
                    count += 1
                }
                enemyStack.addArrangedSubview(content)
            }
        }

        // 이번 매치 평균 티어 계산
        enemyTierStack.isHidden = count == 0
        if count != 0 {
            enemyTierImage.image = UIImage(named: getTierFromMmr(mmr: totalMmr / count, skipRank: true))
        }
    }
}
