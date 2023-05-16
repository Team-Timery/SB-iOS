import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class AuthPickerButton: UIButton {

    private let underLineView = UIView().then {
        $0.backgroundColor = .mainElevated
    }

    private let errorLabel = UILabel().then {
        $0.textColor = .error
        $0.font = .indicatorMedium
        $0.layer.opacity = 0
    }

    init(
        placeholder: String? = nil,
        errorMessage: String? = nil
    ) {
        super.init(frame: .zero)
        setTitle(placeholder, for: .normal)
        setTitleColor(UIColor.grayDarken1, for: .normal)
        titleLabel?.font = .title2Medium
        contentHorizontalAlignment = .left
        errorLabel.text = errorMessage
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addSubviews()
        makeConstraints()
    }
}

extension AuthPickerButton {
    private func addSubviews() {
        [
            underLineView,
            errorLabel
        ].forEach({ addSubview($0) })
    }

    private func makeConstraints() {
        underLineView.snp.makeConstraints {
            $0.height.equalTo(1.5)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.snp.bottom).offset(5)
        }

        errorLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(3)
            $0.top.equalTo(underLineView.snp.bottom).offset(3)
        }
    }
}
