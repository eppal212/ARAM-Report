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
    @IBOutlet weak var item1Image: UIImageView!
    @IBOutlet weak var item2Image: UIImageView!
    @IBOutlet weak var item3Image: UIImageView!
    @IBOutlet weak var item4Image: UIImageView!
    @IBOutlet weak var item5Image: UIImageView!
    @IBOutlet weak var item6Image: UIImageView!
    @IBOutlet weak var item7Image: UIImageView!
    @IBOutlet weak var badgeView: UIStackView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    var data: MatchDto? // 게임 정보

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // TODO: 그라데이션 처리
        // 이미지들 라운드
    }

    func setData(puuid: String, data: MatchDto) {
        self.data = data
        // TODO: 시간 처리

        guard let matchData = data.info?.participants?.filter({$0.puuid == puuid}).first else { return }
        winView.backgroundColor = matchData.win ?? false ? .blue : .red
        winLabel.text = matchData.win ?? false ? "승" : "패"
        champImage.sd_setImage(with: URL(string: Const.championSplash + "\(matchData.championId ?? 1)/\(matchData.championId ?? 1)000.jpg"))
        kdaLabel.text = "\(matchData.kills ?? 0) / \(matchData.deaths ?? 0) / \(matchData.assists ?? 0)"
        spell1Image.sd_setImage(with: DataDragon.default.getSpellImageUrl(id: matchData.summoner1Id))
        spell2Image.sd_setImage(with: DataDragon.default.getSpellImageUrl(id: matchData.summoner2Id))
        rune1Image.sd_setImage(with: DataDragon.default.getRuneImageUrl(perks: matchData.perks).first!)
        rune2Image.sd_setImage(with: DataDragon.default.getRuneImageUrl(perks: matchData.perks).last!)        
    }
}
