import RxSwift

final class TextInputViewModel: ViewModelType {
    struct Input {}

    struct Output {}

    var disposeBag: DisposeBag = DisposeBag()

    init() {}

    func transform(input: Input) -> Output {
        return Output()
    }
}
