import Foundation

// 현재 진행중인 게임 정보
struct CurrentGameInfo: Codable {
    var gameId: Int? // 게임 ID
    var gameType: String? // 게임 타입
    var gameStartTime: Int? // 게임 시작 시간(밀리초)
    var gameLength: Int? // 게임이 시작된 후 경과한 시간(초)
    var platformId: String? // 게임이 진행되는 플랫폼의 ID
    var gameMode: String? // 게임 모드
    var bannedChampions: [BannedChampion]? // 밴 챔피언 목록
    var gameQueueConfigId: Int? // 큐 ID
    var observers: Observer? // 옵저버 정보
    var participants: [CurrentGameParticipant]? // 참가자 정보
}

// 밴 챔피언 정보
struct BannedChampion: Codable {
    var pickTurn: Int? // 챔피언이 금지된 턴
    var championId: String? // 챔피언 ID
    var teamId: Int? // 챔피언을 금지한 팀의 ID
}

// 옵저버 정보
struct Observer: Codable {
    var encryptionKey: String? // 재생을 위해 옵저버 그리드 게임 데이터를 해독하는 데 사용되는 키
}

// 참가자 정보
struct CurrentGameParticipant: Codable {
    var championId: Int? // 챔피언 ID
    var perks: Perks? // 룬 정보
    var profileIconId: Int? // 프로필 아이콘 ID
    var bot: Bool? // 봇인지 여부
    var teamId: Int? // 팀 ID
    var summonerName: String? // 소환사 이름
    var summonerId: String? // 암호화된 소환사 ID
    var puuid: String? // 암호화된 puuid
    var spell1Id: Int? // 첫번째 소환사 주문
    var spell2Id: Int? // 두번째 소환사 주문
    var gameCustomizationObjects: [GameCustomizationObject] // 게임 커스터마이징 목록
}

// 룬 정보
struct Perks: Codable {
    var perkIds: [Int]? // 룬 ID
    var perkStyle: Int? // 메인 룬 path
    var perkSubStyle: Int? // 보조 룬 path
}

// 게임 커스터마이징 목록
struct GameCustomizationObject: Codable {
    var category: String? // 게임 커스터마이징을 위한 카테고리 식별자
    var content: String? // 게임 커스터마이징 콘텐츠
}
