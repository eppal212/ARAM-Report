import Foundation

// Match 상세
struct MatchDto: Codable {
    var metadata: MetadataDto? // Match 메타데이터
    var info: InfoDto? // Match 정보
}

// Match 메타데이터
struct MetadataDto: Codable {
    var dataVersion: String? // Match 데이터 버전
    var matchId: String? // Match ID
    var participants: [String]? // 참가자 PUUID 목록
}

// Match 정보
struct InfoDto: Codable {
    var gameCreation: Int? // 게임이 게임 서버(즉, 로딩 화면)에서 생성되는 경우에 대한 유닉스 타임스탬프
    var gameDuration: Int? // 게임에 참여한 모든 참가자의 max timePlayed를 초 단위로 반환 (gameEndTimestamp 필드가 nil일 경우 사용)
    var gameEndTimestamp: Int? // 게임 서버에서 경기가 끝날 때를 위한 유닉스 타임스탬프
    var gameId: Int?
    var gameMode: String? // https://static.developer.riotgames.com/docs/lol/gameModes.json 참고
    var gameName: String?
    var gameStartTimestamp: Int? // 게임 서버에서 일치가 시작되는 시점에 대한 유닉스 타임스탬프
    var gameType: String?
    var gameVersion: String? // 응답값의 처음 두 숫자는 게임이 플레이된 패치를 결정하는 데 사용 가능
    var mapId: Int? // https://static.developer.riotgames.com/docs/lol/maps.json 참고
    var participants: [ParticipantDto]? // 참가자 정보
    var platformId: String? // 경기가 진행된 플랫폼
    var queueId: Int? // https://static.developer.riotgames.com/docs/lol/queues.json 참고
    var teams: [TeamDto]? // 팀 정보
    var tournamentCode: String? // 매치 생성에 사용된 토너먼트 코드
}

// 참가자 정보
struct ParticipantDto: Codable {
    var assists: Int?
    var baronKills: Int?
    var bountyLevel: Int?
    var champExperience: Int?
    var champLevel: Int?
    var championId: Int?
    var championName: String?
    var championTransform: Int? // 케인의 변신에만 사용 (0: 기본, 1: 다르킨, 2: 그림자 암살자)
    var consumablesPurchased: Int?
    var damageDealtToBuildings: Int?
    var damageDealtToObjectives: Int?
    var damageDealtToTurrets: Int?
    var damageSelfMitigated: Int?
    var deaths: Int?
    var detectorWardsPlaced: Int?
    var doubleKills: Int?
    var dragonKills: Int?
    var firstBloodAssist: Bool?
    var firstBloodKill: Bool?
    var firstTowerAssist: Bool?
    var firstTowerKill: Bool?
    var gameEndedInEarlySurrender: Bool?
    var gameEndedInSurrender: Bool?
    var goldEarned: Int?
    var goldSpent: Int?
    var individualPosition: String? // 플레이어가 어떤 포지션에서 실제로 플레이했는지에 대한 추측 (teamPosition과 같이 사용 권장)
    var inhibitorKills: Int?
    var inhibitorTakedowns: Int?
    var inhibitorsLost: Int?
    var item0: Int?
    var item1: Int?
    var item2: Int?
    var item3: Int?
    var item4: Int?
    var item5: Int?
    var item6: Int?
    var itemsPurchased: Int?
    var killingSprees: Int?
    var kills: Int?
    var lane: String?
    var largestCriticalStrike: Int?
    var largestKillingSpree: Int?
    var largestMultiKill: Int?
    var longestTimeSpentLiving: Int?
    var magicDamageDealt: Int?
    var magicDamageDealtToChampions: Int?
    var magicDamageTaken: Int?
    var neutralMinionsKilled: Int?
    var nexusKills: Int?
    var nexusTakedowns: Int?
    var nexusLost: Int?
    var objectivesStolen: Int?
    var objectivesStolenAssists: Int?
    var participantId: Int?
    var pentaKills: Int?
    var perks: PerksDto?
    var physicalDamageDealt: Int?
    var physicalDamageDealtToChampions: Int?
    var physicalDamageTaken: Int?
    var profileIcon: Int?
    var puuid: String?
    var quadraKills: Int?
    var riotIdName: String?
    var riotIdTagline: String?
    var role: String?
    var sightWardsBoughtInGame: Int?
    var spell1Casts: Int?
    var spell2Casts: Int?
    var spell3Casts: Int?
    var spell4Casts: Int?
    var summoner1Casts: Int?
    var summoner1Id: Int?
    var summoner2Casts: Int?
    var summoner2Id: Int?
    var summonerId: String?
    var summonerLevel: Int?
    var summonerName: String?
    var teamEarlySurrendered: Bool?
    var teamId: Int?
    var teamPosition: String? // 각 팀에 포지션 제약조건을 추가한 추측 (individualPosition과 같이 사용 권장)
    var timeCCingOthers: Int?
    var timePlayed: Int?
    var totalDamageDealt: Int?
    var totalDamageDealtToChampions: Int?
    var totalDamageShieldedOnTeammates: Int?
    var totalDamageTaken: Int?
    var totalHeal: Int?
    var totalHealsOnTeammates: Int?
    var totalMinionsKilled: Int?
    var totalTimeCCDealt: Int?
    var totalTimeSpentDead: Int?
    var totalUnitsHealed: Int?
    var tripleKills: Int?
    var trueDamageDealt: Int?
    var trueDamageDealtToChampions: Int?
    var trueDamageTaken: Int?
    var turretKills: Int?
    var turretTakedowns: Int?
    var turretsLost: Int?
    var unrealKills: Int?
    var visionScore: Int?
    var visionWardsBoughtInGame: Int?
    var wardsKilled: Int?
    var wardsPlaced: Int?
    var win: Bool?
}

// 룬 정보
struct PerksDto: Codable {
    var statPerks: PerkStatsDto?
    var styles: [PerkStyleDto]?
}

// 룬 스탯 3종
struct PerkStatsDto: Codable {
    var defense: Int?
    var flex: Int?
    var offense: Int?
}

// 메인/보조 룬
struct PerkStyleDto: Codable {
    var description: String?
    var selections: [PerkStyleSelectionDto]?
    var style: Int?
}

// 찍힌 룬 내역
struct PerkStyleSelectionDto: Codable {
    var perk: Int?
    var var1: Int?
    var var2: Int?
    var var3: Int?
}

// 팀 정보
struct TeamDto: Codable {
    var bans: [BanDto]?
    var objectives: ObjectivesDto?
    var teamId: Int?
    var win: Bool?
}

// 밴 정보
struct BanDto: Codable {
    var championId: Int?
    var pickTurn: Int?
}

// 오브젝트들 정보
struct ObjectivesDto: Codable {
    var baron: ObjectiveDto?
    var champion: ObjectiveDto?
    var dragon: ObjectiveDto?
    var inhibitor: ObjectiveDto?
    var riftHerald: ObjectiveDto?
    var tower: ObjectiveDto?
}

// 오브젝트 정보
struct ObjectiveDto: Codable {
    var first: Bool?
    var kills: Int?
}
