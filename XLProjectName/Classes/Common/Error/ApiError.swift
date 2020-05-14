public final class ApiError: Decodable, Error, CustomStringConvertible {
    var code: Int = 0
    var message: String = "unknown"
    var errorDescription: String = "unknown"

    public init(from decoder: Decoder) throws {
        try decoder.apply { (values) in
            self.code <- values["code"]
            self.message <- values["message"]
            self.errorDescription <- values["description"]
        }
    }

    public var description: String {
        return message
    }
}

public final class ErrorResponse: Decodable {
    var status: Bool = true
    var errors: [ApiError?] = []

    public init(from decoder: Decoder) throws {
        try decoder.apply { (values) in
            self.status <- values["status"]
            self.errors <- values["errors"]
        }
    }
}
