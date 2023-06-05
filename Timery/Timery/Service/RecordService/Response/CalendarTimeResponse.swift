import Foundation

struct CalendarTimeResponse: Decodable {
    let totalFocusedTime, maxFocusedTime: Int
    let todayReview: String?
    let reviewID: Int?

    enum CodingKeys: String, CodingKey {
        case totalFocusedTime = "total_focused_time"
        case maxFocusedTime = "max_focused_time"
        case todayReview = "today_review"
        case reviewID = "review_id"
    }
}

extension CalendarTimeResponse {
    func toEntity() -> CalendarTimeEntity {
        return .init(
            totalFocusedTime: totalFocusedTime,
            maxFocusedTime: maxFocusedTime,
            todayReview: todayReview,
            reviewID: reviewID ?? 0
        )
    }
}
