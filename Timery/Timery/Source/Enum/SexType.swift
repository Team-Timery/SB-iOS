import Foundation

enum SexType: String {
    case male = "MALE"
    case female = "FEMALE"
    case nonBinary = "NON_BINARY"

    var toKRString: String {
        switch self {
        case .male: return "남자"
        case .female: return "여자"
        case .nonBinary: return "표시안함"
        }
    }
}

/*var postSex: String {
 switch sex {
 case "남자": return "MALE"
 case "여자": return  "FEMALE"
 default: return "NON_BINARY"
 }
}*/
