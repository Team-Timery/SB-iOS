import Foundation
import Moya
import RxMoya
import RxSwift

class RecordService {
    private let provider = MoyaProvider<RecordAPI>(plugins: [MoyaLoggerPlugin()])

    func createRecord(subjectID: Int, startTime: Date, stopTime: Date, memo: String) -> Single<RecordResult> {
        return provider.rx.request(.createRecord(
                subjectID: subjectID,
                startTime: startTime,
                stopTime: stopTime,
                memo: memo
                )
            )
            .filterSuccessfulStatusCodes()
            .map { _ -> RecordResult in
                return .SUCCEED
            }
            .catch { err in
                return .just(self.netErr(err))
            }
    }

    func getDayOfRecord(date: String) -> Single<(RecordListEntity?, RecordResult)> {
        return provider.rx.request(.getDayOfRecord(date: date))
            .filterSuccessfulStatusCodes()
            .map(RecordListResponse.self)
            .map { $0.toEntity() }
            .map { res -> (RecordListEntity?, RecordResult) in
                return (res, .SUCCEED)
            }
            .catch { err in
                return .just((nil, self.netErr(err)))
            }
    }

    func getMonthOfRecordDay(yearMonth: String) -> Single<(MonthOfRecordDayEntity?, RecordResult)> {
        return provider.rx.request(.getMonthOfRecordDay(yearMonth: yearMonth))
            .filterSuccessfulStatusCodes()
            .map(MonthOfRecordDayResponse.self)
            .map { $0.toEntity() }
            .map { res -> (MonthOfRecordDayEntity?, RecordResult) in
                return (res, .SUCCEED)
            }
            .catch { err in
                return .just((nil, self.netErr(err)))
            }
    }

    func getCalendarTime(date: String) -> Single<(CalendarTimeEntity?, RecordResult)> {
        return provider.rx.request(.getCalendarTime(date: date))
            .filterSuccessfulStatusCodes()
            .map(CalendarTimeResponse.self)
            .map { $0.toEntity() }
            .map { res -> (CalendarTimeEntity?, RecordResult) in
                return (res, .SUCCEED)
            }
            .catch { err in
                return .just((nil, self.netErr(err)))
            }
    }

    func netErr(_ error: Error) -> RecordResult {
        print("Record Error: \(error.localizedDescription)")
        guard let status = (error as? MoyaError)?.response?.statusCode else {
            return .FAILE
        }
        return RecordResult(rawValue: status) ?? .FAILE
    }
}
