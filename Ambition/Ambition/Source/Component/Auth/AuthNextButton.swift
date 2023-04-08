import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class AuthNextButton: UIButton {
//    let disposeBag = DisposeBag()
//    let isTouch = PublishRelay<Bool>()

    private let testView = UIView().then {
        $0.backgroundColor = .blue
    }

    init(title: String) {
        super.init(frame: .zero)
        backgroundColor = .mainElevated
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.title2Bold
        layer.cornerRadius = 30
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    override func layoutSubviews() {
//        addSubview(testView)
//        testView.snp.makeConstraints {
//            $0.center.equalToSuperview()
//            $0.width.height.equalTo(60)
//        }
//    }
}

extension AuthNextButton {
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        isTouch.accept(true)
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        isTouch.accept(false)
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        isTouch.accept(false)
//    }
}
