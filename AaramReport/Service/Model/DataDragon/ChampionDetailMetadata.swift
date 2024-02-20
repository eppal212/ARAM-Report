import Foundation

struct ChampionDetailMetadata: Codable {
    var type: String?
    var format: String?
    var version: String?
    var data: [String:ChampionDetailData]

    private enum CodingKeys: String, CodingKey {
        case type, format, version, data
    }

    // Decodable 프로토콜의 초기화 메서드를 오버라이드하여 동적 필드를 처리
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        format = try container.decode(String.self, forKey: .format)
        version = try container.decode(String.self, forKey: .version)
        data = try container.decodeIfPresent([String: ChampionDetailData].self, forKey: .data) ?? [:] // data 필드는 동적으로 디코딩
    }
}

struct ChampionDetailData: Codable {
    var id: String?
    var key: String?
    var name: String?
    var title: String?
    var image: RiotImage?
    var skins: [ChampionSkin]?
    var lore: String?
    var blurb: String?
    var allytips: [String]?
    var enemytips: [String]?
    var tags: [String]?
    var partype: String?
    var info: ChampionInfo?
    var stats: ChampionStats?
    var spells: [ChampionSpell]?
    var passive: ChampionPassive?
    //var recommended: []?
}

struct ChampionSkin: Codable {
    var id: String?
    var num: Int?
    var name: String?
    var chromas: Bool?
}

struct ChampionSpell: Codable {
    var id: String?
    var name: String?
    var description: String?
    var tooltip: String?
    var leveltip: Leveltip?
    var maxrank: Int?
    var cooldown: [CGFloat]?
    var cooldownBurn: String?
    var cost: [Int]?
    var costBurn: String?
    //var datavalues:
    var effect: [[CGFloat]?]?
    var effectBurn: [String?]?
    //var vars: []
    var costType: String?
    var maxammo: String?
    var range: [Int]?
    var rangeBurn: String?
    var image: RiotImage?
    var resource: String?
}

struct Leveltip: Codable {
    var label: [String]?
    var effect: [String]?
}

struct ChampionPassive: Codable {
    var name: String?
    var description: String?
    var image: RiotImage?
}
