import Foundation
import RxSwift
import RxCocoa

class CreateAlertViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()

    struct Input {
        let createButtonTap: Signal<Void>
        let title: Driver<String>
        let emoji: Driver<String>
    }

    struct Output {
        let isSucceed: Signal<Void>
        let isError: Signal<String>
        let isActivate: BehaviorRelay<Bool>
    }

    func transform(input: Input) -> Output {
        let subjectService = SubjectService()
        let subjectInfo = Driver.combineLatest(input.title, input.emoji)
        let isSucceed = PublishRelay<Void>()
        let isError = PublishRelay<String>()
        let isActivate = BehaviorRelay<Bool>(value: false)

        input.createButtonTap.asObservable().withLatestFrom(subjectInfo)
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .flatMap { title, emoji in
                subjectService.createMySubject(title: title, emoji: emoji)
            }
            .subscribe(onNext: { res in
                switch res {
                case .SUCCEED:
                    isSucceed.accept(())
                default:
                    isError.accept(res.errorMessage)
                }
            })
            .disposed(by: disposeBag)

        input.title.asObservable()
            .subscribe(onNext: { text in
                isActivate.accept(text.isAbleRegex(regex: "^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]{1,5}$"))
            })
            .disposed(by: disposeBag)

        return Output(
            isSucceed: isSucceed.asSignal(),
            isError: isError.asSignal(),
            isActivate: isActivate
        )
    }
}
