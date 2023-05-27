import Foundation
import RxCocoa
import RxSwift
import Moya
import RxMoya

class AuthTermsViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()

    struct Input {
        let allTogleSelect: ControlEvent<Void>
        let form1TogleSelect: ControlEvent<Void>
        let form2TogleSelect: ControlEvent<Void>
        let form3TogleSelect: ControlEvent<Void>
        let form4TogleSelect: ControlEvent<Void>
        let tapNextButton: Signal<Void>
    }

    struct Output {
        let allTogleStatus: Driver<Bool>
        let form1TogleStatus: Driver<Bool>
        let form2TogleStatus: Driver<Bool>
        let form3TogleStatus: Driver<Bool>
        let form4TogleStatus: Driver<Bool>
        let buttonActivate: Signal<Bool>
        let isSucceed: Signal<Void>
        let isError: Signal<AuthServiceResult>
    }

    let allToggle = BehaviorRelay<Bool>(value: false)
    let form1Toggle = BehaviorRelay<Bool>(value: false)
    let form2Toggle = BehaviorRelay<Bool>(value: false)
    let form3Toggle = BehaviorRelay<Bool>(value: false)
    let form4Toggle = BehaviorRelay<Bool>(value: false)
    let isSucceed = PublishRelay<Void>()
    let isError = PublishRelay<AuthServiceResult>()
    var userEntity = UserSignupEntity.shared

// swiftlint: disable function_body_length
    func transform(input: Input) -> Output {
        let authService = AuthService()
        let info = Observable.combineLatest(form1Toggle, form2Toggle, form3Toggle)
        let isActivate = info.map { $0.0 && $0.1 && $0.2 }

        input.tapNextButton.asObservable()
            .flatMap {
                authService.signup(
                    email: self.userEntity.id,
                    password: self.userEntity.password,
                    name: self.userEntity.name,
                    age: self.userEntity.age,
                    sex: self.userEntity.sex,
                    isMarketing: self.userEntity.isMarketingAgree
                )
            }
            .subscribe(onNext: { [unowned self] res in
                switch res {
                case .SUCCEED:
                    isSucceed.accept(())
                default:
                    isError.accept(res)
                }
            })
            .disposed(by: disposeBag)
        input.allTogleSelect.asObservable()
            .withLatestFrom(self.allToggle)
            .subscribe(onNext: { status in
                self.allToggle.accept(!status)
                if !status {
                    [
                        self.form1Toggle,
                        self.form2Toggle,
                        self.form3Toggle,
                        self.form4Toggle
                    ].forEach({ $0.accept(true) })
                    self.userEntity.isMarketingAgree = true
                }
            })
            .disposed(by: disposeBag)
        input.form1TogleSelect.asObservable()
            .withLatestFrom(self.form1Toggle)
            .subscribe(onNext: { status in
                self.form1Toggle.accept(!status)
                self.allToggle.accept(false)
            })
            .disposed(by: disposeBag)
        input.form2TogleSelect.asObservable()
            .withLatestFrom(self.form2Toggle)
            .subscribe(onNext: { status in
                self.form2Toggle.accept(!status)
                self.allToggle.accept(false)
            })
            .disposed(by: disposeBag)
        input.form3TogleSelect.asObservable()
            .withLatestFrom(self.form3Toggle)
            .subscribe(onNext: { status in
                self.form3Toggle.accept(!status)
                self.allToggle.accept(false)
            })
            .disposed(by: disposeBag)
        input.form4TogleSelect.asObservable()
            .withLatestFrom(self.form4Toggle)
            .subscribe(onNext: { status in
                self.form4Toggle.accept(!status)
                self.userEntity.isMarketingAgree = !status
                self.allToggle.accept(false)
            })
            .disposed(by: disposeBag)

        return Output(
            allTogleStatus: allToggle.asDriver(),
            form1TogleStatus: form1Toggle.asDriver(),
            form2TogleStatus: form2Toggle.asDriver(),
            form3TogleStatus: form3Toggle.asDriver(),
            form4TogleStatus: form4Toggle.asDriver(),
            buttonActivate: isActivate.asSignal(onErrorJustReturn: false),
            isSucceed: isSucceed.asSignal(),
            isError: isError.asSignal()
        )
    }
    // swiftlint: enable function_body_length
}
