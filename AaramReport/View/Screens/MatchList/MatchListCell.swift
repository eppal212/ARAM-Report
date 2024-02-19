import UIKit

class MatchListCell: UITableViewCell {

    @IBOutlet weak var winView: UIView!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var champImage: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var kdaLabel: UILabel!
    @IBOutlet weak var spell1Image: UIImageView!
    @IBOutlet weak var spell2Image: UIImageView!
    @IBOutlet weak var rune1Image: UIImageView!
    @IBOutlet weak var rune2Image: UIImageView!
    @IBOutlet weak var item0Image: UIImageView!
    @IBOutlet weak var item1Image: UIImageView!
    @IBOutlet weak var item2Image: UIImageView!
    @IBOutlet weak var item3Image: UIImageView!
    @IBOutlet weak var item4Image: UIImageView!
    @IBOutlet weak var item5Image: UIImageView!
    @IBOutlet weak var item6Image: UIImageView!
    @IBOutlet weak var badgeView: UIStackView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    var data: MatchDto? // 게임 정보

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4.0, left: 0, bottom: 0, right: 4)) // Cell 간격

        // 그라데이션
        let gradient = CAGradientLayer()
        gradient.frame = gradientView.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.withAlphaComponent(1.0).cgColor]
        gradientView.layer.addSublayer(gradient)

        // 이미지들 라운드
    }

    // 데이터 세팅
    func setData(puuid: String, data: MatchDto) {
        self.data = data
        setupChampion(puuid: puuid)
        setupBadge(puuid: puuid)
        setupTime()
    }

    // 게임 데이터 관련 처리
    private func setupChampion(puuid: String) {
        let matchData = data?.info?.participants?.filter({$0.puuid == puuid}).first

        // 승패뷰 그라데이션
        let gradient = CAGradientLayer()
        gradient.frame = winView.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        let color = matchData?.win ?? false ? UIColor.systemBlue : UIColor.systemRed
        gradient.colors = [color.withAlphaComponent(1.0).cgColor, color.withAlphaComponent(0.0).cgColor]
        winView.layer.addSublayer(gradient)

        winLabel.text = matchData?.win ?? false ? "승" : "패"
        champImage.sd_setImage(with: URL(string: Const.championSplash + "\(matchData?.championId ?? 1)/\(matchData?.championId ?? 1)000.jpg"))
        kdaLabel.text = "\(matchData?.kills ?? 0) / \(matchData?.deaths ?? 0) / \(matchData?.assists ?? 0)"
        spell1Image.sd_setImage(with: DataDragon.default.getSpellImageUrl(id: matchData?.summoner1Id))
        spell2Image.sd_setImage(with: DataDragon.default.getSpellImageUrl(id: matchData?.summoner2Id))
        rune1Image.sd_setImage(with: DataDragon.default.getRuneImageUrl(perks: matchData?.perks).first!)
        rune2Image.sd_setImage(with: DataDragon.default.getRuneImageUrl(perks: matchData?.perks).last!)
        item0Image.sd_setImage(with: DataDragon.default.getItemImageUrl(id: matchData?.item0))
        item1Image.sd_setImage(with: DataDragon.default.getItemImageUrl(id: matchData?.item1))
        item2Image.sd_setImage(with: DataDragon.default.getItemImageUrl(id: matchData?.item2))
        item3Image.sd_setImage(with: DataDragon.default.getItemImageUrl(id: matchData?.item3))
        item4Image.sd_setImage(with: DataDragon.default.getItemImageUrl(id: matchData?.item4))
        item5Image.sd_setImage(with: DataDragon.default.getItemImageUrl(id: matchData?.item5))
        item6Image.sd_setImage(with: DataDragon.default.getItemImageUrl(id: matchData?.item6))
    }

    // 게임 내 업적 관련 처리
    private func setupBadge(puuid: String) {
        let matchData = data?.info?.participants?.filter({$0.puuid == puuid}).first

        var badgeArray: [String] = []
        if matchData?.firstBloodKill ?? false {
            badgeArray.append("퍼블")
        }
        switch matchData?.largestMultiKill {
        case 2: badgeArray.append("더블킬")
        case 3: badgeArray.append("트리플킬")
        case 4: badgeArray.append("쿼드라킬")
        case 5: badgeArray.append("펜타킬")
        default: break
        }
        if data?.info?.participants?.sorted(by: { $0.totalDamageDealt ?? 0 > $1.totalDamageDealt ?? 0}).first?.puuid == puuid {
            badgeArray.append("딜 1등")
        }

        badgeView.subviews.forEach { $0.removeFromSuperview() }
        for badge in badgeArray {
            let badgeLabel = UILabel()
            badgeView.addArrangedSubview(badgeLabel)
            badgeLabel.text = badge
            badgeLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
            badgeLabel.textAlignment = .center
            badgeLabel.textColor = .white
        }
    }

    // 시간 관련 처리
    private func setupTime() {
        // 시간 변수 확인
        var endStamp = data?.info?.gameEndTimestamp
        endStamp = endStamp == nil ? data?.info?.gameDuration : (endStamp ?? 0) / 1000
        guard let endTime = endStamp, let startTime = data?.info?.gameStartTimestamp else {
            dateLabel.text = ""
            timeLabel.text = ""
            return
        }

        // 날짜
        let date = Date(timeIntervalSince1970: TimeInterval(startTime / 1000))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.M.d"
        dateLabel.text = dateFormatter.string(from: date)

        // 시간 & 플레이타임
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let playTime = endTime - (startTime / 1000)
        let minute = playTime / 60
        let second = playTime % 60
        timeLabel.text = "\(timeFormatter.string(from: date)) I \(minute):\(second)"
    }
}
