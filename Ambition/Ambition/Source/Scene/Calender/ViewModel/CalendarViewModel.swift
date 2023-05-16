import Foundation
import RxSwift
import RxCocoa

class CalendarViewModel: ViewModelType {
    var disposedBag: DisposeBag = DisposeBag()

    struct Input {
        let selectDate: Signal<String>
        let getMonthOfRecordDay: Driver<String>
    }

    struct Output {
        let timeLineDate: Signal<RecordListEntity>
        let monthRecordDay: Signal<MonthOfRecordDayEntity>
        let calendarTimeData: Signal<CalendarTimeEntity>
        let isEmptyData: Driver<Bool>
    }
// swiftlint: disable function_body_length
    func transform(input: Input) -> Output {
        let service = RecordService()
        let recordRelay = PublishRelay<RecordListEntity>()
        let calendarTimeRelay = PublishRelay<CalendarTimeEntity>()
        let monthRecordRelay = PublishRelay<MonthOfRecordDayEntity>()
        let isEmptyData = PublishRelay<Bool>()

        input.selectDate.asObservable()
            .flatMap { date in
                service.getDayOfRecord(date: date)
            }
            .subscribe(onNext: { data, res in
                switch res {
                case .SUCCEED:
                    guard let recordData = data, !recordData.recordResponses.isEmpty else {
                        isEmptyData.accept(true)
                        return
                    }
                    recordRelay.accept(recordData)
                default:
                    print(res.errorMessage)
                }
            })
            .disposed(by: disposedBag)

        input.selectDate.asObservable()
            .flatMap { date in
                service.getCalendarTime(date: date)
            }
            .subscribe(onNext: { data, res in
                switch res {
                case .SUCCEED:
                    guard let resultData = data else { return }
                    calendarTimeRelay.accept(resultData)
                default:
                    print(res.errorMessage)
                }
            })
            .disposed(by: disposedBag)

        input.getMonthOfRecordDay.asObservable()
            .flatMap { yearMonth in
                service.getMonthOfRecordDay(yearMonth: yearMonth)
            }
            .subscribe(onNext: { data, res in
                switch res {
                case .SUCCEED:
                    guard let monthRecordData = data else {
                        return
                    }
                    monthRecordRelay.accept(monthRecordData)
                default:
                    print(res.errorMessage)
                }
            })
            .disposed(by: disposedBag)

        return Output(
            timeLineDate: recordRelay.asSignal(),
            monthRecordDay: monthRecordRelay.asSignal(),
            calendarTimeData: calendarTimeRelay.asSignal(),
            isEmptyData: isEmptyData.asDriver(onErrorJustReturn: false))
    }
// swiftlint: enable function_body_length
}
