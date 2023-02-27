//
//  SimpleAlertViewController.swift
//  Ambition
//
//  Created by 조병진 on 2023/02/23.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class SimpleAlertViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let alertBackgroundView = UIView().then {
        $0.backgroundColor = .grayDarken2
        $0.layer.cornerRadius = 30
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .title3Bold
    }
    
    private let messageLabel = UILabel().then {
        $0.textColor = .whiteElevated4
        $0.font = .main1Medium
        $0.textAlignment = .left
        $0.numberOfLines = .max
        $0.lineBreakStrategy = .pushOut
    }
    
    init(
        titleText: String? = nil,
        messageText: String? = nil,
        alertStyle: AlertStyle = .light
    ) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = titleText
        messageLabel.text = messageText
        titleLabel.textColor = alertStyle == .light ? .black : .white
        alertBackgroundView.backgroundColor = alertStyle == .light ? .white : .grayDarken2
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let alertButton = UIButton(type: .system).then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont.title3Bold
        $0.backgroundColor = .mainElevated
        $0.layer.cornerRadius = 21
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension SimpleAlertViewController {
    private func bind() {
        alertButton.rx.tap
            .bind {
                self.dismiss(animated: false)
            }
            .disposed(by: disposeBag)
    }
    
    private func addSubViews() {
        view.addSubview(alertBackgroundView)
        
        [
            titleLabel,
            messageLabel,
            alertButton
        ].forEach({ alertBackgroundView.addSubview($0) })
    }
    
    private func makeConstraints() {
        alertBackgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.right.left.equalToSuperview().inset(30)
            $0.bottom.equalTo(alertButton.snp.bottom).offset(26)
        }
        titleLabel.snp.makeConstraints {
            $0.topMargin.equalTo(36)
            $0.left.right.equalToSuperview().inset(31)
        }
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(9)
            $0.right.left.equalToSuperview().inset(35)
        }
        alertButton.snp.makeConstraints {
            $0.height.equalTo(42)
            $0.right.left.equalToSuperview().inset(22)
            $0.top.equalTo(messageLabel.snp.bottom).offset(33)
        }
    }
}
