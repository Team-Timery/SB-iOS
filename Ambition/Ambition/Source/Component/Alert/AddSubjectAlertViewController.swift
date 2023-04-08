//
//  AddSubjectAlertViewController.swift
//  Ambition
//
//  Created by 조병진 on 2023/02/26.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class AddSubjectAlertViewController: UIViewController {
    private let disposeBag = DisposeBag()

    private let alertBackgroundView = UIView().then {
        $0.backgroundColor = .grayDarken3
        $0.layer.cornerRadius = 30
    }

    private let titleLabel = UILabel().then {
        $0.text = "과목 추가하기"
        $0.textColor = .white
        $0.font = .title3Bold
        $0.textAlignment = .center
    }

    private let emojiButton = UIButton(type: .system).then {
        $0.setTitle("🔥", for: .normal)
        $0.backgroundColor = .whiteElevated1
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.cornerRadius = 10
    }

    private let subjectNameTextField = UITextField().then {
        $0.font = .main1Medium
        $0.placeholder = "ex) 과학"
        $0.backgroundColor = .whiteElevated1
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.cornerRadius = 10
        $0.autocapitalizationType = .none
    }

    private let alertCancelButton = UIButton(type: .system).then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(UIColor.mainElevated, for: .normal)
        $0.titleLabel?.font = UIFont.title3Bold
        $0.backgroundColor = .main
        $0.layer.cornerRadius = 30
    }

    private let alertAddButton = UIButton(type: .system).then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont.title3Bold
        $0.backgroundColor = .mainElevated
        $0.layer.cornerRadius = 30
    }

    init(
        action: @escaping () -> Void,
        alertStyle: AlertStyle = .light
    ) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.textColor = alertStyle == .light ? .black : .white
        alertBackgroundView.backgroundColor = alertStyle == .light ? .white : .grayDarken3
        alertCancelButton.backgroundColor = alertStyle == .light ? .main : .grayDarken2
        modalPresentationStyle = .overFullScreen
        bind(addAction: action)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 1))
        subjectNameTextField.leftView = paddingView
        subjectNameTextField.rightView = paddingView
        subjectNameTextField.leftViewMode = .always
        subjectNameTextField.rightViewMode = .always
    }

    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension AddSubjectAlertViewController {
    private func bind(addAction: @escaping () -> Void) {
        alertCancelButton.rx.tap
            .bind {
                self.dismiss(animated: false)
            }
            .disposed(by: disposeBag)

        alertAddButton.rx.tap
            .bind {
                addAction()
            }
            .disposed(by: disposeBag)
    }

    private func addSubViews() {
        view.addSubview(alertBackgroundView)

        [
            titleLabel,
            emojiButton,
            subjectNameTextField,
            alertCancelButton,
            alertAddButton
        ].forEach({ alertBackgroundView.addSubview($0) })
    }

    private func makeConstraints() {
        alertBackgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.right.left.equalToSuperview().inset(30)
            $0.bottom.equalTo(alertAddButton.snp.bottom).offset(14)
        }
        titleLabel.snp.makeConstraints {
            $0.topMargin.equalTo(36)
            $0.left.right.equalToSuperview().inset(45)
        }
        emojiButton.snp.makeConstraints {
            $0.width.height.equalTo(44)
            $0.leftMargin.equalTo(22)
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
        }
        subjectNameTextField.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.left.equalTo(emojiButton.snp.right).offset(7)
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.rightMargin.equalTo(-22)
        }
        alertAddButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.right.equalToSuperview().inset(13)
            $0.left.equalTo(alertBackgroundView.snp.centerX).offset(4)
            $0.top.equalTo(emojiButton.snp.bottom).offset(33)
        }
        alertCancelButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leftMargin.equalTo(13)
            $0.right.equalTo(alertBackgroundView.snp.centerX).offset(-4)
            $0.top.equalTo(emojiButton.snp.bottom).offset(33)
        }
    }
}
