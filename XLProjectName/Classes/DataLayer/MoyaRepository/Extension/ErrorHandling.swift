import RxSwift
import Foundation
import Moya
import Alamofire

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func filterSuccess(secondTry: Bool = false) -> Single<Response> {
        return flatMap { response -> Single<Response> in
            if 200 ... 299 ~= response.statusCode {
                return .just(response)
            }
            return self.parsingErrors(with: response)
        }
    }

    fileprivate func parsingErrors(with response: Response) -> Single<Response> {
        let model = try? JSONDecoder().decode(ErrorResponse.self, from: response.data)
        if let errors = model?.errors,
            let error = errors.first,
            let identifire = error?.message,
            let errorDescription = error?.errorDescription {
            return .error(AppError.apisError(code: response.statusCode,
                                             identifire: identifire,
                                             errorDescription: errorDescription))
        }
        return .error(AppError.responseError(code: response.statusCode))
    }
}
