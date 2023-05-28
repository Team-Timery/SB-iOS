import Foundation
import RxSwift
import RxCocoa

class StopTimerAlertViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()

    struct Input {
        let stopTimer: Signal<Void>
        let startTime: Driver<Date>
        let memo: Driver<String>
        let subjectID: Driver<Int>
    }

    struct Output {
        let isSucceed: Signal<Void>
        let isButtonActivate: Driver<Bool>
    }

    func transform(input: Input) -> Output {
        let service = RecordService()
        let isButtonActivate = input.memo.map {
            if !$0.isEmpty {
                return $0.count <= 20
            } else { return true }
        }
        let info = Driver.combineLatest(input.subjectID, input.startTime, input.memo)
        let isSucceed = PublishRelay<Void>()

        input.stopTimer.asObservable().withLatestFrom(info)
            .take(1)
            .flatMapLatest { subjectID, startTime, memo in
                service.createRecord(subjectID: subjectID, startTime: startTime, stopTime: Date(), memo: memo)
            }
            .subscribe(onNext: { res in
                switch res {
                case .SUCCEED:
                    isSucceed.accept(())
                default:
                    print(res.errorMessage)
                }
            })
            .disposed(by: disposeBag)

        return Output(
            isSucceed: isSucceed.asSignal(),
            isButtonActivate: isButtonActivate.asDriver()
        )
    }
}
