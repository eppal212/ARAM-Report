import Foundation

struct SpellMetadata: Codable {
    var type: String?
    var version: String?
    var data: [String:SpellData]?

    private enum CodingKeys: String, CodingKey {
        case type, version, data
    }

    // Decodable 프로토콜의 초기화 메서드를 오버라이드하여 동적 필드를 처리
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        version = try container.decode(String.self, forKey: .version)
        data = try container.decodeIfPresent([String: SpellData].self, forKey: .data) ?? [:] // data 필드는 동적으로 디코딩
    }
}

struct SpellData: Codable {
    var id: String?
    var name: String?
    var description: String?
    var tooltip: String?
    var maxrank: Int?
    var cooldown: [CGFloat]?
    var cooldownBurn: String?
    var cost: [Int]?
    var costBurn: String?
    // var datavalues: Any?
    var effect: [[CGFloat]?]?
    var effectBurn: [String?]?
    // var vars: [Any]?
    var key: String?
    var summonerLevel: Int?
    var modes: [String]
    var costType: String?
    var maxammo: String?
    var range: [Int]?
    var rangeBurn: String?
    var image: RiotImage?
    var resource: String?
}

struct RiotImage: Codable {
    var full: String?
    var sprite: String?
    var group: String?
    var x: Int?
    var y: Int?
    var w: Int?
    var h: Int?
}
