// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen
// Updated by Allui

import Foundation
import Localize_Swift

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
internal enum L10n {

  internal enum ApiErrors {
    /// Отсутствует интернет-соединение
    internal static var noInternet: String {
        return L10n.tr("Localizable", "api_errors.no_internet")
    }

    internal enum Code {
      /// 404 Сервер не найден
      internal static var notFound: String {
          return L10n.tr("Localizable", "api_errors.code.not_found")
      }
      /// Сервер временно недоступен
      internal static var serverIsNotAvailable: String {
          return L10n.tr("Localizable", "api_errors.code.server_is_not_available")
      }
      /// Привышено число запросов к серверу
      internal static var tooManyRequests: String {
          return L10n.tr("Localizable", "api_errors.code.too_many_requests")
      }
      /// Не авторизован
      internal static var unauthorized: String {
          return L10n.tr("Localizable", "api_errors.code.unauthorized")
      }
      /// Контент больше не существует
      internal static var unprocessableEntity: String {
          return L10n.tr("Localizable", "api_errors.code.unprocessable_entity")
      }
      /// Ваш аккаунт заблокирован, обратитесь в тех.поддержку
      internal static var userWasBlocked: String {
          return L10n.tr("Localizable", "api_errors.code.user_was_blocked")
      }
    }

    internal enum Identifire {
      /// Email не изменен
      internal static var emailHasNotChanged: String {
          return L10n.tr("Localizable", "api_errors.identifire.email_has_not_changed")
      }
      /// Пользователь с данным email уже существует
      internal static var userAlredyExists: String {
          return L10n.tr("Localizable", "api_errors.identifire.user_alredy_exists")
      }
      /// Такого пользователя не существует
      internal static var userNotFound: String {
          return L10n.tr("Localizable", "api_errors.identifire.user_not_found")
      }
      /// Пользователь не верефицирован
      internal static var userNotVerified: String {
          return L10n.tr("Localizable", "api_errors.identifire.user_not_verified")
      }
      /// Ваш аккаунт заблокирован, обратитесь в тех.поддержку
      internal static var userWasBlocked: String {
          return L10n.tr("Localizable", "api_errors.identifire.user_was_blocked")
      }
      /// Email или пароль введены неверно
      internal static var wrongCredentials: String {
          return L10n.tr("Localizable", "api_errors.identifire.wrong_credentials")
      }
      /// Неверный пароль
      internal static var wrongPassword: String {
          return L10n.tr("Localizable", "api_errors.identifire.wrong_password")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    return String(format: key.localized(using: table), arguments: args)
  }
}

private final class BundleToken {}
