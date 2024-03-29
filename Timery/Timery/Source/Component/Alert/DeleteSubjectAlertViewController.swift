import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class DeleteSubjectAlertViewController: UIViewController {

    private let disposeBag = DisposeBag()

    private let alertBackgroundView = UIView().then {
        $0.backgroundColor = .grayDarken3
        $0.layer.cornerRadius = 30
    }

    private let titleLabel = UILabel().then {
        $0.textColor = .grayDarken4
        $0.font = .miniTitle3Bold
        $0.numberOfLines = .max
        $0.lineBreakStrategy = .pushOut
    }

    private let messageLabel = UILabel().then {
        $0.text = "측정 기록은 지워지지 않아요"
        $0.textColor = .whiteElevated4
        $0.font = .mini1Medium
        $0.textAlignment = .left
        $0.numberOfLines = .max
        $0.lineBreakStrategy = .pushOut
    }

    private let alertCancelButton = UIButton(type: .system).then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(UIColor.mainElevated, for: .normal)
        $0.titleLabel?.font = UIFont.miniTitle3Bold
        $0.backgroundColor = .main
        $0.layer.cornerRadius = 30
    }

    private let alertDeleteButton = UIButton(type: .system).then {
        $0.setTitle("삭제", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont.miniTitle3Bold
        $0.backgroundColor = .mainElevated
        $0.layer.cornerRadius = 30
    }

    init(
        subjectName: String? = nil,
        completion: @escaping () -> Void,
        alertStyle: AlertStyle = .light
    ) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = (subjectName ?? "알수없음") + "을(를) 삭제할까요?"
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

extension DeleteSubjectAlertViewController {
    private func bind(completion: @escaping () -> Void) {
        alertCancelButton.rx.tap
            .bind {
                self.dismiss(animated: false)
            }
            .disposed(by: disposeBag)

        alertDeleteButton.rx.tap
            .bind {
                completion()
                self.dismiss(animated: false)
            }
            .disposed(by: disposeBag)
    }

    private func addSubViews() {
        view.addSubview(alertBackgroundView)

        [
            titleLabel,
            messageLabel,
            alertCancelButton,
            alertDeleteButton
        ].forEach({ alertBackgroundView.addSubview($0) })
    }

    private func makeConstraints() {
        alertBackgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.right.left.equalToSuperview().inset(30)
            $0.bottom.equalTo(alertDeleteButton.snp.bottom).offset(14)
        }
        titleLabel.snp.makeConstraints {
            $0.topMargin.equalTo(36)
            $0.left.right.equalToSuperview().inset(45)
        }
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(9)
            $0.right.left.equalToSuperview().inset(45)
        }
        alertDeleteButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.right.equalToSuperview().inset(13)
            $0.left.equalTo(alertBackgroundView.snp.centerX).offset(4)
            $0.top.equalTo(messageLabel.snp.bottom).offset(33)
        }
        alertCancelButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leftMargin.equalTo(13)
            $0.right.equalTo(alertBackgroundView.snp.centerX).offset(-4)
            $0.top.equalTo(messageLabel.snp.bottom).offset(33)
        }
    }
}
