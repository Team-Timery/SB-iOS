import Foundation
import Moya

enum AuthService {
    case login(code: String)
    case singup(email: String, password: String, name: String, age: String, sex: String)
    case reissuanceRefreshToken
}

extension AuthService: TargetType {
    var baseURL: URL {
        return URL(string: "")!
    }

    var path: String {
        switch self {
        case .login, .reissuanceRefreshToken:
            return "/auth"
        case .singup:
            return ""
        }
    }

    var method: Moya.Method {
        switch self {
        case .login, .singup:
            return .post
        case .reissuanceRefreshToken:
            return .patch
        }
    }

    var task: Moya.Task {
        switch self {
        case .singup(let email, let password, let name, let age, let sex):
            return .requestParameters(parameters: [
                "email": email,
                "password": password,
                "name": name,
                "age": age,
                "sex": sex

            ], encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
