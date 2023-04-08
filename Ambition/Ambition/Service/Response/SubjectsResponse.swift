import Foundation

struct SubjectsResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case subjectList = "subject_list"
    }

    let subjectList: [SubjectDetailResponse]
}

struct SubjectDetailResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case subjectID = "subject_id"
        case userID = "user_id"
        case todayRecord = "today_record"
    }

    let subjectID: Int
    let userID: Int
    let todayRecord: String
}
