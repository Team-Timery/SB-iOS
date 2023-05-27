import Foundation
import Moya
import RxMoya
import RxSwift

class DocumentService {
    private let provider = MoyaProvider<DocumentAPI>(plugins: [MoyaLoggerPlugin()])

    func getNotice() -> Single<(NoticeListEntity?, DocumentResult)> {
        return provider.rx.request(.getNotice)
            .filterSuccessfulStatusCodes()
            .map(NoticeListResponse.self)
            .map { $0.map { $0.toEntity() } }
            .map { res -> (NoticeListEntity?, DocumentResult) in
                return (res, .SUCCEED)
            }
            .catch { err in
                return .just((nil, self.netErr(err)))
            }
    }

    func getTips() -> Single<(TipsListEntity?, DocumentResult)> {
        return provider.rx.request(.getTips)
            .filterSuccessfulStatusCodes()
            .map(TipsListResponse.self)
            .map { $0.map { $0.toEntity() } }
            .map { res -> (TipsListEntity?, DocumentResult) in
                return (res, .SUCCEED)
            }
            .catch { err in
                return .just((nil, self.netErr(err)))
            }
    }

    func getFAQ() -> Single<(FAQListEntity?, DocumentResult)> {
        return provider.rx.request(.getFAQ)
            .filterSuccessfulStatusCodes()
            .map(FAQListResponse.self)
            .map { $0.map { $0.toEntity() } }
            .map { res -> (FAQListEntity?, DocumentResult) in
                return (res, .SUCCEED)
            }
            .catch { err in
                return .just((nil, self.netErr(err)))
            }
    }

    func netErr(_ error: Error) -> DocumentResult {
        print("Document Error: \(error.localizedDescription)")
        guard let status = (error as? MoyaError)?.response?.statusCode else {
            return .FAILE
        }
        return DocumentResult(rawValue: status) ?? .FAILE
    }
}
