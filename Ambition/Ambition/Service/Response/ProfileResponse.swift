import Foundation

struct ProfileResponse: Decodable {
    let name: String
    let email: String
    let age: Int
    let sex: String
}

//{
//    "name" : "asdfads",
//    "email" : "email@dsm.hs.kr",
//    "age" : 18
//    "sex" : "MALE"
//}
