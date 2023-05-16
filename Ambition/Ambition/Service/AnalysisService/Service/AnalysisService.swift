import Foundation
import Moya
import RxMoya
import RxSwift

class AnalysisService {
    private let provider = MoyaProvider<AnalysisAPI>(plugins: [MoyaLoggerPlugin()])

    func getMonthOfAnalysis(yearMonth: String) -> Single<(MonthOfAnalysisEntity?, AnalysisResult)> {
        return provider.rx.request(.getMonthOfAnalysis(yearMonth: yearMonth))
            .filterSuccessfulStatusCodes()
            .map(MonthOfAnalysisResponse.self)
            .map { $0.toEntity() }
            .map { res -> (MonthOfAnalysisEntity?, AnalysisResult) in
                return (res, .SUCCEED)
            }
            .catch { err in
                return .just((nil, self.netErr(err)))
            }
    }

    func getAnalysisGraph() -> Single<(AnalysisGraphEntity?, AnalysisResult)> {
        return provider.rx.request(.getAnalysisGraph)
            .filterSuccessfulStatusCodes()
            .map(AnalysisGraphResponse.self)
            .map { $0.toEntity() }
            .map { res -> (AnalysisGraphEntity?, AnalysisResult) in
                return (res, .SUCCEED)
            }
            .catch { err in
                return .just((nil, self.netErr(err)))
            }
    }

    func netErr(_ error: Error) -> AnalysisResult {
        print("Analysis Error: \(error.localizedDescription)")
        guard let status = (error as? MoyaError)?.response?.statusCode else {
            return .FAILE
        }
        return AnalysisResult(rawValue: status) ?? .FAILE
    }
}
