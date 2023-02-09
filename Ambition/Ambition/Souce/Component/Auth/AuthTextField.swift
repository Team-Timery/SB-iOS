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
    
    var isError = BehaviorRelay(value: false)
    
    private let titleLabel = UILabel().then {
        $0.textColor = .whiteElevated4
        $0.font = .main2Medium
    }
    
    private let errorLabel = UILabel().then {
        $0.textColor = .error
        $0.font = .main2Medium
        $0.layer.opacity = 0
    }
    
    init(lable: String, errorMessage: String = "error") {
        super.init(frame: .zero)
        backgroundColor = .white
        textColor = .black
        font = UIFont.title3Medium
        titleLabel.text = lable
        errorLabel.text = errorMessage
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.whiteElevated4?.cgColor
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 19, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
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
        isError.asObservable()
            .bind { [self] status in
                layer.borderColor = status ? UIColor.error?.cgColor : UIColor.whiteElevated4?.cgColor
                errorLabel.layer.opacity = status ? 1 : 0
            }
            .disposed(by: disposedBag)
    }
}

extension AuthTextField {
    private func addSubviews() {
        [
            titleLabel,
            errorLabel
        ].forEach({ addSubview($0) })
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(9)
            $0.bottom.equalTo(self.snp.top).offset(-8)
        }
        
        errorLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(3)
            $0.top.equalTo(self.snp.bottom).offset(8)
        }
    }
}
