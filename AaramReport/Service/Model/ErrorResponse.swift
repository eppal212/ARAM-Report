import Foundation

enum ErrorStatusCode: Int {
    case badRequest = 400
    case unauthorized = 401 // Riot Key 오류
    case forbidden = 403
    case dataNotFound = 404 // 데이터 없음 (파라미터 확인)
    case methodNotAllowed = 405
    case unsupportedMediaType = 415
    case rateLimitExceeded = 429 // API 사용량 초과
    case internalServerError = 500
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
}

struct ErrorResponse: Codable, Error {
    var errorCode: Int?
    var timestamp: String?
    var message: String?
    var path: String?

    var statusCode: ErrorStatusCode? {
        guard let code = errorCode else { return nil }
        return ErrorStatusCode(rawValue: code)
    }
}
