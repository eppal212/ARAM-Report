import Foundation

struct SummonerDto: Codable {
    var accountId: String? // 암호화된 계정 ID (최대 56자)
    var profileIconId: Int? // 소환사 아이콘 ID
    var revisionDate: Int? // 소환사 정보가 마지막으로 수정된 날짜 (에포크 밀리초) (이름 변경, 레벨 변경, 프로필 아이콘 변경)
    var name: String? // 소환사 이름
    var id: String? // 암호화된 소환사 ID (최대 63자)
    var puuid: String? // 암호화된 PUUID (총 78자)
    var summonerLevel: Int? // 소환사 레벨
}
