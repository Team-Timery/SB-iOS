import Foundation
import RxMoya
import Moya
import RxSwift
import RxCocoa

class MoreViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()

    struct Input {
        let logout: Signal<Void>
        let quitUser: Signal<Void>
    }

    struct Output {
        let isLogoutSucceed: Signal<Void>
        let isQuitUserSucceed: Signal<Void>
    }

    func transform(input: Input) -> Output {
        let service = AuthService()
        let isLogoutSucceed = PublishRelay<Void>()
        let isQuitUserSucceed = PublishRelay<Void>()

        input.logout.asObservable()
            .take(1)
            .flatMap {
                service.logout()
            }
            .subscribe(onNext: { res in
                switch res {
                case .SUCCEED:
                    isLogoutSucceed.accept(())
                default:
                    print(res.errorMessage)
                }
            })
            .disposed(by: disposeBag)

        input.quitUser.asObservable()
            .take(1)
            .flatMap {
                service.deleteUser()
            }
            .subscribe(onNext: { res in
                switch res {
                case .SUCCEED:
                    isQuitUserSucceed.accept(())
                default:
                    print(res.errorMessage)
                }
            })
            .disposed(by: disposeBag)

        return Output(
            isLogoutSucceed: isLogoutSucceed.asSignal(),
            isQuitUserSucceed: isQuitUserSucceed.asSignal()
        )
    }
}
