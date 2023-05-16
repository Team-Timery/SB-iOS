import Foundation

struct MonthOfRecordDayResponse: Codable {
    let recordedDays: [Int]

    enum CodingKeys: String, CodingKey {
        case recordedDays = "recorded_days"
    }
}

extension MonthOfRecordDayResponse {
    func toEntity() -> MonthOfRecordDayEntity {
        return .init(recordedDays: self.recordedDays)
    }
}
