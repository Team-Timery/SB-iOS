import Foundation
import RxSwift
import RxCocoa

class StopTimerAlertViewModel: ViewModelType {
    var disposedBag: DisposeBag = DisposeBag()

    struct Input {
        let stopTimer: Signal<Void>
        let startTime: Driver<Date>
        let memo: Driver<String>
        let subjectID: Driver<Int>
    }

    struct Output {
        let isSucceed: Signal<Void>
    }

    func transform(input: Input) -> Output {
        let service = RecordService()
        let info = Driver.combineLatest(input.subjectID, input.startTime, input.memo)
        let isSucceed = PublishRelay<Void>()

        input.stopTimer.asObservable().withLatestFrom(info)
            .flatMap { subjectID, startTime, memo in
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
            .disposed(by: disposedBag)

        return Output(isSucceed: isSucceed.asSignal())
    }
}
