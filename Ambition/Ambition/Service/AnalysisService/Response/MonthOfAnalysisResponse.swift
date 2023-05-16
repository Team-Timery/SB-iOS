import Foundation

struct MonthOfAnalysisResponse: Decodable {
    let yearMonth: String
    let totalTime: Int
    let focusResponses: [FocusResponse]

    enum CodingKeys: String, CodingKey {
        case yearMonth = "year_month"
        case totalTime = "total_time"
        case focusResponses = "focus_responses"
    }
}

extension MonthOfAnalysisResponse {
    func toEntity() -> MonthOfAnalysisEntity {
        return .init(
            yearMonth: self.yearMonth,
            totalTime: self.totalTime,
            focusResponses: self.focusResponses.map { $0.toEntity() }
        )
    }
}
