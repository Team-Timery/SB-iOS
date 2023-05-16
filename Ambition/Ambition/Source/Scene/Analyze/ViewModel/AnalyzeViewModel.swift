import Foundation
import RxSwift
import RxCocoa

class AnalyzeViewModel: ViewModelType {
    var disposedBag: DisposeBag = DisposeBag()

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
                    resultData.focusResponses.sort(by: { $0.sum > $1.sum })
                    analysisData.accept(resultData)
                default:
                    print(res.errorMessage)
                }
            })
            .disposed(by: disposedBag)

        input.getNextMonth.asObservable()
            .subscribe(onNext: {
                self.monthCount += 1
                var dayComponent = DateComponents()
                dayComponent.month = self.monthCount
                let nextMonthResult = Calendar.current.date(byAdding: dayComponent, to: Date()) ?? Date()
                resultMonth.accept(nextMonthResult.toString(to: "yyyy-MM"))
            })
            .disposed(by: disposedBag)

        input.getLastMonth.asObservable()
            .subscribe(onNext: {
                self.monthCount -= 1
                var dayComponent = DateComponents()
                dayComponent.month = self.monthCount
                let lastMonthResult = Calendar.current.date(byAdding: dayComponent, to: Date()) ?? Date()
                resultMonth.accept(lastMonthResult.toString(to: "yyyy-MM"))
            })
            .disposed(by: disposedBag)

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
            .disposed(by: disposedBag)

        return Output(
            monthOfAnalysis: analysisData.asSignal(),
            analysisGraph: graphData.asSignal(),
            resultMonth: resultMonth.asSignal()
        )
    }
}
