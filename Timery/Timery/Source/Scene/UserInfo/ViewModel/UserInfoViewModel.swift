import Foundation
import RxSwift
import RxCocoa

class UserInfoViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()

    struct Input {
        let getProfile: Signal<Void>
    }

    struct Output {
        let isSucceed: Signal<UserProfileEntity>
    }

    func transform(input: Input) -> Output {
        let service = AuthService()
        let isSucceed = PublishRelay<UserProfileEntity>()

        input.getProfile.asObservable()
            .flatMap {
                service.getUserProfile()
            }
            .subscribe(onNext: { data, res in
                switch res {
                case .SUCCEED:
                    guard let data = data else { return }
                    isSucceed.accept(data)
                default:
                    print(res.errorMessage)
                }
            })
            .disposed(by: disposeBag)

        return Output(isSucceed: isSucceed.asSignal())
    }
}
