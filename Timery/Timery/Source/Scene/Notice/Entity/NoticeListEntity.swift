import Foundation

struct NoticeListEntityElement {
    let title: String
    let content: String
    let createdAt: String

    enum Codingkeys: String, CodingKey {
        case title, content
        case createdAt = "created_at"
    }
}

typealias NoticeListEntity = [NoticeListEntityElement]
