import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class LogoutAlert: UIViewController {
    private let disposeBag = DisposeBag()

    private let alertBackgroundView = UIView().then {
        $0.backgroundColor = .grayDarken3
        $0.layer.cornerRadius = 30
    }

    private let imageView = UIImageView(image: UIImage(named: "circle_exclamation_mark"))

    private let titleLabel = UILabel().then {
        $0.text = "로그아웃 하시겠습니까?"
        $0.textColor = .white
        $0.font = .title3Bold
        $0.textAlignment = .center
    }

    private let alertLogoutButton = UIButton(type: .system).then {
        $0.setTitle("네", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont.title3Bold
        $0.backgroundColor = .mainElevated
        $0.layer.cornerRadius = 30
    }

    private let alertCancelButton = UIButton(type: .system).then {
        $0.setTitle("아니요", for: .normal)
        $0.setTitleColor(UIColor.mainElevated, for: .normal)
        $0.titleLabel?.font = UIFont.title3Bold
        $0.backgroundColor = .main
        $0.layer.cornerRadius = 30
    }

    init(
        completion: @escaping () -> Void,
        alertStyle: AlertStyle = .light
    ) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.textColor = alertStyle.textColor
        alertBackgroundView.backgroundColor = alertStyle.backgroungColor
        alertCancelButton.backgroundColor = alertStyle.buttonBackgroundColor
        modalPresentationStyle = .overFullScreen
        bind(completion: completion)
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

extension LogoutAlert {
    private func bind(completion: @escaping () -> Void) {
        alertCancelButton.rx.tap
            .bind {
                self.dismiss(animated: false)
            }
            .disposed(by: disposeBag)

        alertLogoutButton.rx.tap
            .bind {
                self.dismiss(animated: false)
                completion()
            }
            .disposed(by: disposeBag)
    }

    private func addSubViews() {
        view.addSubview(alertBackgroundView)

        [
            imageView,
            titleLabel,
            alertCancelButton,
            alertLogoutButton
        ].forEach({ alertBackgroundView.addSubview($0) })
    }

    private func makeConstraints() {
        alertBackgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.right.left.equalToSuperview().inset(30)
            $0.bottom.equalTo(alertLogoutButton.snp.bottom).offset(14)
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
        alertLogoutButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.right.equalToSuperview().inset(13)
            $0.left.equalTo(alertBackgroundView.snp.centerX).offset(4)
            $0.top.equalTo(titleLabel.snp.bottom).offset(25)
        }
        alertCancelButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leftMargin.equalTo(13)
            $0.right.equalTo(alertBackgroundView.snp.centerX).offset(-4)
            $0.top.equalTo(titleLabel.snp.bottom).offset(25)
        }
    }
}
