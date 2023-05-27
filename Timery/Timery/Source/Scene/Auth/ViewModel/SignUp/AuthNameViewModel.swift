import Foundation
import Moya
import RxSwift
import RxCocoa

class AuthNameViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()

    struct Input {
        let nameText: Driver<String>
        let tapNextButton: Signal<Void>
    }

    struct Output {
        let isNameError: Driver<Bool>
        let buttonActivate: Driver<Bool>
        let gotoNext: Signal<Bool>
    }

    var nameText: String = ""
    var userEntity = UserSignupEntity.shared
    let gotoNext = PublishRelay<Bool>()

    func transform(input: Input) -> Output {
        let isNameError = input.nameText.map {
            if !$0.isEmpty {
                return !$0.isAbleRegex(regex: "^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]{1,20}$")
            } else {
                return false
            }
        }
        let isButtonActivate = input.nameText.map {
            $0.isAbleRegex(regex: "^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]{1,20}$")
        }

        input.nameText.asObservable()
            .subscribe { text in
                self.nameText = text
            }
            .disposed(by: disposeBag)

        input.tapNextButton.asObservable()
            .subscribe(onNext: {
                self.userEntity.name = self.nameText
                self.gotoNext.accept(true)
            })
            .disposed(by: disposeBag)

        return Output(
            isNameError: isNameError,
            buttonActivate: isButtonActivate,
            gotoNext: gotoNext.asSignal()
        )
    }
}
