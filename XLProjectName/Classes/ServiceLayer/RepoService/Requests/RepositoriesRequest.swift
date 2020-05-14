import Moya

public struct RepositoriesRequest: MoyaTargetType {
    typealias Response = [Repo]

    public var method: Moya.Method = .get
    public var path: String = "/repositories"
    var parameters: [String: Any] = [:]

    public var authorizationType: AuthorizationType? {
        return .bearer
    }

    public var task: Task {
        return .requestParameters(parameters: self.parameters, encoding: URLEncoding.queryString)
    }

    init(since page: Int) {
        parameters = [
            "per_page": 10,
            "page": page
        ]
    }
}
