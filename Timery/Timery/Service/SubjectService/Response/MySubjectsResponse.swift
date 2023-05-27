import Foundation

struct MySubjectsResponse: Decodable {
    let totalTime: Int
    let subjectList: [MySubjectResponse]

    enum CodingKeys: String, CodingKey {
        case totalTime = "total_time"
        case subjectList = "subject_list"
    }
}

extension MySubjectsResponse {
    func toEntity() -> MySubjectsEntity {
        return .init(
            totalTime: self.totalTime,
            subjectList: self.subjectList.map { $0.toEntity() }
        )
    }
}
