import Foundation

class UserSignupEntity {
    static let shared = UserSignupEntity()
    private init() {}

    var name: String = ""
    var id: String = ""
    var password: String = ""
    var age: Int = 0
    var sex: String = ""
}
