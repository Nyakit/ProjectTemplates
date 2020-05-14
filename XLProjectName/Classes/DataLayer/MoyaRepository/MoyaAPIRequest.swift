import Foundation
import Moya

protocol MoyaTargetType: DecodableTargetType {
}

extension MoyaTargetType {
    private func fetchLocalize() -> String {
        let langCode = Locale.current.languageCode ?? "en"
        let regionCode = Locale.current.regionCode ?? "US"
        return  "\(langCode)-\(regionCode)"
    }

    public var baseURL: URL {
        return URL(string: Configuration.server)!
    }

    public var headers: [String: String]? {
        return ["Content-type": "application/json",
                "Accept": "application/json",
                "Accept-Language": fetchLocalize()]
    }

    public var sampleData: Data {
        let path = Bundle.main.path(forResource: "samples", ofType: "json")!
        return FileHandle(forReadingAtPath: path)!.readDataToEndOfFile()
    }

    public var task: Task {
        return .requestPlain
    }
}

public struct Unit: Codable, ExpressibleByNilLiteral {
    public init() {}
    public init(nilLiteral: ()) {}
}
