import Foundation
import UIKit
import RxSwift
import RxCocoa

class TimerActivateViewModel: ViewModelType {

    struct Input {
        let startSignal: Signal<(Int, Int)>
        let stopSignal: Signal<Void>
    }

    struct Output {
        let timerText: Signal<String>
        let subjectText: Signal<String>
        let todayText: Signal<String>
    }

    private var timer: Timer?
    private var timerStartTime: Date = Date()
    private let timerText = PublishRelay<String>()
    private let subjectText = PublishRelay<String>()
    private let todayText = PublishRelay<String>()
    private var subjectTime: Int = 0
    private var todayTime: Int = 0

    var disposeBag: DisposeBag = DisposeBag()

    func transform(input: Input) -> Output {
        let overLimit = PublishRelay<Void>()

        input.startSignal.asObservable()
            .subscribe(onNext: { [weak self] subjectTime, todayTime in
                guard let self = self else { return }
                self.subjectTime = subjectTime
                self.todayTime = todayTime
                self.timerStartTime = Date()

                self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
                    guard let self = self else { return }
                    let timeGap = Int(Date().timeIntervalSince(timerStartTime))
                    DispatchQueue.main.async {
                        self.timerText.accept(timeGap.toTimerString())
                        self.subjectText.accept((self.subjectTime + timeGap).toTimerString())
                        self.todayText.accept((self.todayTime + timeGap).toTimerString())
                    }
                })
            })
            .disposed(by: disposeBag)

        input.stopSignal.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.timer?.invalidate()
                self?.timer = nil
            })
            .disposed(by: disposeBag)

        return Output(
            timerText: timerText.asSignal(),
            subjectText: subjectText.asSignal(),
            todayText: todayText.asSignal()
        )
    }
}
