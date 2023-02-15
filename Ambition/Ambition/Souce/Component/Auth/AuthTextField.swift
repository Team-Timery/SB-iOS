//
//  AuthTextField.swift
//  Ambition
//
//  Created by 조병진 on 2023/02/09.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class AuthTextField: UITextField {
    let disposedBag = DisposeBag()
    
    var isErrorRelay = BehaviorRelay(value: false)
    
    private var textRegex: String?

    private let cancelButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "x_gray"), for: .normal)
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .whiteElevated4
        $0.font = .main2Medium
    }
    
    private let errorLabel = UILabel().then {
        $0.textColor = .error
        $0.font = .indicatorMedium
        $0.layer.opacity = 0
    }
    
    init(lable: String, errorMessage: String? = nil, regex: String? = nil, keyboardType: UIKeyboardType = .default) {
        super.init(frame: .zero)
        self.keyboardType = keyboardType
        autocorrectionType = .no
        delegate = self
        backgroundColor = .white
        textColor = .black
        font = UIFont.title3Medium
        titleLabel.text = lable
        errorLabel.text = errorMessage
        textRegex = regex
        layer.cornerRadius = 10
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.whiteElevated4?.cgColor
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: frame.height))
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: frame.height))
        leftView = leftPaddingView
        rightView = rightPaddingView
        leftViewMode = .always
        rightViewMode = .always
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        addSubviews()
        makeConstraints()
    }
}

extension AuthTextField {
    private func bind() {
        isErrorRelay.asObservable()
            .bind { [self] status in
                layer.borderColor = status ? UIColor.error?.cgColor : UIColor.whiteElevated4?.cgColor
                errorLabel.layer.opacity = status ? 1 : 0
                layer.borderWidth = status ? 1 : 0.5
            }
            .disposed(by: disposedBag)
        
        cancelButton.rx.tap
            .bind { [self] in
                text = ""
            }
            .disposed(by: disposedBag)
    }
}

extension AuthTextField {
    private func addSubviews() {
        [
            titleLabel,
            errorLabel,
            cancelButton
        ].forEach({ addSubview($0) })
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(9)
            $0.bottom.equalTo(self.snp.top).offset(-8)
        }
        
        errorLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(3)
            $0.top.equalTo(self.snp.bottom).offset(3)
        }
        
        cancelButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.right.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
    }
}

extension AuthTextField: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let regexValue = textRegex else {
            isErrorRelay.accept(false)
            return
        }
        
        guard let textValue = textField.text,
            textValue.isEmpty == false else {
            isErrorRelay.accept(true)
            return
        }
        
        isErrorRelay.accept(!NSPredicate(format: "SELF MATCHES %@", regexValue).evaluate(with: textValue))
    }
}
