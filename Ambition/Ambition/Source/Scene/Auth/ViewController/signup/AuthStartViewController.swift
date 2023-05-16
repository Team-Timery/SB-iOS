import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class AuthStartViewController: UIViewController {
    let disposedBag = DisposeBag()

    private let backButton = UIBarButtonItem().then {
        $0.tintColor = .whiteElevated4
    }

    private let titleMainLabel = UILabel().then {
        $0.text = "끝가지 가는 열정,"
        $0.textColor = .black
        $0.font = .typograpy
    }

    private let titleSubImage = UIImageView().then {
        $0.image = UIImage(named: "TimeMate")
    }

    private let titleindicatorLabel = UILabel().then {
        $0.text = "로그인 후 측정을 시작하세요"
        $0.textColor = .whiteElevated4
        $0.font = .main2Medium
    }

    private let startButton = AuthNextButton(title: "시작하기")

//    private let oauthGoogleButton = OauthButton(
//        title: "구글로 계속하기",
//        logoImage: UIImage(named: "google_logo"),
//        titleColor: .black, backColor: .white
//    )
//
//    private let oauthAppleButton = OauthButton(
//        title: "APPLE로 계속하기",
//        logoImage: UIImage(named: "apple_logo"),
//        titleColor: .white,
//        backColor: .black
//    )

    private let indicatorLoginButton = UIButton(type: .system).then {
        $0.setTitle("이미 회원이신가요? 로그인하기", for: .normal)
        $0.setTitleColor(UIColor.whiteElevated4, for: .normal)
        $0.titleLabel?.font = .main2Medium
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.backButtonTitle = "시작"
        navigationItem.backBarButtonItem = NavigationBackButton()
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
        bind()
    }

    override func viewDidLayoutSubviews() {
        addSubviews()
        makeConstraints()
    }
}

extension AuthStartViewController {
    private func bind() {
        startButton.rx.tap
            .bind { [unowned self] in
                let signupView = AuthEmailViewController()
                navigationController?.pushViewController(signupView, animated: true)
            }
            .disposed(by: disposedBag)

        indicatorLoginButton.rx.tap
            .bind { [unowned self] in
                let loginView = AuthLoginViewController()
                navigationController?.pushViewController(loginView, animated: true)
            }
            .disposed(by: disposedBag)
    }

    private func addSubviews() {
        [
            titleMainLabel,
            titleSubImage,
            titleindicatorLabel,
            startButton,
            indicatorLoginButton
        ].forEach({ view.addSubview($0) })
    }

    private func makeConstraints() {
        titleMainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(view.frame.height / 5)
            $0.leftMargin.equalTo(19)
        }

        titleSubImage.snp.makeConstraints {
            $0.top.equalTo(titleMainLabel.snp.bottom).offset(5)
            $0.left.equalTo(titleMainLabel).offset(2)
        }

        titleindicatorLabel.snp.makeConstraints {
            $0.top.equalTo(titleSubImage.snp.bottom).offset(18)
            $0.left.equalTo(titleSubImage).offset(2)
        }

//        oauthGoogleButton.snp.makeConstraints {
//            $0.height.equalTo(60)
//            $0.left.right.equalToSuperview().inset(19)
//            $0.bottom.equalTo(oauthAppleButton.snp.top).offset(-8)
//        }
//
//        oauthAppleButton.snp.makeConstraints {
//            $0.height.equalTo(60)
//            $0.left.right.equalToSuperview().inset(19)
//            $0.bottom.equalToSuperview().inset(view.frame.height / 5)
//        }

        startButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.left.right.equalToSuperview().inset(19)
            $0.bottom.equalTo(indicatorLoginButton.snp.top).offset(-20)
        }

        indicatorLoginButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(view.frame.height / 10)
        }
    }
}
