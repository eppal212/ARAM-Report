import Foundation

extension Bundle {
    // RIOT API KEY 획득
    var RIOT_API_KEY: String {
        guard let file = self.path(forResource: "Key", ofType: "plist") else { return "" } // plist 파일 가져오기
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" } // 딕셔너리로 변환
        guard let key = resource["RIOT_API_KEY"] as? String else { return "" } // 값 탐색
        return key
    }
}
