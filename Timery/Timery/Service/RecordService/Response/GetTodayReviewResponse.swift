import Foundation

struct GetTodayReviewResponse: Decodable {
    let reviewID: Int
    let content: String?

    enum CodingKeys: String, CodingKey {
        case reviewID = "review_id"
        case content
    }
}

extension GetTodayReviewResponse {
    func toDomain() -> TodayReviewEntity {
        TodayReviewEntity(
            reviewID: reviewID,
            content: content
        )
    }
}
