import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class AuthTermsList: UIView {
    let disposebag = DisposeBag()

    private let allFormLabel = UILabel().then {
        $0.text = "모두 동의"
        $0.textColor = .black
        $0.font = .main1Medium
    }

    private let form1Label = UILabel().then {
        $0.text = "[필수] 이용약관 동의"
        $0.textColor = .black
        $0.font = .main1Medium
    }

    private let form2Label = UILabel().then {
        $0.text = "[필수] 개인정보 수집·이용 동의"
        $0.textColor = .black
        $0.font = .main1Medium
    }

    private let form3Label = UILabel().then {
        $0.text = "[선택] 홍보 및 마케팅 수집·이용 동의"
        $0.textColor = .black
        $0.font = .main1Medium
    }

    private let allFormToggleButton = AuthToggleButton()
    private let form1ToggleButton = AuthToggleButton()
    private let form2ToggleButton = AuthToggleButton()
    private let form3ToggleButton = AuthToggleButton()

    private let spacerBarView = UIView().then {
        $0.backgroundColor = .whiteElevated4
    }

    init() {
        super.init(frame: .zero)
        layer.cornerRadius = 20
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.whiteElevated4?.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension AuthTermsList {
    private func addSubViews() {
        [
            allFormLabel,
            form1Label,
            form2Label,
            form3Label,
            allFormToggleButton,
            form1ToggleButton,
            form2ToggleButton,
            form3ToggleButton,
            spacerBarView
        ].forEach({ addSubview($0) })
    }

    private func makeConstraints() {
        spacerBarView.snp.makeConstraints {
            $0.top.equalTo(allFormLabel.snp.bottom).offset(33)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(0.5)
        }
        form1ToggleButton.snp.makeConstraints {
            $0.top.equalTo(spacerBarView.snp.bottom).offset(38)
            $0.leftMargin.equalTo(20)
        }
        form2ToggleButton.snp.makeConstraints {
            $0.top.equalTo(form1Label.snp.bottom).offset(38)
            $0.leftMargin.equalTo(20)
        }
        form3ToggleButton.snp.makeConstraints {
            $0.top.equalTo(form2Label.snp.bottom).offset(38)
            $0.leftMargin.equalTo(20)
        }
        allFormLabel.snp.makeConstraints {
            $0.topMargin.equalTo(36)
            $0.left.equalTo(allFormToggleButton.snp.right).offset(15)
        }
        form1Label.snp.makeConstraints {
            $0.top.equalTo(form1ToggleButton)
            $0.left.equalTo(form1ToggleButton.snp.right).offset(15)
        }
        form2Label.snp.makeConstraints {
            $0.top.equalTo(form2ToggleButton)
            $0.left.equalTo(form2ToggleButton.snp.right).offset(15)
        }
        form3Label.snp.makeConstraints {
            $0.top.equalTo(form3ToggleButton)
            $0.left.equalTo(form1ToggleButton.snp.right).offset(15)
        }
        allFormToggleButton.snp.makeConstraints {
            $0.topMargin.equalTo(36)
            $0.leftMargin.equalTo(20)
        }
    }
}
