import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class AuthEmailViewController: UIViewController {

    private let disposeBag = DisposeBag()

    private let titleLabel = UILabel().then {
        $0.text = "이메일를 입력해주세요"
        $0.font = .title2Bold
    }

    private let emailTextfield = AuthTextField(
        placeholder: "이메일 입력",
        errorMessage: "옳바른 이메일 형식으로 입력해주세요"
    )

    private let nextButton = AuthNextButton(title: "다음")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.backButtonTitle = "아이디"
        navigationItem.backBarButtonItem = NavigationBackButton()
        hideKeyboardWhenTappedAround()
        bind()
    }

    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension AuthEmailViewController {
    private func bind() {
        let viewModel = AuthIDViewModel()
        let input = AuthIDViewModel.Input(
            idText: emailTextfield.rx.text.orEmpty.asDriver(),
            tapNextButton: nextButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input: input)

        output.isIDError.asObservable()
            .bind(to: emailTextfield.rx.isError)
            .disposed(by: disposeBag)

        output.buttonActivate.asObservable()
            .bind(to: nextButton.rx.isActivate)
            .disposed(by: disposeBag)

        output.gotoNext.asObservable()
            .subscribe(onNext: { _ in
                let nextView = AuthPasswordViewController()
                self.navigationController?.pushViewController(nextView, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension AuthEmailViewController {
    private func addSubViews() {
        [
            titleLabel,
            emailTextfield,
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
        nextButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(19)
            $0.height.equalTo(60)
            $0.bottom.equalToSuperview().inset(view.safeAreaInsets.bottom == 0 ? 15 : 37)
        }
    }
}
