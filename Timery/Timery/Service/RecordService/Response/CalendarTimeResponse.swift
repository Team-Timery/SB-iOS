import Foundation

struct CalendarTimeResponse: Decodable {
    let totalFocusedTime, maxFocusedTime: Int

    enum CodingKeys: String, CodingKey {
        case totalFocusedTime = "total_focused_time"
        case maxFocusedTime = "max_focused_time"
    }
}

extension CalendarTimeResponse {
    func toEntity() -> CalendarTimeEntity {
        return .init(
            totalFocusedTime: totalFocusedTime,
            maxFocusedTime: maxFocusedTime
        )
    }
}
