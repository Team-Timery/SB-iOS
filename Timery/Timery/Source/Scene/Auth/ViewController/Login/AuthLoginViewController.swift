import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class AuthLoginViewController: UIViewController {

    private let disposeBag = DisposeBag()

    private let titleLabel = UILabel().then {
        $0.text = "로그인하기"
        $0.font = .title2Bold
    }

    private let emailTextfield = AuthTextField(
        placeholder: "이메일 입력",
        errorMessage: "옳바른 이메일 형식으로 입력해주세요"
    )

    private let passwordTextfield = AuthTextField(
        placeholder: "비밀번호 입력",
        errorMessage: "옳바른 비밀번호 형식으로 입력해주세요",
        isSecure: true
    )

    private let nextButton = AuthNextButton(title: "다음")

    private let viewModel = LoginViewModel()
    lazy var input = LoginViewModel.Input(
        idText: emailTextfield.rx.text.orEmpty.asDriver(),
        passwordText: passwordTextfield.rx.text.orEmpty.asDriver(),
        tapNextButton: nextButton.rx.tap.asSignal()
    )
    lazy var output = viewModel.transform(input: input)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.backButtonTitle = "비밀번호"
        navigationItem.backBarButtonItem = NavigationBackButton()
        keyboardNotification()
        hideKeyboardWhenTappedAround()
        bind()
    }

    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension AuthLoginViewController {
    private func bind() {
        output.buttonActivate.asObservable()
            .subscribe(onNext: { status in
                self.nextButton.isActivate = status
            })
            .disposed(by: disposeBag)

        output.isSucceed.asObservable()
            .subscribe { [unowned self] _ in
                let mainView = CustomTapBarController()
                navigationController?.pushViewController(mainView, animated: true)
            }
            .disposed(by: disposeBag)

        output.isEmailError.asObservable()
            .bind(to: emailTextfield.rx.isError)
            .disposed(by: disposeBag)

        output.isPasswordError.asObservable()
            .bind(to: passwordTextfield.rx.isError)
            .disposed(by: disposeBag)

        output.isLoading.asObservable()
            .bind(to: nextButton.rx.isLoading)
            .disposed(by: disposeBag)

        output.isError.asObservable()
            .bind { res in
                let errorAlert = ErrorAlertViewController(
                    titleText: "오류",
                    messageText: "\(res.errorMessage)\n(\(res.rawValue))",
                    alertStyle: .light
                )
                self.present(errorAlert, animated: false)
            }
            .disposed(by: disposeBag)
    }

    private func addSubViews() {
        [
            titleLabel,
            emailTextfield,
            passwordTextfield,
            nextButton
        ].forEach({ view.addSubview($0) })
    }

    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(25)
            $0.topMargin.equalTo(38)
        }
        emailTextfield.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(25)
            $0.top.equalTo(titleLabel.snp.bottom).offset(46)
        }
        passwordTextfield.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(25)
            $0.top.equalTo(emailTextfield.snp.bottom).offset(48)
        }
        nextButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(19)
            $0.height.equalTo(60)
            $0.bottom.equalToSuperview().inset(view.safeAreaInsets.bottom == 0 ? 15 : 37)
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

        let targetObject = nextButton
        if sender.name == UIResponder.keyboardWillShowNotification {
            let correctionValue = targetObject.center.y - (self.view.frame.height / 2)
            let topOfKeyboard = (self.view.frame.height / 2) - (keyboardFrame.height) - correctionValue
            let moveTo = topOfKeyboard - targetObject.frame.height / 2 - 15
            targetObject.transform = CGAffineTransform(translationX: 0, y: moveTo)
        } else {
            targetObject.transform = .identity
        }
    }
}
