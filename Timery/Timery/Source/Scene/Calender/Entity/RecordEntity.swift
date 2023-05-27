import Foundation

struct RecordEntity {
    let recordID: Int
    let startedTime, finishedTime: String
    let total: Int
    let memo: String?
    let isRecord: Bool
    let subject: RecordSubjectEntity
}
