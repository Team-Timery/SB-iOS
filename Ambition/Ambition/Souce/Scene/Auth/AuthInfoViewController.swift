//
//  AuthInfoViewController.swift
//  Ambition
//
//  Created by 조병진 on 2023/02/11.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class AuthInfoViewController: UIViewController {
    
    private let nameTextField = AuthTextField(lable: "이름")
    
    private let ageTextField = AuthTextField(lable: "나이")
    
    private let sexDropdownView = AuthDropDown(label: "성별", items: ["남자", "여자", "표시안함"])
    
    private let nextButton = AuthNextButton(title: "다음")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "계정 만들기"
    }
    
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension AuthInfoViewController {
    private func addSubViews() {
        [
            nameTextField,
            ageTextField,
            nextButton,
            sexDropdownView
        ].forEach({ view.addSubview($0) })
    }
    
    private func makeConstraints() {
        nameTextField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(19)
            $0.height.equalTo(60)
            $0.top.equalToSuperview().inset(view.safeAreaInsets.top + 50)
        }
        
        ageTextField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(19)
            $0.height.equalTo(60)
            $0.top.equalTo(nameTextField.snp.bottom).offset(42)
        }
        
        sexDropdownView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(19)
            $0.height.equalTo(60)
            $0.top.equalTo(ageTextField.snp.bottom).offset(42)
        }
        
        nextButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(19)
            $0.height.equalTo(60)
            $0.bottom.equalToSuperview().inset(view.safeAreaInsets.bottom == 0 ? 15 : 37)
        }
    }
}
