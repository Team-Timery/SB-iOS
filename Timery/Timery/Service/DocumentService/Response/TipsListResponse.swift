import Foundation

struct TipsListResponseElement: Decodable {
    let title: String
    let content: String
}

extension TipsListResponseElement {
    func toEntity() -> TipsListEntityElement {
        return .init(
            title: self.title,
            content: self.content
        )
    }
}

typealias TipsListResponse = [TipsListResponseElement]
