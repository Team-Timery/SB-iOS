import Foundation

struct subjectsResponse: Decodable {
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

//{
//    "subject_list" : [
//        {
//            "subject_id":1,
//            "user_id":1,
//            "today_record": 03:33:00
//        },
//                {
//            "subject_id":1,
//            "user_id":1,
//            "today_record": 03:33:00
//        }
//    ]
//}
