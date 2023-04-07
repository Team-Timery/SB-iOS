import Foundation

struct TokenResponse: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiredAt = "expired_at"
        case refreshToken = "refresh_token"
    }
    
    let accessToken: String
    let expiredAt: String
    let refreshToken: String
}

//{
//    "access_token" : "eyksdmsedfa.sdfaecaef.qewdadeqawdrw",
//    "expired_at" : "2022-07-18T12:12:12",
//    "refresh_token" : "dvghfdfesdf.gyjgjrmgjyjg.ogjiyjghjgg"
//}
