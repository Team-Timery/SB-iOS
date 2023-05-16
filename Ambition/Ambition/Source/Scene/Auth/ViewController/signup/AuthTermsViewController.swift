import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class AuthTermsViewController: UIViewController {

    let disposeBag = DisposeBag()

    private let titleLabel = UILabel().then {
        $0.text = "서비스 이용 약관에\n동의해 주세요."
        $0.textColor = .black
        $0.font = .title2Bold
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }

    private let allFormLabel = UILabel().then {
        $0.text = "모두 동의"
        $0.textColor = .black
        $0.font = .main1Medium
    }

    private let form1Label = UILabel().then {
        $0.text = "[필수] 만 14세 이상입니다"
        $0.textColor = .black
        $0.font = .main1Medium
    }

    private let form2Label = UILabel().then {
        $0.text = "[필수] 이용약관 동의"
        $0.textColor = .black
        $0.font = .main1Medium
    }

    private let form3Label = UILabel().then {
        $0.text = "[필수] 개인정보 수집·이용 동의"
        $0.textColor = .black
        $0.font = .main1Medium
    }

    private let form4Label = UILabel().then {
        $0.text = "[선택] 홍보 및 마케팅 수집·이용 동의"
        $0.textColor = .black
        $0.font = .main1Medium
    }

    private let allFormToggleButton = AuthToggleButton()
    private let form1ToggleButton = AuthToggleButton()
    private let form2ToggleButton = AuthToggleButton()
    private let form3ToggleButton = AuthToggleButton()
    private let form4ToggleButton = AuthToggleButton()

    private let spacerBarView = UIView().then {
        $0.backgroundColor = .whiteElevated4
    }

    private let nextButton = AuthNextButton(title: "다음")

    private let viewModel = AuthTermsViewModel()
    lazy var input = AuthTermsViewModel.Input(
        allTogleSelect: allFormToggleButton.rx.tap,
        form1TogleSelect: form1ToggleButton.rx.tap,
        form2TogleSelect: form2ToggleButton.rx.tap,
        form3TogleSelect: form3ToggleButton.rx.tap,
        form4TogleSelect: form4ToggleButton.rx.tap,
        tapNextButton: nextButton.rx.tap.asSignal()
    )
    lazy var output = viewModel.transform(input: input)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bind()
    }

    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension AuthTermsViewController {
    private func bind() {
        output.buttonActivate.asObservable()
            .bind(to: nextButton.rx.isActivate)
            .disposed(by: disposeBag)

        output.isSucceed.asObservable()
            .subscribe(onNext: { _ in
                let nextView = CustomTapBarController()
                self.navigationController?.pushViewController(nextView, animated: true)
            })
            .disposed(by: disposeBag)
        output.allTogleStatus.asObservable()
            .bind(to: allFormToggleButton.rx.isActivate)
            .disposed(by: disposeBag)
        output.form1TogleStatus.asObservable()
            .bind(to: form1ToggleButton.rx.isActivate)
            .disposed(by: disposeBag)
        output.form2TogleStatus.asObservable()
            .bind(to: form2ToggleButton.rx.isActivate)
            .disposed(by: disposeBag)
        output.form3TogleStatus.asObservable()
            .bind(to: form3ToggleButton.rx.isActivate)
            .disposed(by: disposeBag)
        output.form4TogleStatus.asObservable()
            .bind(to: form4ToggleButton.rx.isActivate)
            .disposed(by: disposeBag)
    }

    private func addSubViews() {
        [
            titleLabel,
            spacerBarView,
            allFormLabel,
            allFormToggleButton,
            form1ToggleButton,
            form2ToggleButton,
            form3ToggleButton,
            form4ToggleButton,
            form1Label,
            form2Label,
            form3Label,
            form4Label,
            nextButton
        ].forEach({ view.addSubview($0) })
    }

    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(34)
            $0.topMargin.equalTo(32)
        }
        allFormToggleButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(37)
            $0.top.equalTo(titleLabel.snp.bottom).offset(41)
        }
        spacerBarView.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.top.equalTo(allFormLabel.snp.bottom).offset(35)
            $0.left.right.equalToSuperview().inset(37)
        }
        form1ToggleButton.snp.makeConstraints {
            $0.top.equalTo(spacerBarView.snp.bottom).offset(35)
            $0.left.equalTo(allFormToggleButton)
        }
        form2ToggleButton.snp.makeConstraints {
            $0.top.equalTo(form1ToggleButton.snp.bottom).offset(35)
            $0.left.equalTo(allFormToggleButton)
        }
        form3ToggleButton.snp.makeConstraints {
            $0.top.equalTo(form2ToggleButton.snp.bottom).offset(38)
            $0.left.equalTo(allFormToggleButton)
        }
        form4ToggleButton.snp.makeConstraints {
            $0.top.equalTo(form3ToggleButton.snp.bottom).offset(38)
            $0.left.equalTo(allFormToggleButton)
        }
        allFormLabel.snp.makeConstraints {
            $0.centerY.equalTo(allFormToggleButton.snp.centerY)
            $0.left.equalTo(allFormToggleButton.snp.right).offset(14)
        }
        form1Label.snp.makeConstraints {
            $0.centerY.equalTo(form1ToggleButton.snp.centerY)
            $0.left.equalTo(form1ToggleButton.snp.right).offset(14)
        }
        form2Label.snp.makeConstraints {
            $0.centerY.equalTo(form2ToggleButton.snp.centerY)
            $0.left.equalTo(form2ToggleButton.snp.right).offset(14)
        }
        form3Label.snp.makeConstraints {
            $0.centerY.equalTo(form3ToggleButton.snp.centerY)
            $0.left.equalTo(form3ToggleButton.snp.right).offset(14)
        }
        form4Label.snp.makeConstraints {
            $0.centerY.equalTo(form4ToggleButton.snp.centerY)
            $0.left.equalTo(form4ToggleButton.snp.right).offset(14)
        }

        nextButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(19)
            $0.height.equalTo(60)
            $0.bottom.equalToSuperview().inset(view.safeAreaInsets.bottom == 0 ? 15 : 37)
        }
    }
}
