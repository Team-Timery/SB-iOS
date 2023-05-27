import Foundation
import RxCocoa
import RxSwift
import RxMoya

class AuthAgeSexViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()

    struct Input {
        let ageValue: Driver<Any?>
        let sexValue: Driver<Any?>
        let tapNextButton: Signal<Void>
    }

    struct Output {
        let buttonActivate: Driver<Bool>
        let gotoNext: Signal<Bool>
    }

    var ageSelect = BehaviorRelay<Bool>(value: false)
    var sexSelect = BehaviorRelay<Bool>(value: false)
    var userEntity = UserSignupEntity.shared
    let gotoNext = PublishRelay<Bool>()

    func transform(input: Input) -> Output {
        let info = Observable.combineLatest(ageSelect, sexSelect)
        let isActivate = info.map { $0.0 && $0.1 }
        input.ageValue.asObservable()
            .filter { $0 != nil }
            .subscribe(onNext: { value in
                guard let value = value as? Int else { return }
                self.userEntity.age = value
                self.ageSelect.accept(true)
            })
            .disposed(by: disposeBag)

        input.sexValue.asObservable()
            .filter { $0 != nil }
            .subscribe(onNext: { value in
                guard let value = value as? String else { return }
                self.userEntity.sex = value
                self.sexSelect.accept(true)
            })
            .disposed(by: disposeBag)

        input.tapNextButton.asObservable()
            .subscribe(onNext: {
                self.gotoNext.accept(true)
            })
            .disposed(by: disposeBag)

        return Output(
            buttonActivate: isActivate.asDriver(onErrorJustReturn: false),
            gotoNext: gotoNext.asSignal()
        )
    }
}
