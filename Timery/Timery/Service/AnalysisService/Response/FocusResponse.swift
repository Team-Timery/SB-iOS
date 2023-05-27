import Foundation

struct FocusResponse: Decodable {
    let title, emoji: String
    let sum, focusedRatio: Int

    enum CodingKeys: String, CodingKey {
        case title, emoji, sum
        case focusedRatio = "focused_ratio"
    }
}

extension FocusResponse {
    func toEntity() -> FocusEntity {
        return .init(
            title: self.title,
            emoji: self.emoji,
            sum: self.sum,
            focusedRatio: self.focusedRatio
        )
    }
}
