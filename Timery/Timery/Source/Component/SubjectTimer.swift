import Foundation

class TimerManager {
    var timer: Timer?
    var action: () -> Void = {}

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.action()
        }
    }

    init(action: @escaping () -> Void) {
        self.action = action
    }
}
