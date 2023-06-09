import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

// swiftlint:disable function_body_length line_length
class TimerActivateViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let startTimer = PublishRelay<(Int, Int)>()
    private let stopTimer = PublishRelay<Void>()
    private var stratTime: Date = Date()
    public var timerSubjectEntity: MySubjectEntity = MySubjectEntity(id: 0, title: "", emoji: "", userID: 0, todayRecord: 0)
    public var todayStudyTime: Int = 0

    private let timerBackgroundView = UIView().then {
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
        $0.textColor = .white
        $0.font = .main2Bold
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
    }

    private let stopButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "unfill_x_gray"), for: .normal)
        $0.tintColor = .whiteElevated5
    }

    private lazy var input = TimerActivateViewModel.Input(
        startSignal: startTimer.asSignal(),
        stopSignal: stopTimer.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    let viewModel = TimerActivateViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        self.stratTime = Date()
        self.subjectTimerTitleLabel.text = timerSubjectEntity.title
        bind()
        startTimer.accept((timerSubjectEntity.todayRecord, todayStudyTime))
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
            .disposed(by: disposeBag)

        output.subjectText.asObservable()
            .bind(to: timerSubjectTimeLabel.rx.text)
            .disposed(by: disposeBag)

        output.todayText.asObservable()
            .bind(to: timerTodayTimeLabel.rx.text)
            .disposed(by: disposeBag)

        stopButton.rx.tap
            .bind { [unowned self] in
                let stopAlert = StopTimerAlertViewController(
                    alertStyle: .dark,
                    startTime: stratTime,
                    subjectID: timerSubjectEntity.id,
                    completion: {
                        self.stopTimer.accept(())
                        self.dismiss(animated: true)
                    }
                )
                present(stopAlert, animated: false)
            }
            .disposed(by: disposeBag)
    }

    private func addSubViews() {
        [
            timerBackgroundView,
            stopButton
        ].forEach({ view.addSubview($0) })

        [
            timerTotalTimeLabel,
            timerSubjectTimeLabel,
            timerTodayTimeLabel,
            todayTimerTitleLabel,
            subjectTimerTitleLabel
        ].forEach({ timerBackgroundView.addSubview($0) })
    }

    private func makeConstraints() {
        timerBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().inset((view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0) + 42)
            $0.height.equalTo(184)
            $0.left.right.equalToSuperview().inset(26)
        }
        timerTotalTimeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
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
        stopButton.snp.makeConstraints {
            $0.width.height.equalTo(22)
            $0.top.equalToSuperview().inset((view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0) + 4)
            $0.rightMargin.equalTo(-22)
        }
    }
}
// swiftlint:enable function_body_length line_length
