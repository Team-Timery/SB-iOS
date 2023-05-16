import Foundation

struct RecordSubjectResponse: Decodable {
    let subjectID: Int
    let title, emoji: String

    enum CodingKeys: String, CodingKey {
        case subjectID = "subject_id"
        case title, emoji
    }
}

extension RecordSubjectResponse {
    func toEntity() -> RecordSubjectEntity {
        return .init(
            subjectID: self.subjectID,
            title: self.title,
            emoji: self.emoji
        )
    }
}
