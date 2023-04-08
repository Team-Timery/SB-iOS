import Foundation
import UIKit
import RxSwift
import RxCocoa

class AuthToggleButton: UIButton {
    var isActivate: Bool = false

    init() {
        super.init(frame: .zero)
        setImage(UIImage(named: "term_uncheck"), for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isActivate {
            off()
        } else {
            on()
        }
    }

    public func on() {
        setImage(UIImage(named: "term_check"), for: .normal)
        isActivate = true
    }

    public func off() {
        setImage(UIImage(named: "term_uncheck"), for: .normal)
        isActivate = false
    }
}
