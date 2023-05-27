import Foundation

struct FAQListResponseElement: Decodable {
    let title: String
    let content: String
}

extension FAQListResponseElement {
    func toEntity() -> FAQListEntityElement {
        return .init(
            title: self.title,
            content: self.content
        )
    }
}

typealias FAQListResponse = [FAQListResponseElement]
