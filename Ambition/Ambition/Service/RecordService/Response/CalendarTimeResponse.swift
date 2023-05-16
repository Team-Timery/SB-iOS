import Foundation

struct CalendarTimeResponse: Decodable {
    let totalFocusedTime, maxFocusedTime: Int
}

extension CalendarTimeResponse {
    func toEntity() -> CalendarTimeEntity {
        return .init(
            totalFocusedTime: self.totalFocusedTime,
            maxFocusedTime: self.maxFocusedTime
        )
    }
}
