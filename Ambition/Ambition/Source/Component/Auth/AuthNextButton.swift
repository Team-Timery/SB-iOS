import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class AuthNextButton: UIButton {

    public var isActivate: Bool? {
        didSet {
            guard let isActivate = isActivate else { return }
            self.isEnabled = isActivate
            backgroundColor =  isActivate ? .mainElevated : .main
        }
    }

    public var isLoading: Bool = false {
        didSet {
            self.indicatorView.isHidden = !isLoading
            self.titleLabel?.layer.opacity = isLoading ? 0 : 1
        }
    }

    private let indicatorView = UIActivityIndicatorView().then {
        $0.startAnimating()
        $0.color = .white
        $0.style = .medium
        $0.isHidden = true
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

    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(self.indicatorView)
        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
