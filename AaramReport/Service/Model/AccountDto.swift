struct AccountDto: Codable {
    var puuid: String?
    var gameName: String? // 계정에 gameName이 없으면 이 필드가 응답에서 제외될 수 있습니다.
    var tagLine: String? // 계정에 tagLine이 없으면 이 필드가 응답에서 제외될 수 있습니다.
}
