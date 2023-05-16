import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class AuthToggleButton: UIButton {

    var isActivate: Bool? {
        didSet {
            guard let isActivate = isActivate else { return }
            setImage(UIImage(named: "term_\(isActivate ? "" : "un")check"), for: .normal)
        }
    }

    init() {
        super.init(frame: .zero)
        setImage(UIImage(named: "term_uncheck"), for: .normal)
        isActivate = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
