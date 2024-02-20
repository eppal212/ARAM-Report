import Foundation

struct ChampionMetadata: Codable {
    var type: String?
    var format: String?
    var version: String?
    var data: [String:ChampionData]?

    private enum CodingKeys: String, CodingKey {
        case type, format, version, data
    }

    // Decodable 프로토콜의 초기화 메서드를 오버라이드하여 동적 필드를 처리
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        format = try container.decode(String.self, forKey: .format)
        version = try container.decode(String.self, forKey: .version)
        data = try container.decodeIfPresent([String: ChampionData].self, forKey: .data) ?? [:] // data 필드는 동적으로 디코딩
    }
}

struct ChampionData: Codable {
    var version: String?
    var id: String?
    var key: String?
    var name: String?
    var title: String?
    var blurb: String?
    var info: ChampionInfo?
    var image: RiotImage?
    var tags: [String]?
    var partype: String?
    var stats: ChampionStats?
}

struct ChampionInfo: Codable {
    var attack: Int?
    var defense: Int?
    var magic: Int?
    var difficulty: Int?
}

struct ChampionStats: Codable {
    var hp: CGFloat?
    var hpperlevel: CGFloat?
    var mp: CGFloat?
    var mpperlevel: CGFloat?
    var movespeed: CGFloat?
    var armor: CGFloat?
    var armorperlevel: CGFloat?
    var spellblock: CGFloat?
    var spellblockperlevel: CGFloat?
    var attackrange: CGFloat?
    var hpregen: CGFloat?
    var hpregenperlevel: CGFloat?
    var mpregen: CGFloat?
    var mpregenperlevel: CGFloat?
    var crit: CGFloat?
    var critperlevel: CGFloat?
    var attackdamage: CGFloat?
    var attackdamageperlevel: CGFloat?
    var attackspeedperlevel: CGFloat?
    var attackspeed: CGFloat?
}
