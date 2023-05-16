import Foundation
import RxSwift
import RxCocoa

class FAQViewModel: ViewModelType {
    var disposedBag: DisposeBag = DisposeBag()

    struct Input {
        let getData: Signal<Void>
    }

    struct Output {
        let content: Signal<FAQListEntity>
    }

    func transform(input: Input) -> Output {
        let service = DocumentService()
        let contentData = PublishRelay<FAQListEntity>()

        input.getData.asObservable()
            .flatMap {
                service.getFAQ()
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
