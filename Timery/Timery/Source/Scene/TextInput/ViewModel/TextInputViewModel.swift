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
    }

    private(set) var disposeBag: DisposeBag = DisposeBag()
    private let completionHandler: (String) -> Void

    init(completeionHandler: @escaping (String) -> Void) {
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
            .bind(to: contentTextRelay)
            .disposed(by: disposeBag)

        return Output(
            contentText: contentTextRelay.asDriver(),
            completionHandled: completionHandleRelay.asDriver(onErrorJustReturn: ())
        )
    }
}
