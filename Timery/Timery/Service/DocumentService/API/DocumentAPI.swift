import Foundation
import Moya

enum DocumentAPI {
    case getNotice
    case getFAQ
    case getTips
}

extension DocumentAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://43.201.207.196:8888")!
    }

    var path: String {
        switch self {
        case .getNotice:
            return "/notice"
        case .getFAQ:
            return "/faq"
        case .getTips:
            return "/tips"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Moya.Task {
        return .requestPlain
    }

    var headers: [String: String]? {
        return Header.accessToken.header()
    }
}
