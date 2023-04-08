import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class QuitAlertViewController: UIViewController {
    private let disposeBag = DisposeBag()

    private let alertBackgroundView = UIView().then {
        $0.backgroundColor = .grayDarken3
        $0.layer.cornerRadius = 30
    }

    private let imageView = UIImageView(image: UIImage(named: "circle_exclamation_mark"))

    private let titleLabel = UILabel().then {
        $0.text = "정말 탈퇴하시겠어요?"
        $0.textColor = .white
        $0.font = .title3Bold
        $0.textAlignment = .center
    }

    private let messageLabel = UILabel().then {
        $0.text = "측정 기록, 과목, 내 정보등\n모든 데이터가 삭제되고 복구할 수 없어요"
        $0.textColor = .whiteElevated4
        $0.font = .main1Medium
        $0.textAlignment = .center
        $0.numberOfLines = .max
    }

    private let alertQuitButton = UIButton(type: .system).then {
        $0.setTitle("탈퇴하기", for: .normal)
        $0.setTitleColor(UIColor.mainElevated, for: .normal)
        $0.titleLabel?.font = UIFont.title3Bold
        $0.backgroundColor = .main
        $0.layer.cornerRadius = 30
    }

    private let alertCancelButton = UIButton(type: .system).then {
        $0.setTitle("계속 쓸래요", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont.title3Bold
        $0.backgroundColor = .mainElevated
        $0.layer.cornerRadius = 30
    }

    init(
        action: @escaping () -> Void,
        alertStyle: AlertStyle = .light
    ) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.textColor = alertStyle == .light ? .black : .white
        alertBackgroundView.backgroundColor = alertStyle == .light ? .white : .grayDarken3
        alertQuitButton.backgroundColor = alertStyle == .light ? .main : .grayDarken2
        modalPresentationStyle = .overFullScreen
        bind(quitAction: action)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.5)
    }

    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension QuitAlertViewController {
    private func bind(quitAction: @escaping () -> Void) {
        alertCancelButton.rx.tap
            .bind {
                self.dismiss(animated: false)
            }
            .disposed(by: disposeBag)

        alertQuitButton.rx.tap
            .bind {
                quitAction()
            }
            .disposed(by: disposeBag)
    }

    private func addSubViews() {
        view.addSubview(alertBackgroundView)

        [
            imageView,
            titleLabel,
            messageLabel,
            alertCancelButton,
            alertQuitButton
        ].forEach({ alertBackgroundView.addSubview($0) })
    }

    private func makeConstraints() {
        alertBackgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.right.left.equalToSuperview().inset(30)
            $0.bottom.equalTo(alertQuitButton.snp.bottom).offset(14)
        }
        imageView.snp.makeConstraints {
            $0.size.equalTo(70)
            $0.topMargin.equalTo(36)
            $0.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(9)
            $0.left.right.equalToSuperview().inset(22)
        }
        alertQuitButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leftMargin.equalTo(13)
            $0.right.equalTo(alertBackgroundView.snp.centerX).offset(-4)
            $0.top.equalTo(messageLabel.snp.bottom).offset(36)
        }
        alertCancelButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.right.equalToSuperview().inset(13)
            $0.left.equalTo(alertBackgroundView.snp.centerX).offset(4)
            $0.top.equalTo(messageLabel.snp.bottom).offset(36)
        }
    }
}
