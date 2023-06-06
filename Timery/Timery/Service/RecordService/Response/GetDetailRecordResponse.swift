import Foundation

struct GetDetailRecordResponse: Decodable {
    let recordID: Int
    let startedTime: String
    let finishedTime: String
    let total: Int
    let memo: String?

    enum CodingKeys: String, CodingKey {
        case recordID = "record_id"
        case startedTime = "started_time"
        case finishedTime = "finished_time"
        case total
        case memo
    }
}

extension GetDetailRecordResponse {
    func toDomain() -> RecordDetailEntity {
        RecordDetailEntity(
            recordID: recordID,
            startedTime: startedTime,
            finishedTime: finishedTime,
            total: total,
            memo: memo
        )
    }
}
