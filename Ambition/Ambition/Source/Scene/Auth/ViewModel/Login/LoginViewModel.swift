import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: ViewModelType {
    var disposedBag: DisposeBag = DisposeBag()

    struct Input {
        let idText: Driver<String>
        let passwordText: Driver<String>
        let tapNextButton: Signal<Void>
    }

    struct Output {
        let buttonActivate: Driver<Bool>
        let isEmailError: Driver<Bool>
        let isPasswordError: Driver<Bool>
        let isLoading: Signal<Bool>
        let isError: Signal<AuthServiceResult>
        let isSucceed: Signal<Bool>
    }

    var userEntity = UserSignupEntity.shared
    let buttonActivate = BehaviorRelay<Bool>(value: false)
    let isLoading = PublishRelay<Bool>()
    let isError = PublishRelay<AuthServiceResult>()
    let isSucceed = PublishRelay<Bool>()

    func transform(input: Input) -> Output {
        let authService = AuthService()
        let info = Driver.combineLatest(input.idText, input.passwordText)
        let isEmailError = info.map {
            if !$0.0.isEmpty {
                return !$0.0.isAbleRegex( regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}" )
            } else { return false }
        }
        let isPasswordError = info.map {
            if !$0.1.isEmpty {
                return !$0.1.isAbleRegex( regex: "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,30}" )
            } else { return false }
        }
        let isEnable = info.map {
            $0.0.isAbleRegex(
                regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            ) && $0.1.isAbleRegex(
                regex: "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,30}"
            )
        }
        input.tapNextButton.asObservable()
            .bind { self.isLoading.accept(true) }
            .disposed(by: disposedBag)

        input.tapNextButton.asObservable().withLatestFrom(info)
            .flatMap { id, pwd in
                authService.login(email: id, password: pwd)
            }
            .subscribe(onNext: { res in
                switch res {
                case .SUCCEED: self.isSucceed.accept(true)
                default:
                    self.isError.accept(res)
                }
                self.isLoading.accept(false)
            })
            .disposed(by: disposedBag)

        return Output(
            buttonActivate: isEnable.asDriver(onErrorJustReturn: false),
            isEmailError: isEmailError,
            isPasswordError: isPasswordError,
            isLoading: isLoading.asSignal(),
            isError: isError.asSignal(),
            isSucceed: isSucceed.asSignal()
        )
    }
}
