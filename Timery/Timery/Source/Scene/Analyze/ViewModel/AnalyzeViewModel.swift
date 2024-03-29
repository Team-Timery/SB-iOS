import Foundation
import RxSwift
import RxCocoa

class AnalyzeViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()

    struct Input {
        let getMonthOfAnalysis: Signal<String>
        let getAnalysGraph: Signal<Void>
        let getNextMonth: ControlEvent<Void>
        let getLastMonth: ControlEvent<Void>
    }

    struct Output {
        let monthOfAnalysis: Signal<MonthOfAnalysisEntity>
        let analysisGraph: Signal<AnalysisGraphEntity>
        let resultMonth: Signal<String>
    }

    var monthCount = 0

    func transform(input: Input) -> Output {
        let service = AnalysisService()
        let analysisData = PublishRelay<MonthOfAnalysisEntity>()
        let graphData = PublishRelay<AnalysisGraphEntity>()
        let resultMonth = PublishRelay<String>()

        input.getMonthOfAnalysis.asObservable()
            .flatMap { yearMonth in
                service.getMonthOfAnalysis(yearMonth: yearMonth)
            }
            .subscribe(onNext: { data, res in
                switch res {
                case .SUCCEED:
                    guard var resultData = data else { return }
                    resultData.focusResponses.sort(by: {
                        return $0.title != "기타" && $1.title != "기타" ? $0.sum > $1.sum : $0.title != "기타"
                    })
                    analysisData.accept(resultData)
                default:
                    print(res.errorMessage)
                }
            })
            .disposed(by: disposeBag)

        input.getNextMonth.asObservable()
            .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                self.monthCount += 1
                var dayComponent = DateComponents()
                dayComponent.month = self.monthCount
                let nextMonthResult = Calendar.current.date(byAdding: dayComponent, to: Date()) ?? Date()
                resultMonth.accept(nextMonthResult.toString(to: "yyyy-MM"))
            })
            .disposed(by: disposeBag)

        input.getLastMonth.asObservable()
            .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                self.monthCount -= 1
                var dayComponent = DateComponents()
                dayComponent.month = self.monthCount
                let lastMonthResult = Calendar.current.date(byAdding: dayComponent, to: Date()) ?? Date()
                resultMonth.accept(lastMonthResult.toString(to: "yyyy-MM"))
            })
            .disposed(by: disposeBag)

        input.getAnalysGraph.asObservable()
            .flatMap {
                service.getAnalysisGraph()
            }
            .subscribe(onNext: { data, res in
                switch res {
                case .SUCCEED:
                    guard let resultData = data else { return }
                    graphData.accept(resultData)
                default:
                    print(res.errorMessage)
                }
            })
            .disposed(by: disposeBag)

        return Output(
            monthOfAnalysis: analysisData.asSignal(),
            analysisGraph: graphData.asSignal(),
            resultMonth: resultMonth.asSignal()
        )
    }
}
