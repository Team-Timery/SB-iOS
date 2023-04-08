import Foundation
import Moya
import RxSwift
import RxCocoa

class AuthStartViewModel: ViewModelType {
    struct Input {
        let googleOauthSignal: Signal<Void>
        let appleOauthSignal: Signal<Void>
    }

    struct Output {
        let googleOauthAction: Signal<Bool>
        let appleOauthAction: Signal<Bool>
    }

    private let googleOauthAction = PublishRelay<Bool>()
    private let appleOauthAction = PublishRelay<Bool>()

    var disposedBag = DisposeBag()

    func transform(input: Input) -> Output {
        input.appleOauthSignal
            .emit { [unowned self] _ in
                appleOauthAction.accept(true)
            }
            .disposed(by: disposedBag)

        input.googleOauthSignal
            .emit { [unowned self] _ in
                googleOauthAction.accept(true)
            }
            .disposed(by: disposedBag)

        return Output(
            googleOauthAction: googleOauthAction.asSignal(),
            appleOauthAction: appleOauthAction.asSignal()
        )
    }
}
