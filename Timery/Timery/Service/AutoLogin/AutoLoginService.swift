import Foundation
import SwiftKeychainWrapper

struct AutoLoginData {
    static var localIdentification: String?
    static var identification: String? {
        get {
            localIdentification =  KeychainWrapper.standard.string(forKey: "local_ID")
            return localIdentification
        }
        set(newID) {
            KeychainWrapper.standard.set(newID ?? "nil", forKey: "local_ID")
            localIdentification = newID
        }
    }
    static var localPassword: String?
    static var password: String? {
        get {
            localPassword = KeychainWrapper.standard.string(forKey: "local_password")
            return localPassword
        }
        set(newPassword) {
            KeychainWrapper.standard.set(newPassword ?? "nil", forKey: "local_password")
            localPassword = newPassword
        }
    }
    static func removeData() {
        self.identification = nil
        self.password = nil
    }
}
