import Foundation

enum NetworkingResult: Int {
    case SUCCEED = 200
    case BADREQUEST = 400
    case FORBIDDEN = 403
    case NOTFOUND = 404
    case DUPLICATED = 409
    case FAILE = 0
}
