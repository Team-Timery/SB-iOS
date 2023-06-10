import Foundation

enum AuthServiceResult: Int {
    case SUCCEED = 200
    case BADREQUEST = 400
    case WRONGPASSWORD = 401
    case FORBIDDEN = 403
    case NOTFOUND = 404
    case DUPLICATED = 409
    case SERVERERROR = 500
    case FAILE = 0

    var errorMessage: String {
        switch self {
        case .BADREQUEST: return "옳바르지 않은 요청입니다."
        case .WRONGPASSWORD: return "옳바르지 않은 비밀번호 입니다."
        case .FORBIDDEN: return "권한이 없습니다"
        case .NOTFOUND: return "유저를 찾을 수 없습니다."
        case .DUPLICATED: return "이미 존재하는 이메일 입니다!"
        case .SERVERERROR: return "관리자에게 문의해주세요!"
        case .FAILE: return "네트워크 연결을 확인해주세요!"
        default: return "알수 없는 오류입니다."
        }
    }
}
