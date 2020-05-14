import Foundation
import Localize_Swift

public enum Language: String {
    case ru
    case en
    
    private static let names: [Language: String] = [
        .ru : "Русский",
        .en : "English"
    ]
    
    static var current: Language? {
        return Language(rawValue: Localize.currentLanguage())
    }
    
    var name: String {
        return Language.names[self, default: ""]
    }
    
    var locale: Locale? {
        return Locale(identifier: self.rawValue)
    }
}
