import Foundation
import Moya
import RxMoya
import RxSwift

final class SubjectService {
    private let provider = MoyaProvider<SubjectAPI>(plugins: [MoyaLoggerPlugin()])

    func getMySubjects() -> Single<(MySubjectsEntity?, SubjectServiceResult)> {
        return provider.rx.request(.getMySubjects)
            .filterSuccessfulStatusCodes()
            .map(MySubjectsResponse.self)
            .map { $0.toEntity() }
            .map { return ($0, .SUCCEED) }
            .catch { return .just((nil, self.networkError($0))) }
    }

    func createMySubject(title: String, emoji: String) -> Single<SubjectServiceResult> {
        return provider.rx.request(.createSubject(title: title, emoji: emoji))
            .filterSuccessfulStatusCodes()
            .map { _ -> SubjectServiceResult in
                return .SUCCEED
            }
            .catch { err in
                return .just(self.networkError(err))
            }
    }

    func deleteMySubject(subjectID: Int) -> Single<SubjectServiceResult> {
        return provider.rx.request(.deleteSubject(subjectID: subjectID))
            .filterSuccessfulStatusCodes()
            .map { _ -> SubjectServiceResult in
                return .SUCCEED
            }
            .catch { err in
                return .just(self.networkError(err))
            }
    }

    func networkError(_ error: Error) -> SubjectServiceResult {
        print(error)
        guard let status = (error as? MoyaError)?.response?.statusCode else {
            return .FAILE
        }
        return SubjectServiceResult(rawValue: status) ?? .FAILE
    }
}
