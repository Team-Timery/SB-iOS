import Foundation
import RxMoya
import Moya
import RxSwift
import RxCocoa

final class AuthService {
    private let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggerPlugin()])

    func signup(email: String, password: String, name: String, age: Int, sex: String) -> Single<AuthServiceResult> {
        var postSex: String {
            switch sex {
            case "남자": return "MALE"
            case "여자": return  "FEMALE"
            default: return "NON_BINARY"
            }
        }

        return provider.rx.request(.singup(
            email: email,
            password: password,
            name: name,
            age: age,
            sex: postSex)
        )
        .filterSuccessfulStatusCodes()
        .map(TokenResponse.self)
        .map { res in
            Token.accessToken = res.accessToken
            Token.refreshToken = res.refreshToken
            return .SUCCEED
        }
        .catch { err in
            return .just(self.netErr(err))
        }
    }

    func login(email: String, password: String) -> Single<AuthServiceResult> {
        return provider.rx.request(.login(email: email, password: password))
            .filterSuccessfulStatusCodes()
            .map(TokenResponse.self)
            .map { res -> AuthServiceResult in
                Token.accessToken = res.accessToken
                Token.refreshToken = res.refreshToken
                return .SUCCEED
            }
            .catch { err in
                return .just(self.netErr(err))
            }
    }

    func logout() -> Single<AuthServiceResult> {
        return provider.rx.request(.logout)
            .filterSuccessfulStatusCodes()
            .map { _ -> AuthServiceResult in
                return .SUCCEED
            }
            .catch { err in
                return .just(self.netErr(err))
            }
    }

    func deleteUser() -> Single<AuthServiceResult> {
        return provider.rx.request(.deleteUser)
            .filterSuccessfulStatusCodes()
            .map { _ -> AuthServiceResult in
                return .SUCCEED
            }
            .catch { err in
                return .just(self.netErr(err))
            }
    }

    func netErr(_ error: Error) -> AuthServiceResult {
        guard let statusCode = (error as? MoyaError)?.response?.statusCode else {
            return .FAILE
        }
        return AuthServiceResult(rawValue: statusCode) ?? .FAILE
    }
}
