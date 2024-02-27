import Foundation

struct LeagueEntry: Codable {
    var gameStartTimestamp: Int?
    var leagueEntry: [LeagueEntryDto]?
    var tierAverage: Int?
}

struct LeagueEntryDto: Codable {
    var leagueId: String?
    var summonerId: String? // 암호화된 summonerId.
    var summonerName: String?
    var queueType: String?
    var tier: String?
    var rank: String? // 티어 안에서 어느 디비전인지
    var leaguePoints: Int?
    var wins: Int? // 협곡에서 이긴 횟수
    var losses: Int? // 협곡에서 진 횟수
    var hotStreak: Bool?
    var veteran: Bool?
    var freshBlood: Bool?
    var inactive: Bool?
    var miniSeries: MiniSeriesDTO?
}

struct MiniSeriesDTO: Codable {
    var losses: Int?
    var progress: String
    var target: Int?
    var wins: Int?
}

enum Tier: Int {
    case Iron4 = 100
    case Iron3 = 200
    case Iron2 = 300
    case Iron1 = 400
    case Bronze4 = 500
    case Bronze3 = 600
    case Bronze2 = 700
    case Bronze1 = 800
    case Silver4 = 900
    case Silver3 = 1000
    case Silver2 = 1100
    case Silver1 = 1200
    case Gold4 = 1300
    case Gold3 = 1400
    case Gold2 = 1500
    case Gold1 = 1600
    case Platinum4 = 1700
    case Platinum3 = 1800
    case Platinum2 = 1900
    case Platinum1 = 2000
    case Emerald4 = 2100
    case Emerald3 = 2200
    case Emerald2 = 2300
    case Emerald1 = 2400
    case Diamond4 = 2500
    case Diamond3 = 2600
    case Diamond2 = 2700
    case Diamond1 = 2800
    case Master = 2900
    case GrandMaster = 3100
    case Challenger = 3500
}
