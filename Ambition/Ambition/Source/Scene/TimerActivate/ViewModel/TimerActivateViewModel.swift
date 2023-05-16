import Foundation
import RxSwift
import RxCocoa

class TimerActivateViewModel: ViewModelType {

    struct Input {
        let startSignal: Signal<(Int, Int)>
    }

    struct Output {
        let timerText: Signal<String>
        let subjectText: Signal<String>
        let todayText: Signal<String>
        let progressBarValue: Signal<Float>
    }

    private let progressBarValue = PublishRelay<Float>()
    private let timerText = PublishRelay<String>()
    private let subjectText = PublishRelay<String>()
    private let todayText = PublishRelay<String>()
    private var totalTime: Int = 0
    private var subjectTime: Int = 0
    private var todayTime: Int = 0

    var disposedBag: DisposeBag = DisposeBag()

    func transform(input: Input) -> Output {
        input.startSignal.asObservable()
            .subscribe(onNext: { [unowned self] subjectTime, todayTime in
                self.subjectTime = subjectTime
                self.todayTime = todayTime
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    self.totalTime += 1
                    self.subjectTime += 1
                    self.todayTime += 1
                    self.timerText.accept(self.totalTime.toTimerString())
                    self.subjectText.accept(self.subjectTime.toTimerString())
                    self.todayText.accept(self.todayTime.toTimerString())
                    self.progressBarValue.accept(Float(self.totalTime) / 600)
                }
            })
            .disposed(by: disposedBag)
        return Output(
            timerText: self.timerText.asSignal(),
            subjectText: self.subjectText.asSignal(),
            todayText: self.todayText.asSignal(),
            progressBarValue: self.progressBarValue.asSignal()
        )
    }
}
