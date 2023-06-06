import Foundation

struct RecordResponse: Decodable {
    let recordID: Int
    let startedTime, finishedTime: String
    let total: Int
    let isRecord: Bool
    let subject: RecordSubjectResponse

    enum CodingKeys: String, CodingKey {
        case recordID = "record_id"
        case startedTime = "started_time"
        case finishedTime = "finished_time"
        case isRecord = "is_record"
        case total, subject
    }
}

extension RecordResponse {
    func toEntity() -> RecordEntity {
        return .init(
            recordID: self.recordID,
            startedTime: self.startedTime.toDate(to: "yyyy-MM-dd'T'HH:mm:ss").toString(to: "a h:mm"),
            finishedTime: self.finishedTime.toDate(to: "yyyy-MM-dd'T'HH:mm:ss").toString(to: "a h:mm"),
            total: self.total,
            isRecord: self.isRecord,
            subject: self.subject.toEntity()
        )
    }
}
