import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class StopTimerAlertViewController: UIViewController {

    private let disposeBag = DisposeBag()

    private var isShow: Bool = false
    private var startTime = BehaviorRelay<Date>(value: Date())
    private var subjectID = BehaviorRelay<Int>(value: 0)

    private let alertBackgroundView = UIView().then {
        $0.backgroundColor = .grayDarken3
        $0.layer.cornerRadius = 30
    }

    private let titleLabel = UILabel().then {
        $0.text = "타이머 측정을 멈추시겠어요?"
        $0.textColor = .white
        $0.font = .miniTitle3Bold
    }

    private let messageLabel = UILabel().then {
        $0.text = "과거의 나를 이겨야 해요"
        $0.textColor = .whiteElevated4
        $0.font = .mini1Medium
        $0.textAlignment = .left
        $0.numberOfLines = .max
        $0.lineBreakStrategy = .pushOut
    }

    private let memoLabel = UILabel().then {
        $0.text = "공부한 내용 메모하기"
        $0.textColor = .white
        $0.font = .mini1Medium
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
        $0.setTitleColor(UIColor.mainElevated, for: .normal)
        $0.titleLabel?.font = UIFont.miniTitle3Bold
        $0.backgroundColor = .main
        $0.layer.cornerRadius = 30
    }

    private let alertStopButton = UIButton(type: .system).then {
        $0.setTitle("예", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont.miniTitle3Bold
        $0.backgroundColor = .mainElevated
        $0.layer.cornerRadius = 30
    }

    let viewModel = StopTimerAlertViewModel()
    lazy var input = StopTimerAlertViewModel.Input(
        stopTimer: alertStopButton.rx.tap.asSignal(),
        startTime: startTime.asDriver(),
        memo: memoTextField.rx.text.orEmpty.asDriver(),
        subjectID: subjectID.asDriver()
    )
    lazy var output = viewModel.transform(input: input)

    init(
        alertStyle: AlertStyle = .light,
        isShowMemo: Bool = false,
        startTime: Date,
        subjectID: Int,
        completion: @escaping () -> Void
    ) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.textColor = alertStyle.textColor
        alertBackgroundView.backgroundColor = alertStyle.backgroungColor
        alertCancelButton.backgroundColor = alertStyle.buttonBackgroundColor
        isShow = isShowMemo
        self.startTime.accept(startTime)
        self.subjectID.accept(subjectID)
        modalPresentationStyle = .overFullScreen
        bind(completion: completion)
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
        keyboardNotification()
        hideKeyboardWhenTappedAround()
    }

    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension StopTimerAlertViewController {
    private func bind(completion: @escaping () -> Void) {
        output.isSucceed.asObservable()
            .subscribe(onNext: {
                self.dismiss(animated: false)
                completion()
            })
            .disposed(by: disposeBag)

        output.isButtonActivate.asObservable()
            .subscribe(onNext: { [weak self] status in
                self?.alertStopButton.layer.opacity = status ? 1 : 0.3
                self?.alertStopButton.isEnabled = status
            })
            .disposed(by: disposeBag)

        alertCancelButton.rx.tap
            .bind {
                self.dismiss(animated: false)
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
        if self.isShow {
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
            $0.top.equalTo(messageLabel.snp.bottom).offset(30)
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
            $0.right.equalToSuperview().inset(13)
            $0.left.equalTo(alertBackgroundView.snp.centerX).offset(4)
            $0.top.greaterThanOrEqualTo(memoLabel.snp.bottom).offset(18)
        }
        alertCancelButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leftMargin.equalTo(13)
            $0.right.equalTo(alertBackgroundView.snp.centerX).offset(-4)
            $0.top.greaterThanOrEqualTo(memoLabel.snp.bottom).offset(18)
        }
    }

    private func keyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardControll(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardControll(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc func keyboardControll(_ sender: Notification) {
        guard let userInfo = sender.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }

        if sender.name == UIResponder.keyboardWillShowNotification {
            let topOfKeyboard = (self.view.frame.height / 2) - (keyboardFrame.height)
            let moveTo = topOfKeyboard - alertBackgroundView.frame.height / 2 - 15
            self.alertBackgroundView.transform = CGAffineTransform(translationX: 0, y: moveTo)
        } else {
            self.alertBackgroundView.transform = .identity
        }
    }
}
