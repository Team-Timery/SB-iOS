import Foundation

struct AnalysisGraphResponse: Decodable {
    let lastMonth, thisMonth: String
    let growthPercent, increasedTime: Int

    enum CodingKeys: String, CodingKey {
        case lastMonth = "last_month"
        case thisMonth = "this_month"
        case growthPercent = "growth_percent"
        case increasedTime = "increased_time"
    }
}

extension AnalysisGraphResponse {
    func toEntity() -> AnalysisGraphEntity {
        return .init(
            lastMonth: .init(rawValue: lastMonth) ?? .january,
            thisMonth: .init(rawValue: thisMonth) ?? .january,
            growthPercent: self.growthPercent,
            increasedTime: self.increasedTime
        )
    }
}
