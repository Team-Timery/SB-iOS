import Foundation
import Moya
import RxSwift
import RxCocoa

class AuthPasswordViewModel: ViewModelType {
    var disposedBag: DisposeBag = DisposeBag()

    struct Input {
        let passwordText: Driver<String>
        let tapNextButton: Signal<Void>
    }

    struct Output {
        let isPWError: Driver<Bool>
        let buttonActivate: Driver<Bool>
        let gotoNext: Signal<Bool>
    }

    var passwordText: String = ""
    var userEntity = UserSignupEntity.shared
    let gotoNext = PublishRelay<Bool>()

    func transform(input: Input) -> Output {
        let isPWError = input.passwordText.map {
            if !$0.isEmpty {
                return !$0.isAbleRegex(regex: "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,30}")
            } else {
                return false
            }
        }
        let isButtonActivate = input.passwordText.map {
            $0.isAbleRegex(regex: "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,30}")
        }

        input.passwordText.asObservable()
            .subscribe { text in
                self.passwordText = text
            }
            .disposed(by: disposedBag)

        input.tapNextButton.asObservable()
            .subscribe(onNext: {
                self.userEntity.password = self.passwordText
                self.gotoNext.accept(true)
            })
            .disposed(by: disposedBag)

        return Output(
            isPWError: isPWError,
            buttonActivate: isButtonActivate,
            gotoNext: gotoNext.asSignal()
        )
    }
}
