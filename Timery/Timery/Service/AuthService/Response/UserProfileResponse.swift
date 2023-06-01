import Foundation

struct UserProfileResponse: Codable {
    let name: String
//    let email: String
//    let age: Int
//    let sex: String
}

extension UserProfileResponse {
    func toEntity() -> UserProfileEntity {
        return .init(
            name: name
//            email: email,
//            age: age,
//            sex: .init(rawValue: sex) ?? .nonBinary
        )
    }
}
