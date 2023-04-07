//
//  StopTimerAlertViewController.swift
//  Ambition
//
//  Created by 조병진 on 2023/02/27.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class StopTimerAlertViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    private var isShow: Bool = false

    private let alertBackgroundView = UIView().then {
        $0.backgroundColor = .grayDarken3
        $0.layer.cornerRadius = 30
    }

    private let titleLabel = UILabel().then {
        $0.text = "타이머 측정을 멈추시겠어요?"
        $0.textColor = .white
        $0.font = .title3Bold
    }
    
    private let messageLabel = UILabel().then {
        $0.text = "과거의 나를 이겨야 해요"
        $0.textColor = .whiteElevated4
        $0.font = .main1Medium
        $0.textAlignment = .left
        $0.numberOfLines = .max
        $0.lineBreakStrategy = .pushOut
    }
    
    private let memoLabel = UILabel().then {
        $0.text = "공부한 내용 메모하기"
        $0.textColor = .white
        $0.font = .main1Medium
    }
    
    private let memoPopupButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "down_arrow_round_line"), for: .normal)
        $0.tintColor = .white
    }
    
    private let memoTextField = UITextField().then {
        $0.font = .main1Medium
        $0.textColor = .white
        $0.attributedPlaceholder = NSAttributedString(
            string: "ex) 수학 35~40페이지",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.whiteElevated4!]
        )
        $0.backgroundColor = .grayDarken2
        $0.layer.cornerRadius = 10
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
    }

    private let alertCancelButton = UIButton(type: .system).then {
        $0.setTitle("아니요", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont.title3Bold
        $0.backgroundColor = .mainElevated
        $0.layer.cornerRadius = 30
    }

    private let alertStopButton = UIButton(type: .system).then {
        $0.setTitle("예", for: .normal)
        $0.setTitleColor(UIColor.mainElevated, for: .normal)
        $0.titleLabel?.font = UIFont.title3Bold
        $0.backgroundColor = .main
        $0.layer.cornerRadius = 30
    }

    init(
        action: @escaping () -> Void,
        alertStyle: AlertStyle = .light,
        isShowMemo: Bool = false
    ) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.textColor = alertStyle == .light ? .black : .white
        alertBackgroundView.backgroundColor = alertStyle == .light ? .white : .grayDarken3
        alertStopButton.backgroundColor = alertStyle == .light ? .main : .grayDarken2
        isShow = isShowMemo
        modalPresentationStyle = .overFullScreen
        bind(stopAction: action)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 1))
        memoTextField.leftView = paddingView
        memoTextField.rightView = paddingView
        memoTextField.leftViewMode = .always
        memoTextField.rightViewMode = .always
        memoTextField.layer.opacity = 0
        hideKeyboardWhenTappedAround()
    }

    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension StopTimerAlertViewController {
    private func bind(stopAction: @escaping () -> Void) {
        alertCancelButton.rx.tap
            .bind {
                self.dismiss(animated: false)
            }
            .disposed(by: disposeBag)
        
        alertStopButton.rx.tap
            .bind {
                stopAction()
            }
            .disposed(by: disposeBag)
        
        memoPopupButton.rx.tap
            .bind { [unowned self] in
                isShow.toggle()
                memoPopupButton.setImage(UIImage(named: "\(isShow ? "up" : "down")_arrow_round_line"), for: .normal)
                memoAnimation()
            }
            .disposed(by: disposeBag)
    }
    
    private func memoAnimation() {
        if(self.isShow) {
            self.memoTextField.snp.remakeConstraints {
                $0.top.equalTo(self.memoLabel.snp.bottom).offset(18)
            }
            self.alertStopButton.snp.remakeConstraints {
                $0.top.equalTo(self.memoTextField.snp.bottom).offset(25)
            }
            self.alertCancelButton.snp.remakeConstraints {
                $0.top.equalTo(self.memoTextField.snp.bottom).offset(25)
            }
            self.memoTextField.layer.opacity = 1
        } else {
            self.memoTextField.snp.remakeConstraints {
                $0.top.equalTo(self.memoLabel.snp.bottom)
            }
            self.alertStopButton.snp.remakeConstraints {
                $0.top.equalTo(self.memoLabel.snp.bottom).offset(18)
            }
            self.alertCancelButton.snp.remakeConstraints {
                $0.top.equalTo(self.memoLabel.snp.bottom).offset(18)
            }
            self.memoTextField.layer.opacity = 0
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

    private func addSubViews() {
        view.addSubview(alertBackgroundView)
        
        [
            titleLabel,
            messageLabel,
            memoLabel,
            memoPopupButton,
            memoTextField,
            alertCancelButton,
            alertStopButton
        ].forEach({ alertBackgroundView.addSubview($0) })
    }

    private func makeConstraints() {
        alertBackgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.right.left.equalToSuperview().inset(30)
            $0.bottom.equalTo(alertStopButton.snp.bottom).offset(24)
        }
        titleLabel.snp.makeConstraints {
            $0.topMargin.equalTo(36)
            $0.left.right.equalToSuperview().inset(31)
        }
        messageLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(31)
            $0.top.equalTo(titleLabel.snp.bottom).offset(9)
        }
        memoLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(31)
            $0.top.equalTo(messageLabel.snp.bottom).offset(35)
        }
        memoPopupButton.snp.makeConstraints {
            $0.width.height.equalTo(29)
            $0.rightMargin.equalTo(-31)
            $0.centerY.equalTo(memoLabel)
        }
        memoTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.left.right.equalToSuperview().inset(31)
            $0.top.greaterThanOrEqualTo(memoLabel.snp.bottom)
        }
        alertStopButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leftMargin.equalTo(13)
            $0.right.equalTo(alertBackgroundView.snp.centerX).offset(-4)
            $0.top.greaterThanOrEqualTo(memoLabel.snp.bottom).offset(18)
        }
        alertCancelButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.right.equalToSuperview().inset(13)
            $0.left.equalTo(alertBackgroundView.snp.centerX).offset(4) 
            $0.top.greaterThanOrEqualTo(memoLabel.snp.bottom).offset(18)
        }
    }
}
