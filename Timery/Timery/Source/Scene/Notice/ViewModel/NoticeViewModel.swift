import Foundation
import RxSwift
import RxCocoa

class NoticeViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()

    struct Input {
        let getData: Signal<Void>
    }

    struct Output {
        let content: Signal<NoticeListEntity>
    }

    func transform(input: Input) -> Output {
        let service = DocumentService()
        let contentData = PublishRelay<NoticeListEntity>()

        input.getData.asObservable()
            .flatMap {
                service.getNotice()
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
            .disposed(by: disposeBag)

        return Output(content: contentData.asSignal())
    }
}
