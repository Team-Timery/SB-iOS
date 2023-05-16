import Foundation

struct RecordListResponse: Decodable {
    let date: String
    let recordResponses: [RecordResponse]

    enum CodingKeys: String, CodingKey {
        case date
        case recordResponses = "record_responses"
    }
}

extension RecordListResponse {
    func toEntity() -> RecordListEntity {
        return .init(
            date: self.date,
            recordResponses: self.recordResponses.map { $0.toEntity() }
        )
    }
}
