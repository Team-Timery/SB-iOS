import Foundation
import Moya

enum RecordAPI {
    case getDetailRecord(recordID: Int)
    case createRecord(subjectID: Int, startTime: Date, stopTime: Date, memo: String)
    case updateRecordMemo(recordID: Int, memo: String)
    case getDayOfRecord(date: String)
    case getMonthOfRecordDay(yearMonth: String)
    case getCalendarTime(date: String)
    case getTodayReview(date: String)
    case updateTodayReview(reviewID: Int, review: String)
}

extension RecordAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://43.201.207.196:8888/record")!
    }

    var path: String {
        switch self {
        case let .getDetailRecord(recordID):
            return "/\(recordID)"
        case .createRecord(let subjectID, _, _, _):
            return "/\(subjectID)"
        case let .updateRecordMemo(recordID, _):
            return "/\(recordID)"
        case .getDayOfRecord:
            return ""
        case .getMonthOfRecordDay:
            return "/calendar"
        case .getCalendarTime:
            return "/calendar/time"
        case .getTodayReview:
            return "/today-review"
        case let .updateTodayReview(id, _):
            return "/today-review/\(id)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createRecord:
            return .post
        case .getDetailRecord, .getDayOfRecord, .getMonthOfRecordDay, .getCalendarTime, .getTodayReview:
            return .get
        case .updateRecordMemo, .updateTodayReview:
            return .patch
        }
    }

    var task: Moya.Task {
        switch self {
        case .getDetailRecord:
            return .requestPlain
        case .createRecord(_, let startTime, let stopTime, let memo):
            var param: [String: Any] = [
                "started_time": startTime.toString(to: "yyyy-MM-dd'T'HH:mm:ss"),
                "finished_time": stopTime.toString(to: "yyyy-MM-dd'T'HH:mm:ss")
            ]
            if !memo.isEmpty { param.updateValue(memo, forKey: "memo") }
            return .requestParameters(
                parameters: param,
                encoding: JSONEncoding.default
            )
        case let .updateRecordMemo(_, memo):
            return .requestParameters(
                parameters: [
                    "content": memo
                ],
                encoding: JSONEncoding.default
            )
        case .getDayOfRecord(let date):
            return .requestParameters(
                parameters: ["date": date],
                encoding: URLEncoding.queryString
            )
        case .getCalendarTime(let date):
            return .requestParameters(
                parameters: ["date": date],
                encoding: URLEncoding.queryString
            )
        case .getMonthOfRecordDay(let yearMonth):
            return .requestParameters(
                parameters: [
                    "yearMonth": yearMonth
                ],
                encoding: URLEncoding.queryString
            )
        case let .getTodayReview(date):
            return .requestParameters(
                parameters: [
                    "date": date
                ],
                encoding: URLEncoding.queryString
            )
        case let .updateTodayReview(_, review):
            return .requestParameters(
                parameters: [
                    "today_review": review
                ],
                encoding: JSONEncoding.default
            )
        }
    }

    var headers: [String: String]? {
        return Header.accessToken.header()
    }
}
