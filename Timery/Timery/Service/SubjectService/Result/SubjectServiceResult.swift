import Foundation

enum SubjectServiceResult: Int {
    case SUCCEED = 200
    case BADREQUEST = 400
    case NOVIP = 401
    case FORBIDDEN = 403
    case NOTFOUND = 404
    case DUPLICATED = 409
    case SERVERERROR = 500
    case FAILE = 0

    var errorMessage: String {
        switch self {
        case .BADREQUEST: return "옳바르지 않은 요청입니다."
        case .NOVIP: return "과목은 총 8개까지 생성 가능합니다"
        case .FORBIDDEN: return "권한이 없습니다"
        case .NOTFOUND: return "찾을 수 없는 요청입니다!"
        case .DUPLICATED: return "같은 과목이 이미 존재합니다"
        case .SERVERERROR: return "관리자에게 문의해주세요!"
        case .FAILE: return "알수 없는 오류입니다."
        default: return "알수 없는 오류입니다."
        }
    }
}
