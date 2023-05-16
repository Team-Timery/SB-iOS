import Foundation

struct ProfileResponse: Decodable {
    let name: String
    let email: String
    let age: Int
    let sex: String
}
