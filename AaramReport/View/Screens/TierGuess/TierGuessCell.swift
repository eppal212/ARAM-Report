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


//[AaramReport.LeagueEntry(gameStartTimestamp: Optional(1709133788155),
//                         leagueEntry: Optional([AaramReport.LeagueEntryDto(leagueId: Optional("4d133c03-f0d8-47d4-ba02-b2b623509340"),
//                                                                           summonerId: Optional("_hQFRwjK240ikJ-epG0Yj36kecZkXT-WpK4dyrQG7Q-cJDE"),
//                                                                           summonerName: Optional("에어라이"),
//                                                                           queueType: Optional("RANKED_SOLO_5x5"),
//                                                                           tier: Optional("BRONZE"),
//                                                                           rank: Optional("III"),
//                                                                           leaguePoints: Optional(75),
//                                                                           wins: Optional(2),
//                                                                           losses: Optional(6),
//                                                                           hotStreak: Optional(false),
//                                                                           veteran: Optional(false),
//                                                                           freshBlood: Optional(false),
//                                                                           inactive: Optional(false),
//                                                                           miniSeries: nil),
//                                                AaramReport.LeagueEntryDto(leagueId: Optional("dec4715a-3524-4df0-8758-7e5012243578"),
//                                                                           summonerId: Optional("x4IiaYHRcqgu_mV78PaDURLHbX-kEoD_l2ximwESupWDnw"),
//                                                                           summonerName: Optional("HEXXX"),
//                                                                           queueType: Optional("RANKED_SOLO_5x5"),
//                                                                           tier: Optional("GOLD"), rank: Optional("I"),
//                                                                           leaguePoints: Optional(75), 
//                                                                           wins: Optional(34),
//                                                                           losses: Optional(39), 
//                                                                           hotStreak: Optional(false),
//                                                                           veteran: Optional(false),
//                                                                           freshBlood: Optional(true),
//                                                                           inactive: Optional(false),
//                                                                           miniSeries: nil)]),
//                         mmrAverage: Optional(1100)),
// AaramReport.LeagueEntry(gameStartTimestamp: Optional(1709126613744),
//                         leagueEntry: Optional([AaramReport.LeagueEntryDto(leagueId: Optional("16f8b9b0-8514-4928-8d2a-8952c5897c16"),
//                                                                           summonerId: Optional("nA8gA-8zeCeA8lOB3sW6l-2OMaspXhjKx4vSzov-9SmgTa7ELHmzJyB1UA"),
//                                                                           summonerName: Optional("빡 뀨 민"),
//                                                                           queueType: Optional("RANKED_FLEX_SR"),
//                                                                           tier: Optional("PLATINUM"),
//                                                                           rank: Optional("I"),
//                                                                           leaguePoints: Optional(28),
//                                                                           wins: Optional(16), 
//                                                                           losses: Optional(17),
//                                                                           hotStreak: Optional(false),
//                                                                           veteran: Optional(false),
//                                                                           freshBlood: Optional(false),
//                                                                           inactive: Optional(false),
//                                                                           miniSeries: nil),
//                                                AaramReport.LeagueEntryDto(leagueId: Optional("66ebd1ce-8753-4fda-8a43-1a01e8edd3b2"),
//                                                                           summonerId: Optional("3hzYhnmYUcCRBmxrr82HDXPlg6XCn-_fj0cJV8TqyoY_xc_ybhmutKgOqg"),
//                                                                           summonerName: Optional("양구범"),
//                                                                           queueType: Optional("RANKED_SOLO_5x5"),
//                                                                           tier: Optional("SILVER"),
//                                                                           rank: Optional("I"),
//                                                                           leaguePoints: Optional(75),
//                                                                           wins: Optional(5),
//                                                                           losses: Optional(15),
//                                                                           hotStreak: Optional(false),
//                                                                           veteran: Optional(false),
//                                                                           freshBlood: Optional(true),
//                                                                           inactive: Optional(false),
//                                                                           miniSeries: nil),
//                                                AaramReport.LeagueEntryDto(leagueId: Optional("f4fa0fae-2fca-4c45-bd99-16e225762b03"),
//                                                                           summonerId: Optional("Em2w1oUWi_UtctfE8ipnFj_xA4SKk2hIi7c5HuE4tse8iRU"),
//                                                                           summonerName: Optional("성장하는 이호"),
//                                                                           queueType: Optional("RANKED_SOLO_5x5"),
//                                                                           tier: Optional("GOLD"),
//                                                                           rank: Optional("IV"),
//                                                                           leaguePoints: Optional(70),
//                                                                           wins: Optional(5),
//                                                                           losses: Optional(5),
//                                                                           hotStreak: Optional(false),
//                                                                           veteran: Optional(false),
//                                                                           freshBlood: Optional(false),
//                                                                           inactive: Optional(false),
//                                                                           miniSeries: nil),
//                                                AaramReport.LeagueEntryDto(leagueId: Optional("b5a02fd5-9e68-43aa-8a49-7ca333486754"),
//                                                                           summonerId: Optional("GhZ69hoq9pq23Csm04_2mcuTUkQY_iIlnKpFa2uHp6uRFKg"),
//                                                                           summonerName: Optional("이호이호이호"),
//                                                                           queueType: Optional("RANKED_FLEX_SR"),
//                                                                           tier: Optional("SILVER"),
//                                                                           rank: Optional("I"),
//                                                                           leaguePoints: Optional(81),
//                                                                           wins: Optional(6),
//                                                                           losses: Optional(1),
//                                                                           hotStreak: Optional(true),
//                                                                           veteran: Optional(false),
//                                                                           freshBlood: Optional(false),
//                                                                           inactive: Optional(false), miniSeries: nil)]),
//                         mmrAverage: Optional(1425)),
// AaramReport.LeagueEntry(gameStartTimestamp: Optional(1709129606341),
//                         leagueEntry: Optional([AaramReport.LeagueEntryDto(leagueId: Optional("21381af0-0424-4470-9127-9163be733dc6"),
//                                                                           summonerId: Optional("LE5uftar1aDp5McCN2Mx2iRYdwd0U5l2oa38uEBvsuszDpA"),
//                                                                           summonerName: Optional("초급카자흐어"),
//                                                                           queueType: Optional("RANKED_FLEX_SR"),
//                                                                           tier: Optional("EMERALD"),
//                                                                           rank: Optional("IV"),
//                                                                           leaguePoints: Optional(75),
//                                                                           wins: Optional(17), 
//                                                                           losses: Optional(24),
//                                                                           hotStreak: Optional(false),
//                                                                           veteran: Optional(false),
//                                                                           freshBlood: Optional(false),
//                                                                           inactive: Optional(false),
//                                                                           miniSeries: nil),
//                                                AaramReport.LeagueEntryDto(leagueId: Optional("5699386a-ebc5-4738-8aa0-5721e33973db"),
//                                                                           summonerId: Optional("UFDNxTTnVPd0ifEP0_QVlJLl96Cb_SJMSdcM8QO0mE6zUA"),
//                                                                           summonerName: Optional("민들레옹"),
//                                                                           queueType: Optional("RANKED_FLEX_SR"),
//                                                                           tier: Optional("DIAMOND"),
//                                                                           rank: Optional("II"),
//                                                                           leaguePoints: Optional(0),
//                                                                           wins: Optional(17),
//                                                                           losses: Optional(21),
//                                                                           hotStreak: Optional(false),
//                                                                           veteran: Optional(false),
//                                                                           freshBlood: Optional(false),
//                                                                           inactive: Optional(false),
//                                                                           miniSeries: nil),
//                                                AaramReport.LeagueEntryDto(leagueId: Optional("e0684e66-46c1-4e3d-852a-d3b57116345c"),
//                                                                           summonerId: Optional("pt8TE4-nK_0sgwE2HX-0bXcA4sc8kgqqTpOgk_qcyasDaQ"),
//                                                                           summonerName: Optional("공부한다며"),
//                                                                           queueType: Optional("RANKED_FLEX_SR"),
//                                                                           tier: Optional("EMERALD"),
//                                                                           rank: Optional("IV"),
//                                                                           leaguePoints: Optional(1),
//                                                                           wins: Optional(11),
//                                                                           losses: Optional(16),
//                                                                           hotStreak: Optional(false),
//                                                                           veteran: Optional(false),
//                                                                           freshBlood: Optional(false),
//                                                                           inactive: Optional(false),
//                                                                           miniSeries: nil)]),
//                         mmrAverage: Optional(2300)),
// AaramReport.LeagueEntry(gameStartTimestamp: Optional(1709128700877),
//                         leagueEntry: Optional([AaramReport.LeagueEntryDto(leagueId: Optional("b19e4438-547b-4a72-9e38-775b427683b2"),
//                                                                           summonerId: Optional("zmG_109m4Lq1UV5KI_TlfY8mOmINwxssas8d-7OESIj6AUQ"),
//                                                                           summonerName: Optional("LatteStar"),
//                                                                           queueType: Optional("RANKED_SOLO_5x5"),
//                                                                           tier: Optional("EMERALD"),
//                                                                           rank: Optional("II"), leaguePoints: Optional(16), wins: Optional(4), losses: Optional(6), hotStreak: Optional(false), veteran: Optional(false), freshBlood: Optional(false), inactive: Optional(false), miniSeries: nil), AaramReport.LeagueEntryDto(leagueId: Optional("7100691c-4890-4859-afa5-a91b7e260636"), summonerId: Optional("rZFfhJf4Kn4TPbMXGFvEzEsB4TkxhSAcU-VSOXmwSos3VVg"), summonerName: Optional("로비랑무카"), queueType: Optional("RANKED_FLEX_SR"), tier: Optional("EMERALD"), rank: Optional("II"), leaguePoints: Optional(73), wins: Optional(6), losses: Optional(5), hotStreak: Optional(false), veteran: Optional(false), freshBlood: Optional(false), inactive: Optional(false), miniSeries: nil), AaramReport.LeagueEntryDto(leagueId: Optional("6b34159b-f75f-4c05-a778-5583d87367dd"), summonerId: Optional("OsxtlF74aAe49YUf7zhkeBhgzG00Y_ZP5kEkWeOH86AqDak"), summonerName: Optional("민지좋아"), queueType: Optional("RANKED_SOLO_5x5"), tier: Optional("PLATINUM"), rank: Optional("IV"), leaguePoints: Optional(1), wins: Optional(17), losses: Optional(16), hotStreak: Optional(false), veteran: Optional(false), freshBlood: Optional(true), inactive: Optional(false), miniSeries: nil), AaramReport.LeagueEntryDto(leagueId: Optional("85cf0be0-59e0-468e-b8b9-77c6c1e79b31"), summonerId: Optional("15Acp3T4_jfh1WbRzSnuWWgEZ__yiPJLQx4bsJmGRlnyFf4"), summonerName: Optional("나한테만zl랄이야"), queueType: Optional("RANKED_SOLO_5x5"), tier: Optional("GOLD"), rank: Optional("II"), leaguePoints: Optional(35), wins: Optional(23), losses: Optional(32), hotStreak: Optional(false), veteran: Optional(false), freshBlood: Optional(false), inactive: Optional(false), miniSeries: nil)]), mmrAverage: Optional(1950)), AaramReport.LeagueEntry(gameStartTimestamp: Optional(1709130765246), leagueEntry: Optional([AaramReport.LeagueEntryDto(leagueId: Optional("ead3d3a1-c82b-3389-8a30-3783e787c371"), summonerId: Optional("_Zci5quFVlaYoK0feQKXLopN1XnHsxKY4sAodd5zdC4-pQ"), summonerName: Optional("관저동 찌질이"), queueType: Optional("RANKED_SOLO_5x5"), tier: Optional("GRANDMASTER"), rank: Optional("I"), leaguePoints: Optional(653), wins: Optional(201), losses: Optional(174), hotStreak: Optional(false), veteran: Optional(false), freshBlood: Optional(false), inactive: Optional(false), miniSeries: nil)]), mmrAverage: Optional(0)), AaramReport.LeagueEntry(gameStartTimestamp: Optional(1709127816396), leagueEntry: Optional([AaramReport.LeagueEntryDto(leagueId: Optional("d77b1642-db74-4fc2-9b88-63a183346a72"), summonerId: Optional("9DyY0PWon4EzBpvPsrHYsI1s0DyXFbV-dkJPM2DSmcC66A"), summonerName: Optional("흐헿흐헿헿흐헿"), queueType: Optional("RANKED_SOLO_5x5"), tier: Optional("PLATINUM"), rank: Optional("IV"), leaguePoints: Optional(0), wins: Optional(20), losses: Optional(26), hotStreak: Optional(false), veteran: Optional(false), freshBlood: Optional(false), inactive: Optional(false), miniSeries: nil)]), mmrAverage: Optional(1700)), AaramReport.LeagueEntry(gameStartTimestamp: Optional(1709124270717), leagueEntry: Optional([AaramReport.LeagueEntryDto(leagueId: Optional("41d3d029-fd59-4a9f-8edd-c6a192dee56f"), summonerId: Optional("lZHIygw0ZpGC4uLYDKnMkuJyFEotY7e2DhM0d3ednUrY2w"), summonerName: Optional("고 작"), queueType: Optional("RANKED_SOLO_5x5"), tier: Optional("GOLD"), rank: Optional("III"), leaguePoints: Optional(47), wins: Optional(14), losses: Optional(5), hotStreak: Optional(false), veteran: Optional(false), freshBlood: Optional(false), inactive: Optional(false), miniSeries: nil), AaramReport.LeagueEntryDto(leagueId: Optional("9f3d01b3-a67d-4384-ae60-7bfc9db55ba2"), summonerId: Optional("M0hLPy3-1Icjrv8lyYEAjH--VfKUaGv3i0-Uslf-Zx9JydbkFk_0WSOMvA"), summonerName: Optional("우헤우헤우헤헤헤"), queueType: Optional("RANKED_SOLO_5x5"), tier: Optional("SILVER"), rank: Optional("I"), leaguePoints: Optional(12), wins: Optional(29), losses: Optional(27), hotStreak: Optional(false), veteran: Optional(false), freshBlood: Optional(false), inactive: Optional(false), miniSeries: nil)]), mmrAverage: Optional(1300)), AaramReport.LeagueEntry(gameStartTimestamp: Optional(1709123152599), leagueEntry: Optional([AaramReport.LeagueEntryDto(leagueId: Optional("c439f106-ee20-479c-a829-0b954a5617a9"), summonerId: Optional("gO1fVj8kimZH3-y33w_c_pxjumAO21uOpiRPRC3ywiAUZWc"), summonerName: Optional("한곡뽑는다뮤직큐"), queueType: Optional("RANKED_SOLO_5x5"), tier: Optional("PLATINUM"), rank: Optional("IV"), leaguePoints: Optional(5), wins: Optional(49), losses: Optional(39), hotStreak: Optional(false), veteran: Optional(false), freshBlood: Optional(false), inactive: Optional(false), miniSeries: nil), AaramReport.LeagueEntryDto(leagueId: Optional("9d8ae13a-e63a-46d9-8587-8c64c4223775"), summonerId: Optional("i0ItUKKDmigPcSidboESeq0dges8YZJZkxDvH4hEc5hbxw"), summonerName: Optional("세타N"), queueType: Optional("RANKED_FLEX_SR"), tier: Optional("PLATINUM"), rank: Optional("IV"), leaguePoints: Optional(29), wins: Optional(21), losses: Optional(22), hotStreak: Optional(false), veteran: Optional(false), freshBlood: Optional(false), inactive: Optional(false), miniSeries: nil), AaramReport.LeagueEntryDto(leagueId: Optional("d96c03a9-eac7-4f6e-87fd-24b05dad583a"), summonerId: Optional("v9aZi606YkwUYhe_r5CeIxmSb0Gd2wz7Wj6ScKAXDTdMUQ"), summonerName: Optional("수창형"), queueType: Optional("RANKED_SOLO_5x5"), tier: Optional("GOLD"), rank: Optional("III"), leaguePoints: Optional(9), wins: Optional(13), losses: Optional(11), hotStreak: Optional(false), veteran: Optional(false), freshBlood: Optional(true), inactive: Optional(false), miniSeries: nil), AaramReport.LeagueEntryDto(leagueId: Optional("844cc075-f181-46f4-9ffe-c6cdb224802d"), summonerId: Optional("vj6aPMxnVmzHcPiNtL8tYpvsYjk1yOkKqRT1vNgz1vzGuw"), summonerName: Optional("남극대장 뽀로로"), queueType: Optional("RANKED_SOLO_5x5"), tier: Optional("GOLD"), rank: Optional("I"), leaguePoints: Optional(60), wins: Optional(6), losses: Optional(8), hotStreak: Optional(false), veteran: Optional(false), freshBlood: Optional(false), inactive: Optional(false), miniSeries: nil)]), mmrAverage: Optional(1600)), AaramReport.LeagueEntry(gameStartTimestamp: Optional(1709125566355), leagueEntry: Optional([AaramReport.LeagueEntryDto(leagueId: Optional("c30bd04d-f097-477f-bd4c-94825fca1eb0"), summonerId: Optional("gtg_1UdevmLRnibItl4ABp1O1bLVX8X5wuY3T7sLw-nRVg"), summonerName: Optional("최재섭"), queueType: Optional("RANKED_FLEX_SR"), tier: Optional("SILVER"), rank: Optional("II"), leaguePoints: Optional(14), wins: Optional(5), losses: Optional(3), hotStreak: Optional(false), veteran: Optional(false), freshBlood: Optional(false), inactive: Optional(false), miniSeries: nil), AaramReport.LeagueEntryDto(leagueId: Optional("b6df4c61-b484-4efe-9b33-8832e53a6705"), summonerId: Optional("5Si5bIA8fQdFZQta8TudG7XI0ADEV_eUBUbtxuA8DSgQmLg"), summonerName: Optional("불건전소환사명E8"), queueType: Optional("RANKED_SOLO_5x5"), tier: Optional("GOLD"), rank: Optional("III"), leaguePoints: Optional(39), wins: Optional(43), losses: Optional(44), hotStreak: Optional(false), veteran: Optional(false), freshBlood: Optional(true), inactive: Optional(false), miniSeries: nil), AaramReport.LeagueEntryDto(leagueId: Optional("bffd031c-4857-49bb-b727-4e7f20352831"), summonerId: Optional("W23JJYoB_c5IW84om41EzBASrLWDx0LZ56W2myhEf1alDFU"), summonerName: Optional("사고나지말아요"), queueType: Optional("RANKED_SOLO_5x5"), tier: Optional("GOLD"), rank: Optional("I"), leaguePoints: Optional(0), wins: Optional(69), losses: Optional(60), hotStreak: Optional(false), veteran: Optional(false), freshBlood: Optional(true), inactive: Optional(false), miniSeries: nil)]), mmrAverage: Optional(1366)), AaramReport.LeagueEntry(gameStartTimestamp: Optional(1709132237280), leagueEntry: Optional([AaramReport.LeagueEntryDto(leagueId: Optional("eddbc41a-2184-4d1e-ad0d-eaed11a726ad"), summonerId: Optional("13J9x4r6hFv_8gOccPv90_PAyc2b94xAvcPewhl6qsX_7xE"), summonerName: Optional("서규원"), queueType: Optional("RANKED_FLEX_SR"), tier: Optional("PLATINUM"), rank: Optional("I"), leaguePoints: Optional(0), wins: Optional(4), losses: Optional(4), hotStreak: Optional(false), veteran: Optional(false), freshBlood: Optional(false), inactive: Optional(false), miniSeries: nil)]), mmrAverage: Optional(2000))]
