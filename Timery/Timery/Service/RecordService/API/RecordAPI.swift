import Foundation
import Moya

enum RecordAPI {
    case createRecord(subjectID: Int, startTime: Date, stopTime: Date, memo: String)
    case getDayOfRecord(date: String)
    case getMonthOfRecordDay(yearMonth: String)
    case getCalendarTime(date: String)
}

extension RecordAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://43.201.207.196:8888/record")!
    }

    var path: String {
        switch self {
        case .createRecord(let subjectID, _, _, _):
            return "/\(subjectID)"
        case .getDayOfRecord:
            return ""
        case .getMonthOfRecordDay:
            return "/calendar"
        case .getCalendarTime:
            return "/calendar/time"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createRecord:
            return .post
        case .getDayOfRecord, .getMonthOfRecordDay, .getCalendarTime:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
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
        }
    }

    var headers: [String: String]? {
        return Header.accessToken.header()
    }
}