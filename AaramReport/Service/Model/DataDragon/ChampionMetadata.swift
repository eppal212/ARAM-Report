import Foundation

struct ChampionMetadata: Codable {
    var type: String?
    var format: String?
    var version: String?
    var data: ChampionList?
}

struct ChampionList: Codable {
    var asDictionary : [String:ChampionData?] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label: String?, value: Any) -> (String, ChampionData?)? in
            guard let label = label, let value = value as? ChampionData? else { return nil }
            return (label, value)
        }).compactMap { $0 })
        return dict
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
