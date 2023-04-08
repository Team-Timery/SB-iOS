import UIKit
import SnapKit
import Then

class AuthTermsViewController: UIViewController {

    private let titleLabel = UILabel().then {
        $0.text = "갓생 시작하기"
        $0.textColor = .black
        $0.font = .titleXLBold
    }

    private let subTitleLabel = UILabel().then {
        $0.text = "서비스 이용을 위해 아래에 동의해주세요"
        $0.textColor = .whiteElevated4
        $0.font = .title3Medium
    }

    private let termsList = AuthTermsList()

    private let nextButton = AuthNextButton(title: "다음")

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }

    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension AuthTermsViewController {
    private func addSubViews() {
        [
            titleLabel,
            subTitleLabel,
            nextButton,
            termsList
        ].forEach({ view.addSubview($0) })
    }

    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.topMargin.equalTo(67)
        }

        subTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(22)
        }

        termsList.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(50)
            $0.left.right.equalToSuperview().inset(19)
            $0.height.equalTo(306)
        }

        nextButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(19)
            $0.height.equalTo(60)
            $0.bottom.equalToSuperview().inset(view.safeAreaInsets.bottom == 0 ? 15 : 37)
        }
    }
}
