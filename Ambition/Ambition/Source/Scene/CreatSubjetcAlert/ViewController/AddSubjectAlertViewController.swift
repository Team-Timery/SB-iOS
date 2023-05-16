import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import EmojiPicker

class AddSubjectAlertViewController: UIViewController {
    private let disposeBag = DisposeBag()

    private let selectEmoji = BehaviorRelay<String>(value: "🔥")
    private var completiont: () -> Void = ({})

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

    private let viewModel = CreateAlertViewModel()
    lazy var input = CreateAlertViewModel.Input(
        createButtonTap: alertAddButton.rx.tap.asSignal(),
        title: subjectNameTextField.rx.text.orEmpty.asDriver(),
        emoji: selectEmoji.asDriver()
    )
    lazy var output = viewModel.transform(input: input)

    init(
        alertStyle: AlertStyle = .light,
        completion: @escaping () -> Void
    ) {
        super.init(nibName: nil, bundle: nil)
        self.completiont = completion
        titleLabel.textColor = alertStyle.textColor
        alertBackgroundView.backgroundColor = alertStyle.backgroungColor
        alertCancelButton.backgroundColor = alertStyle.buttonBackgroundColor
        modalPresentationStyle = .overFullScreen
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
        hideKeyboardWhenTappedAround()
        bind()
    }

    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension AddSubjectAlertViewController {
    private func bind() {
        output.isSucceed.asObservable()
            .subscribe(onNext: { _ in
                self.dismiss(animated: false)
                self.completiont()
            })
            .disposed(by: disposeBag)

        output.isActivate.asObservable()
            .bind { [unowned self] status in
                alertAddButton.backgroundColor = status ? .mainElevated : .main
                alertAddButton.isEnabled = status
            }
            .disposed(by: disposeBag)

        alertCancelButton.rx.tap
            .bind { self.dismiss(animated: false) }
            .disposed(by: disposeBag)

        emojiButton.rx.tap
            .bind {
                let emojiPicker = EmojiPickerViewController()
                emojiPicker.delegate = self
                emojiPicker.sourceView = self.emojiButton
                self.present(emojiPicker, animated: true)
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

extension AddSubjectAlertViewController: EmojiPickerDelegate {
    func didGetEmoji(emoji: String) {
        emojiButton.setTitle(emoji, for: .normal)
        self.selectEmoji.accept(emoji)
    }
}
