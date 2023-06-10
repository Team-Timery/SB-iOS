import Foundation
import RxMoya
import Moya
import RxSwift
import RxCocoa

final class AuthService {
    private let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggerPlugin()])

    func signup(
        email: String,
        password: String,
        name: String,
        age: Int,
        sex: String,
        isMarketing: Bool
    ) -> Single<AuthServiceResult> {
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
            sex: postSex,
            isMarketingAgreed: isMarketing)
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
                AutoLoginData.identification = email
                AutoLoginData.password = password
                return .SUCCEED
            }
            .catch { err in
                return .just(self.netErr(err))
            }
    }

    func anonymousLogin() -> Single<AuthServiceResult> {
        return provider.rx.request(.anonymousLogin)
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
                AutoLoginData.removeData()
                Token.removeToken()
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
                AutoLoginData.removeData()
                Token.removeToken()
                return .SUCCEED
            }
            .catch { err in
                return .just(self.netErr(err))
            }
    }

    func getUserProfile() -> Single<(UserProfileEntity?, AuthServiceResult)> {
        return provider.rx.request(.getUserProfile)
            .filterSuccessfulStatusCodes()
            .map(UserProfileResponse.self)
            .map { $0.toEntity() }
            .map { res -> (UserProfileEntity?, AuthServiceResult) in
                return (res, .SUCCEED)
            }
            .catch { err in
                return .just((nil, self.netErr(err)))
            }
    }

    func netErr(_ error: Error) -> AuthServiceResult {
        print("Auth Error: \(error.localizedDescription)")
        guard let statusCode = (error as? MoyaError)?.response?.statusCode else {
            return .FAILE
        }
        return AuthServiceResult(rawValue: statusCode) ?? .FAILE
    }
}
