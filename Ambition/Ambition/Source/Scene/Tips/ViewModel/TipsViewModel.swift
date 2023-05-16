import Foundation
import RxSwift
import RxCocoa

class TipsViewModel: ViewModelType {
    var disposedBag: DisposeBag = DisposeBag()

    struct Input {
        let getData: Signal<Void>
    }

    struct Output {
        let content: Signal<TipsListEntity>
    }

    func transform(input: Input) -> Output {
        let service = DocumentService()
        let contentData = PublishRelay<TipsListEntity>()

        input.getData.asObservable()
            .flatMap {
                service.getTips()
            }
            .subscribe(onNext: { data, res in
                switch res {
                case .SUCCEED:
                    guard let content = data else { return }
                    contentData.accept(content)
                default:
                    print(res.errorMessage)
                }
            })
            .disposed(by: disposedBag)
        return Output(content: contentData.asSignal())
    }
}
