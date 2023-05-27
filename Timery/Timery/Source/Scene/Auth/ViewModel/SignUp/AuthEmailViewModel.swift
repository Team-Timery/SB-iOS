import Foundation
import Moya
import RxSwift
import RxCocoa

class AuthEmailViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()

    struct Input {
        let idText: Driver<String>
        let tapNextButton: Signal<Void>
    }

    struct Output {
        let isIDError: Driver<Bool>
        let buttonActivate: Driver<Bool>
        let gotoNext: Signal<Bool>
    }

    var idText: String = ""
    var userEntity = UserSignupEntity.shared
    let gotoNext = PublishRelay<Bool>()

    func transform(input: Input) -> Output {
        let isIDError = input.idText.map {
            if !$0.isEmpty {
                return !$0.isAbleRegex(regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
            } else {
                return false
            }
        }
        let isButtonActivate = input.idText.map {
            $0.isAbleRegex(regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        }
        input.idText.asObservable()
            .subscribe { text in
                self.idText = text
            }
            .disposed(by: disposeBag)

        input.tapNextButton.asObservable()
            .subscribe(onNext: {
                self.userEntity.id = self.idText
                self.gotoNext.accept(true)
            })
            .disposed(by: disposeBag)

        return Output(
            isIDError: isIDError,
            buttonActivate: isButtonActivate,
            gotoNext: gotoNext.asSignal()
        )
    }
}
