import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class UserInfoViewController: UIViewController {
    private let disposeBag = DisposeBag()

    private let getProfile = PublishRelay<Void>()
    private let editButton = UIBarButtonItem().then {
        $0.title = "수정"
    }

    private let userImageView = UIImageView().then {
        $0.image = UIImage(named: "user_profile")
    }

    private let nameMarkLabel = UILabel().then {
        $0.text = "이름"
        $0.textColor = .whiteElevated4
        $0.font = .title3Medium
    }

    private let ageMarkLabel = UILabel().then {
        $0.text = "나이"
        $0.textColor = .whiteElevated4
        $0.font = .title3Medium
    }

    private let sexMarkLabel = UILabel().then {
        $0.text = "성별"
        $0.textColor = .whiteElevated4
        $0.font = .title3Medium
    }

    private let emailMarkLabel = UILabel().then {
        $0.text = "로그인 계정"
        $0.textColor = .whiteElevated4
        $0.font = .title3Medium
    }

    private let nameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .title3Medium
    }

    private let ageLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .title3Medium
    }

    private let sexLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .title3Medium
    }

    private let emailLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .title3Medium
    }

    private let viewModel = UserInfoViewModel()
    lazy var input = UserInfoViewModel.Input(getProfile: getProfile.asSignal())
    lazy var output = viewModel.transform(input: input)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "내 정보"
        navigationController?.navigationItem.rightBarButtonItem = editButton
        bind()
        getProfile.accept(())
    }

    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension UserInfoViewController {
    private func bind() {
        output.isSucceed.asObservable()
            .bind { [unowned self] data in
                nameLabel.text = data.name
//                ageLabel.text = "\(data.age)"
//                sexLabel.text = data.sex.toKRString
//                emailLabel.text = data.email
            }
            .disposed(by: disposeBag)

        editButton.rx.tap
            .bind {
                let editView = UIViewController()
                self.navigationController?.pushViewController(editView, animated: true)
            }
            .disposed(by: disposeBag)
    }
    private func addSubViews() {
        [
            userImageView,
            nameMarkLabel,
//            ageMarkLabel,
//            sexMarkLabel,
//            emailMarkLabel,
            nameLabel,
//            ageLabel,
//            sexLabel,
//            emailLabel
        ].forEach({ view.addSubview($0) })
    }

    private func makeConstraints() {
        userImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.topMargin.equalTo(35)
            $0.height.width.equalTo(75)
        }
        nameMarkLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(userImageView.snp.bottom).offset(30)
        }
//        ageMarkLabel.snp.makeConstraints {
//            $0.left.equalTo(nameMarkLabel)
//            $0.top.equalTo(nameMarkLabel.snp.bottom).offset(38)
//        }
//        sexMarkLabel.snp.makeConstraints {
//            $0.left.equalTo(nameMarkLabel)
//            $0.top.equalTo(ageMarkLabel.snp.bottom).offset(38)
//        }
//        emailMarkLabel.snp.makeConstraints {
//            $0.left.equalTo(nameMarkLabel)
//            $0.top.equalTo(sexMarkLabel.snp.bottom).offset(38)
//        }
        nameLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(nameMarkLabel)
        }
//        ageLabel.snp.makeConstraints {
//            $0.right.equalTo(nameLabel)
//            $0.top.equalTo(nameLabel.snp.bottom).offset(38)
//        }
//        sexLabel.snp.makeConstraints {
//            $0.right.equalTo(nameLabel)
//            $0.top.equalTo(ageLabel.snp.bottom).offset(38)
//        }
//        emailLabel.snp.makeConstraints {
//            $0.right.equalTo(nameLabel)
//            $0.top.equalTo(sexLabel.snp.bottom).offset(38)
//        }
    }
}
