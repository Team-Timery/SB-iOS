import Foundation

struct NoticeListResponseElement: Decodable {
    let title, content, createdAt: String

    enum CodingKeys: String, CodingKey {
        case title, content
        case createdAt = "created_at"
    }
}

extension NoticeListResponseElement {
    func toEntity() -> NoticeListEntityElement {
        return .init(
            title: self.title,
            content: self.content,
            createdAt: self.createdAt.toDate(to: "yyyy-MM-dd'T'HH:mm:ss").toString(to: "yyyy.MM.dd")
        )
    }
}

typealias NoticeListResponse = [NoticeListResponseElement]
