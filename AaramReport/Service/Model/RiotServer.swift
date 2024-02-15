import Foundation

enum RiotServerId: String {
    case KR, NA1, JP1, BR1, EUN1, EUW1, LA1, LA2, OC1, PH2, RU, SE2, TH2, TR1, TW2, VN2
}

struct RiotServer {
    let id: RiotServerId
    let code: String
    let name: String
    let url: String
}

extension RiotServer {
    static let data: [RiotServer] = [
        RiotServer(id: RiotServerId.KR, code: "KR", name: "Korea", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-kr.svg"),
        RiotServer(id: RiotServerId.NA1, code: "NA", name: "North America", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-na.svg"),
        RiotServer(id: RiotServerId.JP1, code: "JP", name: "Japan", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-jp.svg"),
        RiotServer(id: RiotServerId.BR1, code: "BR", name: "Brazil", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-br.svg"),
        RiotServer(id: RiotServerId.EUN1, code: "EUN", name: "Europe Nordic & East", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-eune.svg"),
        RiotServer(id: RiotServerId.EUW1, code: "EUW", name: "Europe West", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-euw.svg"),
        RiotServer(id: RiotServerId.LA1, code: "LAN", name: "LAN", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-lan.svg"),
        RiotServer(id: RiotServerId.LA2, code: "LAS", name: "LAS", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-las.svg"),
        RiotServer(id: RiotServerId.OC1, code: "OC", name: "Oceania", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-oce.svg"),
        RiotServer(id: RiotServerId.PH2, code: "PH", name: "Philippines", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-ph.svg"),
        RiotServer(id: RiotServerId.RU, code: "RU", name: "Russia", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-ru.svg"),
        RiotServer(id: RiotServerId.SE2, code: "SE", name: "Singapore", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-si.svg"),
        RiotServer(id: RiotServerId.TH2, code: "TH", name: "Thailand", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-th.svg"),
        RiotServer(id: RiotServerId.TR1, code: "TR", name: "Turkiye", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-tr.svg"),
        RiotServer(id: RiotServerId.TW2, code: "TW", name: "Taiwan", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-ta.svg"),
        RiotServer(id: RiotServerId.VN2, code: "VN", name: "Vietnam", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-vi.svg"),
    ]
}
