import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class AuthAgeSexViewController: UIViewController {

    private let disposeBag = DisposeBag()

    private let titleLabel = UILabel().then {
        $0.text = "나이와 성별을 알려주세요"
        $0.font = .title2Bold
    }

    private let agePickerButton = AuthPickerButton(
        placeholder: "나이 선택",
        errorMessage: "나이를 선택해주세요!"
    )

    private let sexPickerButton = AuthPickerButton(
        placeholder: "성별 선택",
        errorMessage: "성별을 선택해주세요!"
    )

    private let agePickerView = AuthPickerView().then {
        $0.pickerData = Array(1...100)
    }

    private let sexPickerView = AuthPickerView().then {
        $0.pickerData = ["남자", "여자", "둘 다 아님"]
    }

    private let nextButton = AuthNextButton(title: "다음")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.backButtonTitle = "나이&성별"
        navigationItem.backBarButtonItem = NavigationBackButton()
        hideKeyboardWhenTappedAround()
        bind()
    }

    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension AuthAgeSexViewController {
    private func bind() {
        let viewModel = AuthAgeSexViewModel()
        let input = AuthAgeSexViewModel.Input(
            ageValue: agePickerView.selectData.asDriver(onErrorJustReturn: ""),
            sexValue: sexPickerView.selectData.asDriver(onErrorJustReturn: ""),
            tapNextButton: nextButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input: input)

        agePickerButton.rx.tap
            .bind { [unowned self] in
                agePickerView.pickerButton = agePickerButton
                agePickerView.modalPresentationStyle = .overFullScreen
                present(agePickerView, animated: true)
            }
            .disposed(by: disposeBag)

        sexPickerButton.rx.tap
            .bind { [unowned self] in
                sexPickerView.pickerButton = sexPickerButton
                sexPickerView.modalPresentationStyle = .overFullScreen
                present(sexPickerView, animated: true)
            }
            .disposed(by: disposeBag)

        output.buttonActivate.asObservable()
            .bind(to: nextButton.rx.isActivate)
            .disposed(by: disposeBag)

        output.gotoNext.asObservable()
            .subscribe(onNext: { _ in
                let nextView = AuthTermsViewController()
                self.navigationController?.pushViewController(nextView, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func addSubViews() {
        [
            titleLabel,
            agePickerButton,
            sexPickerButton,
            nextButton
        ].forEach({ view.addSubview($0) })
    }

    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(25)
            $0.topMargin.equalTo(38)
        }
        agePickerButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(25)
            $0.top.equalTo(titleLabel.snp.bottom).offset(46)
        }
        sexPickerButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(25)
            $0.top.equalTo(agePickerButton.snp.bottom).offset(47)
        }
        nextButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(19)
            $0.height.equalTo(60)
            $0.bottom.equalToSuperview().inset(view.safeAreaInsets.bottom == 0 ? 15 : 37)
        }
    }
}
