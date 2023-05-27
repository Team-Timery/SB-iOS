import Foundation

extension Int {
    func toFullTimeString() -> String {
        if self >= 3600 {
            return "\(self / 3600)시간 \(self / 60 % 60)분 \(self % 60)초"
        } else if self >= 60 {
            return "\(self / 60 % 60)분 \(self % 60)초"
        } else if self > 0 {
            return "\(self % 60)초"
        } else {
            return "측정값이 없습니다"
        }
    }
}
