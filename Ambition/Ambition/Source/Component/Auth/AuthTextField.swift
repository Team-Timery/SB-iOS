import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class AuthTextField: UITextField {
    let disposedBag = DisposeBag()

    private var isSecure: Bool = true

    public var isError: Bool? {
        didSet {
            guard let isError = isError else { return }
            self.errorLabel.layer.opacity = isError ? 1 : 0
            self.underLineView.backgroundColor = isError ? .error : .whiteElevated3
        }
    }

    private var placeholderText: String?

    private let underLineView = UIView().then {
        $0.backgroundColor = .whiteElevated3
    }

    private let errorLabel = UILabel().then {
        $0.textColor = .error
        $0.font = .indicatorMedium
        $0.layer.opacity = 0
    }

    private let secureButton = UIButton(type: .system).then {
        $0.tintColor = .grayDarken1
        $0.setImage(UIImage(named: "eye_able"), for: .normal)
    }

    init(
        placeholder: String? = nil,
        errorMessage: String? = nil,
        isError: Bool = false,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default
    ) {
        super.init(frame: .zero)
        self.keyboardType = keyboardType
        autocapitalizationType = .none
        autocorrectionType = .no
        isSecureTextEntry = isSecure
        self.isError = isError
        delegate = self
        textColor = .black
        font = .title3Medium
        clearButtonMode = .always
        placeholderText = placeholder
        errorLabel.text = errorMessage
        if isSecure {
            rightView = secureButton
            rightViewMode = .always
            bind()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addSubviews()
        makeConstraints()
        fieldSetting()
    }
}

extension AuthTextField {
    private func bind() {
        secureButton.rx.tap
            .bind { [unowned self] in
                isSecure.toggle()
                isSecureTextEntry = isSecure
                secureButton.setImage(UIImage(named: "eye_\(isSecure ? "" : "dis")able"), for: .normal)
            }
            .disposed(by: disposedBag)
    }
    private func fieldSetting() {
        self.attributedPlaceholder = NSAttributedString(
            string: placeholderText ?? "",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.grayDarken1!,
                NSAttributedString.Key.font: UIFont.title2Medium as Any
            ]
        )
    }
}

extension AuthTextField {
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

extension AuthTextField: UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.underLineView.backgroundColor = .mainElevated
//    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(isError ?? false) {
            if self.text != nil {
                self.underLineView.backgroundColor = .mainElevated
            } else {
                self.underLineView.backgroundColor = .whiteElevated3
            }
        }
    }
}
