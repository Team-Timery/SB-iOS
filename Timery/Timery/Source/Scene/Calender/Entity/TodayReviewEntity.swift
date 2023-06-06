import Foundation

struct TodayReviewEntity: Equatable {
    let reviewID: Int
    let content: String?

    enum CodingKeys: String, CodingKey {
        case reviewID = "review_id"
        case content
    }
}
