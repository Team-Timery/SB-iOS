import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class ErrorAlertViewController: UIViewController {

    private let disposeBag = DisposeBag()

    private let alertBackgroundView = UIView().then {
        $0.backgroundColor = .grayDarken3
        $0.layer.cornerRadius = 30
    }

    private let imageView = UIImageView(image: UIImage(named: "circle_exclamation_mark"))

    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .title3Bold
        $0.textAlignment = .center
    }

    private let messageLabel = UILabel().then {
        $0.textColor = .whiteElevated4
        $0.font = .main1Medium
        $0.textAlignment = .center
        $0.numberOfLines = .max
        $0.lineBreakStrategy = .pushOut
    }

    private let alertButton = UIButton(type: .system).then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont.title3Bold
        $0.backgroundColor = .mainElevated
        $0.layer.cornerRadius = 21
    }

    init(
        titleText: String? = nil,
        messageText: String? = nil,
        alertStyle: AlertStyle = .light
    ) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = titleText
        messageLabel.text = messageText
        titleLabel.textColor = alertStyle.textColor
        alertBackgroundView.backgroundColor = alertStyle.backgroungColor
        modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

extension ErrorAlertViewController {
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
            imageView,
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
        imageView.snp.makeConstraints {
            $0.topMargin.equalTo(36)
            $0.width.height.equalTo(70)
            $0.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(31)
        }
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(11)
            $0.right.left.equalToSuperview().inset(35)
        }
        alertButton.snp.makeConstraints {
            $0.height.equalTo(42)
            $0.right.left.equalToSuperview().inset(22)
            $0.top.equalTo(messageLabel.snp.bottom).offset(36)
        }
    }
}
