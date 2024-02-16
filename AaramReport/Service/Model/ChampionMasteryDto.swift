import Foundation

struct ChampionMasteryDto: Codable {
    var puuid: String? // 암호화된 플레이어 범용 고유 식별자 (총 78자)
    var championPointsUntilNextLevel: Int? // 다음 레벨 달성에 필요한 포인트 수 (플레이어가 이 챔피언의 최대 챔피언 레벨에 도달하면 0)
    var chestGranted: Bool? // 현재 시즌에 이 챔피언에게 상자가 부여되어 있는지 여부
    var championId: Int? // 챔피언 ID
    var lastPlayTime: Int? // 마지막으로 이 챔피언을 플레이했을 때 유닉스 밀리초 단위의 시간
    var championLevel: Int? // 챔피언 숙련도 레벨
    var summonerId: String? // 암호화된 소환사 ID
    var championPoints: Int? // 챔피언 점수 (챔피언 레벨을 결정하는데 관여)
    var championPointsSinceLastLevel: Int? // 현재 레벨을 달성한 이후 획득한 포인트 수
    var tokensEarned: Int? // 현재 챔피언 레벨에서 이 챔피언이 획득한 토큰 수 (챔피언 레벨이 올라가면 0으로 재설정)
}
