import Foundation

struct LeagueEntry: Codable {
    var gameStartTimestamp: Int?
    var leagueEntry: [LeagueEntryDto]?
    var mmrAverage: Int?
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
