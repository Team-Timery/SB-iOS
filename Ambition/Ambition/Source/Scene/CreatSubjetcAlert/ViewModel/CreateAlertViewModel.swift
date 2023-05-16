import Foundation
import RxSwift
import RxCocoa

class CreateAlertViewModel: ViewModelType {
    var disposedBag: DisposeBag = DisposeBag()

    struct Input {
        let createButtonTap: Signal<Void>
        let title: Driver<String>
        let emoji: Driver<String>
    }

    struct Output {
        let isSucceed: PublishRelay<Bool>
        let isActivate: BehaviorRelay<Bool>
    }

    func transform(input: Input) -> Output {
        let subjectService = SubjectService()
        let subjectInfo = Driver.combineLatest(input.title, input.emoji)
        let isSucceed = PublishRelay<Bool>()
        let isActivate = BehaviorRelay<Bool>(value: false)

        input.createButtonTap.asObservable().withLatestFrom(subjectInfo)
            .flatMap { title, emoji in
                subjectService.createMySubject(title: title, emoji: emoji)
            }
            .subscribe(onNext: { res in
                switch res {
                case .SUCCEED:
                    isSucceed.accept(true)
                default:
                    print(res.errorMessage)
                }
            })
            .disposed(by: disposedBag)

        input.title.asObservable()
            .subscribe(onNext: { text in
                isActivate.accept(text.isAbleRegex(regex: "^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]{1,5}$"))
            })
            .disposed(by: disposedBag)

        return Output(
            isSucceed: isSucceed,
            isActivate: isActivate
        )
    }
}
