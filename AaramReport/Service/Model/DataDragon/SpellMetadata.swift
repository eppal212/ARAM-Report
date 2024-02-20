import Foundation

struct SpellMetadata: Codable {
    var type: String?
    var version: String?
    var data: SpellList?
}

struct SpellList: Codable {
    var SummonerBarrier: SpellData?
    var SummonerBoost: SpellData?
    var SummonerCherryFlash: SpellData?
    var SummonerCherryHold: SpellData?
    var SummonerDot: SpellData?
    var SummonerExhaust: SpellData?
    var SummonerFlash: SpellData?
    var SummonerHaste: SpellData?
    var SummonerHeal: SpellData?
    var SummonerMana: SpellData?
    var SummonerPoroRecall: SpellData?
    var SummonerPoroThrow: SpellData?
    var SummonerSmite: SpellData?
    var SummonerSnowURFSnowball_Mark: SpellData?
    var SummonerSnowball: SpellData?
    var SummonerTeleport: SpellData?
    var Summoner_UltBookPlaceholder: SpellData?
    var Summoner_UltBookSmitePlaceholder: SpellData?

    var asDictionary : [String:SpellData?] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label: String?, value: Any) -> (String, SpellData?)? in
            guard let label = label, let value = value as? SpellData? else { return nil }
            return (label, value)
        }).compactMap { $0 })
        return dict
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
