import Foundation
import Moya
import RxSwift
import RxCocoa

class AuthStartViewModel: ViewModelType {
    struct Input {
        let autoLogin: Signal<Void>
    }

    struct Output {
        let isSucceed: PublishRelay<Void>
        let isError: PublishRelay<AuthServiceResult>
    }

    var disposeBag = DisposeBag()
    let userID = BehaviorRelay<String>(value: "")
    let userPassword = BehaviorRelay<String>(value: "")

    func transform(input: Input) -> Output {
        let service = AuthService()
        let isSucceed = PublishRelay<Void>()
        let isError = PublishRelay<AuthServiceResult>()
//        if let userID = AutoLoginData.identification,
//           let userPW = AutoLoginData.password {
//            self.userID.accept(userID)
//            self.userPassword.accept(userPW)
//        } else {
//            isError.accept()
//        }
//        let info = Observable.combineLatest(userID, userPassword)
//        input.autoLogin.asObservable()
//            .withLatestFrom(info)
//            .flatMap { id, password in
//                service.login(email: id, password: password)
//            }
//            .subscribe(onNext: { res in
//                switch res {
//                case .SUCCEED:
//                    isSucceed.accept(())
//                default:
//                    isError.accept(())
//                }
//            })
//            .disposed(by: disposeBag)
        input.autoLogin.asObservable()
            .flatMap {
                service.anonymousLogin()
            }
            .subscribe(onNext: { res in
                switch res {
                case .SUCCEED:
                    isSucceed.accept(())
                default:
                    isError.accept(res)
                }
            })
            .disposed(by: disposeBag)

        return Output(
            isSucceed: isSucceed,
            isError: isError
        )
    }
}
