import RxSwift
import RxCocoa
import RxRelay

final class TextInputViewModel: ViewModelType {
    struct Input {
        let completeButtonDidTap: Observable<Void>
        let contentTextDidChange: Observable<String>
    }

    struct Output {
        let contentText: Driver<String>
        let completionHandled: Driver<Void>
        let maxInputCount: Driver<Int>
    }

    private(set) var disposeBag: DisposeBag = DisposeBag()
    private let maxInputCount: Int
    private let completionHandler: (String) -> Void

    init(
        maxInputCount: Int = 20,
        completeionHandler: @escaping (String) -> Void
    ) {
        self.maxInputCount = maxInputCount
        self.completionHandler = completeionHandler
    }

    func transform(input: Input) -> Output {
        let contentTextRelay = BehaviorRelay(value: "")
        let completionHandleRelay = PublishRelay<Void>()

        input.completeButtonDidTap
            .map { contentTextRelay.value }
            .map { [completionHandler] in completionHandler($0) }
            .bind(to: completionHandleRelay)
            .disposed(by: disposeBag)

        input.contentTextDidChange
            .map { [maxInputCount] in $0.prefix(maxInputCount) }
            .map(String.init)
            .bind(to: contentTextRelay)
            .disposed(by: disposeBag)

        let maxInputCountDriver = Observable.just(maxInputCount)
            .asDriver(onErrorJustReturn: maxInputCount)

        return Output(
            contentText: contentTextRelay.asDriver(),
            completionHandled: completionHandleRelay.asDriver(onErrorJustReturn: ()),
            maxInputCount: maxInputCountDriver
        )
    }
}
