import Foundation

struct RiotServer {
    let id: String
    let name: String
    let url: String
}

let RiotServerList: [RiotServer] = [
    RiotServer(id: "KR", name: "Korea", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-kr.svg"),
    RiotServer(id: "NA1", name: "North America", url: "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-na.svg"), ]


//let ServerList: [String: String] = [{"id": "KR", "name": "Korea",  "url": "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-kr.svg"},
//                                    {"id": "NA1", "name": "North America", "url": "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-na.svg"},
//                                    {"id": "JP1", "name": "Japan", "url": "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-jp.svg"},
//                                    {"id": "BR1", "name": "Brazil", "url": "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-br.svg"},
//                                    {"id": "EUN1", "name": "Europe Nordic & East", "url": "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-eune.svg"},
//                                    {"id": "EUW1", "name": "Europe West", "url": "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-euw.svg"},
//                                    {"id": "LA1", "name": "LAS", "url": "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-las.svg"},
//                                    {"id": "LA2", "name": "LAN", "url": "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-lan.svg"},
//                                    {"id": "OC1", "name": "Oceania", "url": "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-oc.svg"},
//                                    {"id": "PH2", "name": "Philippines", "url": "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-ph.svg"},
//                                    {"id": "RU", "name": "Russia", "url": "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-ru.svg"},
//                                    {"id": "SE2", "name": "Singapore", "url": "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-si.svg"},
//                                    {"id": "TH2", "name": "Thailand", "url": "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-th.svg"},
//                                    {"id": "TR1", "name": "Turkiye", "url": "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-tr.svg"},
//                                    {"id": "TW2", "name": "Taiwan", "url": "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-tw.svg"},
//                                    {"id": "VN2", "name": "Vietnam", "url": "https://s-lol-web.op.gg/assets/images/regions/01-icon-icon-vi.svg"}]
