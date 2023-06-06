import UIKit
import Then

final class RecordDetailViewController: BaseViewController<RecordDetailViewModel> {
    private let subjectLabel = UILabel().then {
        $0.textColor = .grayDarken4
        $0.font = .title2Medium
    }
    private let studyTimeLabel = UILabel().then {
        $0.textColor = .grayDarken4
        $0.font = .title1Bold
    }
    private let subjectStackView = UIStackView().then {
        $0.spacing = 16
        $0.axis = .vertical
    }
}
