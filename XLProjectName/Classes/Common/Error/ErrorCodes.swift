import Foundation

/// MRKit errors code list.
///    - unknownNetworkError: Unknown network error.
///    - emptyResponse: Empty response from server.
///    - parsingError: Error parsing response.
public struct MRKitErrorCode {
    /// Unknown network error
    public static let unknownNetworkError = 10000
    /// Empty response from server
    public static let emptyResponse = 10400
    /// Error parsing response
    public static let parsingError = 10401
}

public enum ErrorMessageByIdentifire: String, Codable {
    case wrongCredentials = "WRONG_CREDENTIALS"
    case userNotVerified = "USER_NOT_VERIFIED"
    case userWasBlocked = "USER_WAS_BLOCKED"
    case userAlredyExists = "USER_ALREADY_EXISTS"
    case emailHasNotChanged = "EMAIL_HAS_NOT_CHANGED"
    case wrongPassword = "WRONG_PASSWORD"
    case userNotFound = "USER_NOT_FOUND"

    func fetchMessage() -> String? {
        let const = L10n.ApiErrors.Identifire.self
        switch self {
        case .wrongCredentials:
            return const.wrongCredentials
        case .userNotVerified:
            return const.userNotVerified
        case .userWasBlocked:
            return const.userWasBlocked
        case .userAlredyExists:
            return const.userAlredyExists
        case .emailHasNotChanged:
            return const.emailHasNotChanged
        case .wrongPassword:
            return const.wrongPassword
        case .userNotFound:
            return const.userNotFound
        }
    }
}

public enum ErrorMessageByCode: Int, Codable {
    case notFound = 404
    case unauthorized = 401
    case serverIsNotAvailable = 500
    case tooManyRequests  = 429
    case userWasBlocked = 403
    case unprocessableEntity = 422

    func fetchMessage() -> String? {
        let const = L10n.ApiErrors.Code.self
        switch self {
        case .notFound:
            return const.notFound
        case .serverIsNotAvailable:
            return const.serverIsNotAvailable
        case .tooManyRequests:
            return const.tooManyRequests
        case .unauthorized:
            return const.unauthorized
        case .userWasBlocked:
            return const.userWasBlocked
        case .unprocessableEntity:
            return const.unprocessableEntity
        }
    }
}
