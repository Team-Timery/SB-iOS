import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

// swiftlint: disable function_body_length
class DummyViewController: UIViewController {

    let disposedBag = DisposeBag()

    private let timerMarkLabel = UILabel().then {
        $0.text = "시간 측정"
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
    }

    private let timerButton = UIButton(type: .system).then {
        $0.layer.cornerRadius = 20
        $0.backgroundColor = UIColor(named: "white-Elevated1")
    }

    private let timerButtonImage = UIImageView(image: .init(named: "main_timer_button"))

    private let timerButtonMarkSubLabel = UILabel().then {
        $0.text = "열정 기록하기"
        $0.textColor = UIColor(named: "white-Elevated4")
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }

    private let timerButtonMarkTitleLabel = UILabel().then {
        $0.text = "타이머"
        $0.textColor = UIColor(named: "white-Elevated5")
        $0.font = UIFont(name: "Pretendard-Bold", size: 20)
    }

    private let graphMarkLabel = UILabel().then {
        $0.text = "통계"
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
    }

    private let graphButton = UIButton(type: .system).then {
        $0.layer.cornerRadius = 20
        $0.backgroundColor = UIColor(named: "white-Elevated1")
    }

    private let graphButtonImage = UIImageView(image: .init(named: "main_graph_button"))

    private let graphButtonMarkSubLabel = UILabel().then {
        $0.text = "내 성장을 확인할"
        $0.textColor = UIColor(named: "white-Elevated4")
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }

    private let graphButtonMarkTitleLabel = UILabel().then {
        $0.text = "성장지표"
        $0.textColor = UIColor(named: "white-Elevated5")
        $0.font = UIFont(name: "Pretendard-Bold", size: 20)
    }

    private let testTextField = AuthTextField(errorMessage: "한글, 영문 또는 숫자 1~20자를 입력해 주세요").then {
        $0.clearButtonMode = .always
    }

    private let testButton = AuthPickerButton(
        placeholder: "성별 선택",
        errorMessage: "성별을 선택해주세요!"
    )

    private let pickView = AuthPickerView().then {
        $0.pickerData = Array(1...100)
    }

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

extension DummyViewController {
    private func addSubViews() {
        [
            timerMarkLabel,
            timerButton,
            graphMarkLabel,
            graphButton,
            testTextField,
            testButton
        ].forEach({ view.addSubview($0) })

        [
            timerButtonImage,
            timerButtonMarkSubLabel,
            timerButtonMarkTitleLabel
        ].forEach({ timerButton.addSubview($0) })

        [
            graphButtonImage,
            graphButtonMarkSubLabel,
            graphButtonMarkTitleLabel
        ].forEach({ graphButton.addSubview($0) })
    }

    private func makeConstraints() {
        timerMarkLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(36)
            $0.topMargin.equalTo(100)
        }
        timerButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(26)
            $0.top.equalTo(timerMarkLabel.snp.bottom).offset(24)
            $0.height.equalTo(85)
        }
        timerButtonImage.snp.makeConstraints {
            $0.leftMargin.equalTo(23)
            $0.centerY.equalToSuperview()
        }
        timerButtonMarkSubLabel.snp.makeConstraints {
            $0.topMargin.equalTo(19)
            $0.left.equalTo(timerButtonImage.snp.right).offset(19)
        }
        timerButtonMarkTitleLabel.snp.makeConstraints {
            $0.top.equalTo(timerButtonMarkSubLabel.snp.bottom).offset(4)
            $0.left.equalTo(timerButtonImage.snp.right).offset(19)
        }
        graphMarkLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(36)
            $0.top.equalTo(timerButton.snp.bottom).offset(24)
        }
        graphButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(26)
            $0.top.equalTo(graphMarkLabel.snp.bottom).offset(24)
            $0.height.equalTo(85)
        }
        graphButtonImage.snp.makeConstraints {
            $0.leftMargin.equalTo(23)
            $0.centerY.equalToSuperview()
        }
        graphButtonMarkSubLabel.snp.makeConstraints {
            $0.topMargin.equalTo(19)
            $0.left.equalTo(graphButtonImage.snp.right).offset(19)
        }
        graphButtonMarkTitleLabel.snp.makeConstraints {
            $0.top.equalTo(graphButtonMarkSubLabel.snp.bottom).offset(4)
            $0.left.equalTo(graphButtonImage.snp.right).offset(19)
        }
        testTextField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(19)
            $0.height.equalTo(30)
            $0.centerY.equalToSuperview().offset(300)
        }
        testButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(19)
            $0.height.equalTo(30)
            $0.centerY.equalToSuperview().offset(200)
        }
    }

    private func bind() {
        testButton.rx.tap
            .bind { [unowned self] in
                self.pickView.pickerButton = testButton
                self.pickView.modalPresentationStyle = .overFullScreen
                self.present(self.pickView, animated: true)
            }
            .disposed(by: disposedBag)
    }
}
// swiftlint: enable function_body_length
