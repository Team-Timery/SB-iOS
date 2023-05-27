import Foundation
import Moya

enum AnalysisAPI {
    case getMonthOfAnalysis(yearMonth: String)
    case getAnalysisGraph
}

extension AnalysisAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://43.201.207.196:8888/analysis")!
    }

    var path: String {
        switch self {
        case .getMonthOfAnalysis:
            return ""
        case .getAnalysisGraph:
            return "/graph"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Moya.Task {
        switch self {
        case .getMonthOfAnalysis(let yearMonth):
            return .requestParameters(
                parameters: [
                    "yearMonth": yearMonth
                ],
                encoding: URLEncoding.queryString
            )
        default:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return Header.accessToken.header()
    }
}
