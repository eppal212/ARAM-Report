import Foundation

struct ChampionDetailMetadata: Codable {
    var type: String?
    var format: String?
    var version: String?
    var data: ChampionDetailData?
}

struct ChampionDetailData: Codable {
    var asDictionary : [String:ChampionDetailInfo?] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label: String?, value: Any) -> (String, ChampionDetailInfo?)? in
            guard let label = label, let value = value as? ChampionDetailInfo? else { return nil }
            return (label, value)
        }).compactMap { $0 })
        return dict
    }
}

struct ChampionDetailInfo: Codable {
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
    var cooldown: [Int]?
    var cooldownBurn: String?
    var cost: [Int]?
    var costBurn: String?
    //var datavalues:
    var effect: [[Int]?]?
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
