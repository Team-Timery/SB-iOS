//
//  AuthStartViewController.swift
//  Ambition
//
//  Created by 조병진 on 2023/02/10.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class AuthStartViewController: UIViewController {
    
    let disposedBag = DisposeBag()
    
    private let backButton = UIBarButtonItem().then {
        $0.tintColor = .whiteElevated4
    }
    
    private let titleMainLabel = UILabel().then {
        $0.text = "끝가지 가는 열정,"
        $0.textColor = .black
        $0.font = .typograpy
    }
    
    private let titleSubLabel = UILabel().then {
        $0.text = "Ambition"
        $0.textColor = .mainElevated
        $0.font = .typograpy
        $0.layer.opacity = 0.8
    }
    
    private let titleindicatorLabel = UILabel().then {
        $0.text = "로그인 후 측정을 시작하세요"
        $0.textColor = .whiteElevated4
        $0.font = .main2Medium
    }
    
    private lazy var input = AuthStartViewModel.Input(
        googleOauthSignal: oauthGoogleButton.rx.tap.asSignal(),
        appleOauthSignal: oauthAppleButton.rx.tap.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    let viewModel = AuthStartViewModel()
    
    private let oauthGoogleButton = OauthButton(title: "구글로 계속하기", logoImage: UIImage(named: "google_logo"), titleColor: .black, backColor: .white)
    
    private let oauthAppleButton = OauthButton(title: "APPLE로 계속하기", logoImage: UIImage(named: "apple_logo"), titleColor: .white, backColor: .black)
    
    private let indicatorLabel = UILabel().then {
        $0.text = "‘계속하기'를 누르는 것으로 필수 이용약관에 동의하고 서비스를 이용합니다."
        $0.textColor = .whiteElevated4
        $0.font = .main2Medium
        $0.numberOfLines = 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.backBarButtonItem = backButton
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        addSubviews()
        makeConstraints()
    }
}

extension AuthStartViewController {
    private func bind() {
        output.googleOauthAction.asObservable()
            .filter { $0 == true }
            .subscribe(onNext: { [unowned self] _ in
                let view = AuthInfoViewController()
               navigationController?.pushViewController(view, animated: true)
            })
            .disposed(by: disposedBag)
        
        output.appleOauthAction.asObservable()
            .subscribe(onNext: { [unowned self] _ in
                let view = AuthTermsViewController()
                navigationController?.pushViewController(view, animated: true)
            })
            .disposed(by: disposedBag)
    }
    
    private func addSubviews() {
        [
            titleMainLabel,
            titleSubLabel,
            titleindicatorLabel,
            oauthGoogleButton,
            oauthAppleButton,
            indicatorLabel
        ].forEach({ view.addSubview($0) })
    }
    
    private func makeConstraints() {
        titleMainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(view.frame.height / 5)
            $0.leftMargin.equalTo(19)
        }
        
        titleSubLabel.snp.makeConstraints {
            $0.top.equalTo(titleMainLabel.snp.bottom)
            $0.left.equalTo(titleMainLabel)
        }
        
        titleindicatorLabel.snp.makeConstraints {
            $0.top.equalTo(titleSubLabel.snp.bottom).offset(5)
            $0.left.equalTo(titleSubLabel)
        }
        
        oauthGoogleButton.snp.makeConstraints() {
            $0.height.equalTo(60)
            $0.left.right.equalToSuperview().inset(19)
            $0.bottom.equalTo(oauthAppleButton.snp.top).offset(-8)
        }
        
        oauthAppleButton.snp.makeConstraints() {
            $0.height.equalTo(60)
            $0.left.right.equalToSuperview().inset(19)
            $0.bottom.equalToSuperview().inset(view.frame.height / 5)
        }
        
        indicatorLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(view.frame.height / 10)
        }
    }
}
