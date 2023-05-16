import Foundation

struct MySubjectResponse: Decodable {
    let id: Int
    let title, emoji: String
    let userID, todayRecord: Int

    enum CodingKeys: String, CodingKey {
        case id, title, emoji
        case userID = "user_id"
        case todayRecord = "today_record"
    }
}

extension MySubjectResponse {
    func toEntity() -> MySubjectEntity {
        return .init(
            id: self.id,
            title: self.title,
            emoji: self.emoji,
            userID: self.userID,
            todayRecord: self.todayRecord
        )
    }
}
