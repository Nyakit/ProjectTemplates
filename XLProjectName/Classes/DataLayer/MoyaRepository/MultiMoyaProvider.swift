import Moya
import RxMoya
import UIKit
import RxSwift
import DITranquillity

class RequestProvider<T> {
    func request(_ token: T) -> Single<Response> {
        fatalError("Abstract class is used as a protocol with generic. This method should be overriden.")
    }
}

extension DIContainer {
    func registerMoyaProvider(verbose: Bool, cURL: Bool) {
        register { (factory: MoyaPluginFactory,
            schedulers: SchedulerProvider) in
            MultiMoyaProvider.init(schedulers: schedulers)
        }
        .as(RequestProvider<MultiTarget>.self)
        .lifetime(.objectGraph)
    }
}

final class MultiMoyaProvider: RequestProvider<MultiTarget> {

    private let provider: MoyaProvider<MultiTarget>
    private let schedulers: SchedulerProvider

    init(endpointClosure: @escaping MoyaProvider<MultiTarget>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
         requestClosure: @escaping MoyaProvider<MultiTarget>.RequestClosure = MoyaProvider<MultiTarget>.defaultRequestMapping,
         stubClosure: @escaping MoyaProvider<MultiTarget>.StubClosure = MoyaProvider.neverStub,
         callbackQueue: DispatchQueue? = .main,
         session: Session = MoyaProvider<MultiTarget>.defaultAlamofireSession(),
         plugins: [PluginType] = [],
         trackInflights: Bool = true,
         schedulers: SchedulerProvider
    ) {
        self.schedulers = schedulers

        provider = MoyaProvider<MultiTarget>(endpointClosure: endpointClosure,
                                             requestClosure: requestClosure,
                                             stubClosure: stubClosure,
                                             session: session,
                                             plugins: plugins,
                                             trackInflights: trackInflights)
    }

    func request<T: DecodableTargetType>(_ request: T) -> Single<T.Response> {
        guard Connectivity.isConnectedToInternet() else {
            return Single.error(AppError.noInternetError)
        }

        return Single.deferred { [unowned self] in
            let target = MultiTarget(request)
            return self.provider.rx.request(target)
                .filterSuccess()
                .map(T.Response.self, failsOnEmptyData: false)
        }
        .subscribeOn(self.schedulers.background)
        .observeOn(self.schedulers.main)
    }
}

protocol DecodableTargetType: Moya.TargetType {
    associatedtype Response: Decodable
}
