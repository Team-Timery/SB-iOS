import Foundation

extension String {
    func toDate(to dateFormat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        guard let returnDate = dateFormatter.date(from: self) else {
            print("toDate Error: 데이터 format의 형식이 옳바르지 않습니다. \(dateFormat), \(self)")
            return Date()
        }
        return returnDate
    }
}
