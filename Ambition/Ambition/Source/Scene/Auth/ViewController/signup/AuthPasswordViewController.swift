import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class AuthPasswordViewController: UIViewController {

    private let disposeBag = DisposeBag()

    private let titleLabel = UILabel().then {
        $0.text = "비밀번호를 입력해주세요"
        $0.font = .title2Bold
    }

    private let passwordTextfield = AuthTextField(
        placeholder: "비밀번호 입력",
        errorMessage: "옳바른 비밀번호 형식으로 입력해주세요",
        isSecure: true
    )

    private let nextButton = AuthNextButton(title: "다음")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.backButtonTitle = "비밀번호"
        navigationItem.backBarButtonItem = NavigationBackButton()
        hideKeyboardWhenTappedAround()
        bind()
    }

    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension AuthPasswordViewController {
    private func bind() {
        let viewModel = AuthPasswordViewModel()
        let input = AuthPasswordViewModel.Input(
            passwordText: passwordTextfield.rx.text.orEmpty.asDriver(),
            tapNextButton: nextButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input: input)

        output.isPWError.asObservable()
            .bind(to: passwordTextfield.rx.isError)
            .disposed(by: disposeBag)

        output.buttonActivate.asObservable()
            .bind(to: nextButton.rx.isActivate)
            .disposed(by: disposeBag)

        output.gotoNext.asObservable()
            .subscribe(onNext: { _ in
                let nextView = AuthNameViewController()
                self.navigationController?.pushViewController(nextView, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func addSubViews() {
        [
            titleLabel,
            passwordTextfield,
            nextButton
        ].forEach({ view.addSubview($0) })
    }

    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(25)
            $0.topMargin.equalTo(38)
        }
        passwordTextfield.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(25)
            $0.top.equalTo(titleLabel.snp.bottom).offset(46)
        }
        nextButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(19)
            $0.height.equalTo(60)
            $0.bottom.equalToSuperview().inset(view.safeAreaInsets.bottom == 0 ? 15 : 37)
        }
    }
}
