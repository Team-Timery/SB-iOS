import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

// swiftlint:disable function_body_length line_length
class TimerActivateViewController: UIViewController {

    private let disposedBag = DisposeBag()

    private let startTimer = PublishRelay<Bool>()

    private let timerBackgroundView = UIView().then {
        $0.backgroundColor = .grayDarken4
        $0.layer.cornerRadius = 20
    }

    private let gaugeBackgroundView = UIView().then {
        $0.backgroundColor = .grayDarken4
        $0.layer.cornerRadius = 20
    }

    private let timerTotalTimeLabel = UILabel().then {
        $0.text = "00:00:00"
        $0.textColor = .white
        $0.font = UIFont(name: "Pretendard-Medium", size: 64)
        $0.textAlignment = .center
    }

    private let timerSubjectTimeLabel = UILabel().then {
        $0.text = "00:00:00"
        $0.textColor = .white
        $0.font = .main2Medium
    }

    private let timerTodayTimeLabel = UILabel().then {
        $0.text = "00:00:00"
        $0.textColor = .white
        $0.font = .main2Medium
    }

    private let todayTimerTitleLabel = UILabel().then {
        $0.text = "오늘"
        $0.textColor = .white
        $0.font = .main2Bold
    }

    private let subjectTimerTitleLabel = UILabel().then {
        $0.text = "과목"
        $0.textColor = .white
        $0.font = .main2Bold
    }

    private let gaugeTitleLabel = UILabel().then {
        $0.text = "집중게이지"
        $0.textColor = .white
        $0.font = .title3Bold
    }

    private let gaugeProgressBarView = UIProgressView().then {
        $0.progressViewStyle = .bar
        $0.progressTintColor = .mainElevated
        $0.trackTintColor = .white
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }

    private let gaugeStartLabel = UILabel().then {
        $0.text = "0분"
        $0.textColor = .white
        $0.font = .indicatorMedium
    }

    private let gaugeEndLabel = UILabel().then {
        $0.text = "10분"
        $0.textColor = .white
        $0.font = .indicatorMedium
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
    }

    private let gaugeInfoButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "info_circle"), for: .normal)
        $0.tintColor = .white
    }

    private let stopButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "unfill_x_gray"), for: .normal)
        $0.tintColor = .whiteElevated5
    }

    private lazy var input = TimerActivateViewModel.Input(
        startSignal: self.startTimer.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    let viewModel = TimerActivateViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        bind()
        startTimer.accept(true)
    }

    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }

}

extension TimerActivateViewController {
    private func bind() {
        output.timerText.asObservable()
            .bind(to: timerTotalTimeLabel.rx.text)
            .disposed(by: disposedBag)

        output.progressBarValue.asObservable()
            .bind { [unowned self] progressValue in
                gaugeProgressBarView.setProgress(progressValue, animated: true)
            }
            .disposed(by: disposedBag)

        gaugeInfoButton.rx.tap
            .bind {
                let alertVC = SimpleAlertViewController(
                    titleText: "집중 게이지란?",
                    messageText: "집중 게이지는 10분을 넘기면 불타게 돼요. 처음부터 목표를 크게 잡기보다 단 10분만이라도 열심히 하다보면 더 오래 집중할 수 있을 거에요!",
                    alertStyle: .dark
                )
//                let deleteAlertVC = DeleteSubjectAlertViewController(
//                    subjectName: "수학",
//                    action: {
//                        print("삭제")
//                    },
//                    alertStyle: .dark
//                )
//                let addAlertVC = AddSubjectAlertViewController(
//                    action: {
//                        print("확인")
//                    },
//                    alertStyle: .dark
//                )
//                let stopAlertVC = StopTimerAlertViewController(
//                    action: {
//                        print("멈춤")
//                    },
//                    alertStyle: .dark
//                )
//                let quitAlert = QuitAlertViewController(
//                    action: { print("탈퇴") },
//                    alertStyle: .light
//                )
                self.present(alertVC, animated: false)
            }
            .disposed(by: disposedBag)
    }

    private func addSubViews() {
        [
            timerBackgroundView,
            gaugeBackgroundView,
            stopButton
        ].forEach({ view.addSubview($0) })

        [
            timerTotalTimeLabel,
            timerSubjectTimeLabel,
            timerTodayTimeLabel,
            todayTimerTitleLabel,
            subjectTimerTitleLabel
        ].forEach({ timerBackgroundView.addSubview($0) })

        [
            gaugeTitleLabel,
            gaugeProgressBarView,
            gaugeStartLabel,
            gaugeEndLabel,
            gaugeInfoButton
        ].forEach({ gaugeBackgroundView.addSubview($0) })
    }

    private func makeConstraints() {
        timerBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().inset((view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0) + 42)
            $0.height.equalTo(184)
            $0.left.right.equalToSuperview().inset(26)
        }
        gaugeBackgroundView.snp.makeConstraints {
            $0.height.equalTo(117)
            $0.left.right.equalToSuperview().inset(26)
            $0.top.equalTo(timerBackgroundView.snp.bottom).offset(20)
        }
        timerTotalTimeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(29)
            $0.topMargin.equalTo(33)
        }
        timerSubjectTimeLabel.snp.makeConstraints {
            $0.left.equalTo(timerTotalTimeLabel).inset(10)
            $0.top.equalTo(timerTotalTimeLabel.snp.bottom).offset(27)
        }
        timerTodayTimeLabel.snp.makeConstraints {
            $0.right.equalTo(timerTotalTimeLabel).inset(10)
            $0.top.equalTo(timerTotalTimeLabel.snp.bottom).offset(27)
        }
        todayTimerTitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(timerTodayTimeLabel)
            $0.bottom.equalTo(timerTodayTimeLabel.snp.top).offset(-1)
        }
        subjectTimerTitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(timerSubjectTimeLabel)
            $0.bottom.equalTo(timerSubjectTimeLabel.snp.top).offset(-1)
        }
        gaugeTitleLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(17)
            $0.topMargin.equalTo(16)
        }
        gaugeProgressBarView.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(25)
            $0.height.equalTo(8)
            $0.top.equalTo(gaugeTitleLabel.snp.bottom).offset(28)
        }
        gaugeStartLabel.snp.makeConstraints {
            $0.centerX.equalTo(gaugeProgressBarView.snp.left)
            $0.top.equalTo(gaugeProgressBarView.snp.bottom).offset(11)
        }
        gaugeEndLabel.snp.makeConstraints {
            $0.centerX.equalTo(gaugeProgressBarView.snp.right)
            $0.top.equalTo(gaugeProgressBarView.snp.bottom).offset(11)
        }
        gaugeInfoButton.snp.makeConstraints {
            $0.rightMargin.equalTo(-16)
            $0.topMargin.equalTo(18)
        }
        stopButton.snp.makeConstraints {
            $0.width.height.equalTo(22)
            $0.top.equalToSuperview().inset((view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0) + 4)
            $0.rightMargin.equalTo(-22)
        }
    }
}
// swiftlint:enable function_body_length line_length
