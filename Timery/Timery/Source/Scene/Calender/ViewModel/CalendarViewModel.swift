import Foundation
import RxSwift
import RxCocoa

class CalendarViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()

    struct Input {
        let selectDate: Signal<String>
        let getMonthOfRecordDay: Driver<String>
        let getNextMonth: ControlEvent<Void>
        let getLastMonth: ControlEvent<Void>
        let inputTodayReview: Observable<String>
        let viewWillAppear: Observable<Void>
    }

    struct Output {
        let timeLineDate: Signal<RecordListEntity>
        let monthRecordDay: Signal<MonthOfRecordDayEntity>
        let calendarTimeData: Signal<CalendarTimeEntity>
        let isHiddenEmptyLable: Driver<Bool>
        let calendarPage: Signal<Date>
        let todayReview: Signal<TodayReviewEntity>
    }

    var monthCount = 0

// swiftlint: disable function_body_length
    func transform(input: Input) -> Output {
        let service = RecordService()
        let recordRelay = PublishRelay<RecordListEntity>()
        let calendarTimeRelay = PublishRelay<CalendarTimeEntity>()
        let monthRecordRelay = PublishRelay<MonthOfRecordDayEntity>()
        let isHiddenEmptyLable = PublishRelay<Bool>()
        let resultMonth = PublishRelay<Date>()
        let todayReviewRelay = PublishRelay<TodayReviewEntity>()

        input.selectDate.asObservable()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .flatMap { date in
                service.getDayOfRecord(date: date)
            }
            .subscribe(onNext: { data, res in
                switch res {
                case .SUCCEED:
                    guard let recordData = data, !recordData.recordResponses.isEmpty else {
                        isHiddenEmptyLable.accept(false)
                        return
                    }
                    isHiddenEmptyLable.accept(true)
                    recordRelay.accept(recordData)
                default:
                    print(res.errorMessage)
                }
            })
            .disposed(by: disposeBag)

        input.selectDate.asObservable()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
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
            .disposed(by: disposeBag)

        input.selectDate.asObservable()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .flatMap { service.getTodayReview(date: $0) }
            .bind(to: todayReviewRelay)
            .disposed(by: disposeBag)

        input.getMonthOfRecordDay.asObservable()
            .flatMap { yearMonth in
                service.getMonthOfRecordDay(yearMonth: yearMonth)
            }
            .subscribe(onNext: { data, res in
                switch res {
                case .SUCCEED:
                    guard let monthRecordData = data else { return }
                    monthRecordRelay.accept(monthRecordData)
                default:
                    print(res.errorMessage)
                }
            })
            .disposed(by: disposeBag)

        input.getNextMonth.asObservable()
            .subscribe(onNext: {
                self.monthCount += 1
                var dayComponent = DateComponents()
                dayComponent.month = self.monthCount
                let nextMonthResult = Calendar.current.date(byAdding: dayComponent, to: Date()) ?? Date()
                resultMonth.accept(nextMonthResult)
            })
            .disposed(by: disposeBag)

        input.getLastMonth.asObservable()
            .subscribe(onNext: {
                self.monthCount -= 1
                var dayComponent = DateComponents()
                dayComponent.month = self.monthCount
                let lastMonthResult = Calendar.current.date(byAdding: dayComponent, to: Date()) ?? Date()
                resultMonth.accept(lastMonthResult)
            })
            .disposed(by: disposeBag)

        Observable.zip(todayReviewRelay, input.inputTodayReview)
            .flatMap { todayReview, review in
                service.updateTodayReview(reviewID: todayReview.reviewID, review: review)
                    .map { _ in (todayReview, review) }
            }
            .map {
                TodayReviewEntity(reviewID: $0.reviewID, content: $1)
            }
            .bind(to: todayReviewRelay)
            .disposed(by: disposeBag)

        return Output(
            timeLineDate: recordRelay.asSignal(),
            monthRecordDay: monthRecordRelay.asSignal(),
            calendarTimeData: calendarTimeRelay.asSignal(),
            isHiddenEmptyLable: isHiddenEmptyLable.asDriver(onErrorJustReturn: false),
            calendarPage: resultMonth.asSignal(),
            todayReview: todayReviewRelay.asSignal()
        )
    }
// swiftlint: enable function_body_length
}
