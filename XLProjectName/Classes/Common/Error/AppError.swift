import Alamofire
import Foundation
import LocalAuthentication

public protocol ErrorDisplayable {
    var displayMessage: String? { get }
}

public protocol ErrorCode {
    var code: Int? { get }
}

public enum AppError: Error {
    case apisError(code: Int, identifire: String, errorDescription: String)
    case responseError(code: Int)
    case noInternetError
}

extension AppError: ErrorDisplayable {
    public var displayMessage: String? {
        switch self {
        case let .apisError(item):
            if let message = ErrorMessageByIdentifire(rawValue: item.identifire) {
                return message.fetchMessage()
            }
            if let message = ErrorMessageByCode(rawValue: item.code) {
                return message.fetchMessage()
            }
            return item.errorDescription
        case let .responseError(code):
            guard let message = ErrorMessageByCode(rawValue: code) else {
                return L10n.ApiErrors.Code.notFound
            }
            return message.fetchMessage()
        case .noInternetError:
            return L10n.ApiErrors.noInternet
        }
    }
}

extension AppError: ErrorCode {
    public var code: Int? {
        switch self {
        case let .apisError(item):
            return item.code
        case let .responseError(code):
            return code
        case .noInternetError:
            return 522
        }
    }
}

extension AFError: ErrorDisplayable {
    public var displayMessage: String? {
        return  "Network \(self.responseCode ?? -1)"
    }
}

extension Error {
    var code: Int {
        if let codeRequest = (self as? ErrorCode)?.code {
            return codeRequest
        }
        return 0
    }

    var message: String {
        if let text = (self as? ErrorDisplayable)?.displayMessage {
            return text
        }
        if let text = self._userInfo?[NSLocalizedDescriptionKey] as? String {
            return text
        }
        return "\(self)"
    }
}
