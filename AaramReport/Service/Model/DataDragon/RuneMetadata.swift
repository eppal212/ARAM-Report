import Foundation

struct RuneMetadata: Codable {
    var id: Int?
    var key: String?
    var icon: String?
    var name: String?
    var slots: [RuneSlot]?
}

struct RuneSlot: Codable {
    var runes: [RuneData]
}

struct RuneData: Codable {
    var id: Int?
    var key: String?
    var icon: String?
    var name: String?
    var shortDesc: String?
    var longDesc: String?
}
