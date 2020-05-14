import Foundation
import Moya
import DITranquillity

final class MoyaPluginFactoryPart: DIPart {
    static func load(container: DIContainer) {
        container.register(MoyaPluginFactoryImpl.init)
            .as(MoyaPluginFactory.self)
            .lifetime(.single)
    }
}

protocol MoyaPluginFactory {
}

final class MoyaPluginFactoryImpl: MoyaPluginFactory {
}
