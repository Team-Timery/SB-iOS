import Foundation

enum Month: String {
    case january = "JANUARY"
    case february = "FEBRUARY"
    case march = "MARCH"
    case april = "APRIL"
    case may = "MAY"
    case june = "JUNE"
    case july = "JULY"
    case august = "AUGUST"
    case september = "SEPTEMBER"
    case october = "OCTOBER"
    case november = "NOVEMBER"
    case december = "DECEMBER"
}

extension Month {
    var toMonthString: String {
        switch self {
        case .january: return "1월"
        case .february: return "2월"
        case .march: return "3월"
        case .april: return "4월"
        case .may: return "5월"
        case .june: return "6월"
        case .july: return "7월"
        case .august: return "8월"
        case .september: return "9월"
        case .october: return "10월"
        case .november: return "11월"
        case .december: return "12월"
        }
    }
}
/*1월    January    Jan.
 2월    February    Feb.
 3월    March    Mar.
 4월    Aprill    Apr.
 5월    May    May.
 6월    June    Jun.
 7월    July    Jul.
 8월    August    Aug.
 9월    September    Sep.
 10월    October    Oct.
 11월    November    Nov.
 12월    December    Dec.*/
