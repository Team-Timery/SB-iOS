import Foundation

extension Int {
    func decimalFormat() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let resultData = numberFormatter.string(from: NSNumber(value: self)) else {
            print("decimalFormat Error: 숫자 format을 실패하였습니다.")
            return "0"
        }
        return resultData
    }
}
