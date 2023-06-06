import Foundation

struct RecordDetailEntity: Equatable {
    let recordID: Int
    let startedTime: String
    let finishedTime: String
    let total: Int
    let memo: String?
}
