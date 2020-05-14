import DITranquillity
import Foundation
import RxCocoa
import RxSwift

class RepoServicePart: DIPart {
    static func load(container: DIContainer) {
        container.register(RepoServiceImp.init)
            .as(RepoService.self)
            .injection(cycle: true, { $0.moyaProvider = $1 })
            .lifetime(.single)
        container.registerMoyaProvider(verbose: true, cURL: true)
    }
}

protocol RepoService {
    func fetchRepos(since id: Int) -> Single<[Repo]>
}

final class RepoServiceImp: RepoService {
    private let schedulers: SchedulerProvider
    var moyaProvider: MultiMoyaProvider

    init(schedulers: SchedulerProvider,
         moyaProvider: MultiMoyaProvider) {
        self.schedulers = schedulers
        self.moyaProvider = moyaProvider
    }

    func fetchRepos(since id: Int) -> Single<[Repo]> {
        return Single.deferred { [unowned self] in
            let request = RepositoriesRequest(since: id)
            return self.moyaProvider
                .request(request)
        }
            .subscribeOn(self.schedulers.background)
            .observeOn(self.schedulers.main)
    }
}
