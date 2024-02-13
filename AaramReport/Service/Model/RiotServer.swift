import Foundation

struct RiotServer {
    let id: String
    let code: String
    let name: String
    let url: String
}

extension RiotServer {
    static let data: [RiotServer] = [
        RiotServer(id: "KR", code: "KR", name: "Korea", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-kr.svg"),
        RiotServer(id: "NA1", code: "NA", name: "North America", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-na.svg"),
        RiotServer(id: "JP1", code: "JP", name: "Japan", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-jp.svg"),
        RiotServer(id: "BR1", code: "BR", name: "Brazil", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-br.svg"),
        RiotServer(id: "EUN1", code: "EUN", name: "Europe Nordic & East", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-eune.svg"),
        RiotServer(id: "EUW1", code: "EUW", name: "Europe West", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-euw.svg"),
        RiotServer(id: "LA1", code: "LAN", name: "LAN", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-lan.svg"),
        RiotServer(id: "LA2", code: "LAS", name: "LAS", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-las.svg"),
        RiotServer(id: "OC1", code: "OC", name: "Oceania", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-oce.svg"),
        RiotServer(id: "PH2", code: "PH", name: "Philippines", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-ph.svg"),
        RiotServer(id: "RU", code: "RU", name: "Russia", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-ru.svg"),
        RiotServer(id: "SE2", code: "SE", name: "Singapore", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-si.svg"),
        RiotServer(id: "TH2", code: "TH", name: "Thailand", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-th.svg"),
        RiotServer(id: "TR1", code: "TR", name: "Turkiye", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-tr.svg"),
        RiotServer(id: "TW2", code: "TW", name: "Taiwan", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-ta.svg"),
        RiotServer(id: "VN2", code: "VN", name: "Vietnam", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-vi.svg"),
    ]
}
