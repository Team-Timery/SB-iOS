import Foundation

extension Int {
    func toTimerString() -> String {
        return String(
            format: "%02d:%02d:%02d", self / 3600, self / 60 % 60, self % 60
        )
    }
}
