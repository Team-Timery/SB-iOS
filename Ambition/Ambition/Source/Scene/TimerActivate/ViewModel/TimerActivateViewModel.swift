import Foundation
import RxSwift
import RxCocoa

class TimerActivateViewModel: ViewModelType {

    struct Input {
        let startSignal: Signal<Bool>
    }

    struct Output {
        let timerText: Signal<String>
        let progressBarValue: Signal<Float>
    }

    private let progressBarValue = PublishRelay<Float>()
    private let timerText = PublishRelay<String>()
    private var totalTime: Int = 0

    var disposedBag: DisposeBag = DisposeBag()

    func transform(input: Input) -> Output {
        input.startSignal
            .emit { [unowned self] _ in
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    self.totalTime += 1
                    let displayTime = String(
                        format: "%02d:%02d:%02d", self.totalTime / 3600, self.totalTime / 60 % 60, self.totalTime % 60
                    )
                    self.timerText.accept(displayTime)
                    self.progressBarValue.accept(Float(self.totalTime) / 600)
                }
            }
            .disposed(by: disposedBag)
        return Output(
            timerText: self.timerText.asSignal(),
            progressBarValue: self.progressBarValue.asSignal()
        )
    }
}
