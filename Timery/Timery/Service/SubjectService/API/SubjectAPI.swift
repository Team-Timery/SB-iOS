import Foundation
import Moya

enum SubjectAPI {
    case getMySubjects
    case createSubject(title: String, emoji: String)
    case deleteSubject(subjectID: Int)
}

extension SubjectAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://43.201.207.196:8888/subject")!
    }

    var path: String {
        switch self {
        case .deleteSubject(let subjectID):
            return "/\(subjectID)"
        default:
            return ""
        }
    }

    var method: Moya.Method {
        switch self {
        case .getMySubjects:
            return .get
        case .createSubject:
            return .post
        case .deleteSubject:
            return .delete
        }
    }

    var task: Moya.Task {
        switch self {
        case .createSubject(let title, let emoji):
            return .requestParameters(
                parameters: [
                    "title": title,
                    "emoji": emoji
                ],
                encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return Header.accessToken.header()
    }
}
