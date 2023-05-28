import UIKit
import SnapKit
import Then
import MultiProgressView
import RxSwift
import RxCocoa

// swiftlint:disable function_body_length line_length
class AnalyzeViewController: UIViewController {

    let disposebag = DisposeBag()
    private let getMonthOfAnalysisRelay = PublishRelay<String>()
    private let getAnalysGraph = PublishRelay<Void>()

    private let mainTitleLable = UILabel().then {
        $0.text = "분석"
        $0.textColor = .black
        $0.font = .title2Bold
    }

    private let scrollerView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }

    private let contentView = UIView().then {
        $0.backgroundColor = .whiteElevated2
    }
    // 시간 분석 뷰
    private let timeContentView = UIView().then {
        $0.backgroundColor = .white
    }

    private let dateControllerLeftButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "dateController_left_arrow"), for: .normal)
        $0.tintColor = .whiteElevated4
    }

    private let dateControllerRightButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "dateController_right_arrow"), for: .normal)
        $0.tintColor = .whiteElevated4
    }

    private let dateControllerLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .title2Bold
    }

    private let displayTimeLabel = UILabel().then {
        $0.text = "0분"
        $0.textColor = .black
        $0.font = .typograpy
    }

    private let timeProgressBar = MultiProgressView().then {
        $0.cornerRadius = 10
        $0.lineCap = .round
        $0.trackBackgroundColor = .whiteElevated3
    }

    private let subjectsTimeStackView = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .clear
        $0.alignment = .fill
    }
    private let notingLable = UILabel().then {
        $0.text = "아직 집중한 기록이 없어요"
        $0.textColor = .black
        $0.font = .title3Bold
        $0.isHidden = true
    }
    // 집중력 분석 뷰
//    private let concentrationContentView = UIView().then {
//        $0.backgroundColor = .white
//    }
//
//    private let concentrationLabel = UILabel().then {
//        $0.text = "집중력"
//        $0.textColor = .black
//        $0.font = .title3Bold
//    }
//
//    private let concentrationHelpMessageButton = UIButton(type: .system).then {
//        $0.tintColor = .whiteElevated3
//        $0.setImage(UIImage(named: "circle_question_mark"), for: .normal)
//    }
//
//    private let concentratTimeMarkLabel = UILabel().then {
//        $0.text = "• 집중시간"
//        $0.textColor = .whiteElevated4
//        $0.font = .main1Medium
//    }
//
//    private let concentratTimeDisplayLabel = UILabel().then {
//        $0.textColor = .whiteElevated4
//        $0.font = .main1Medium
//        $0.textAlignment = .right
//    }
//
//    private let breakTimeMarkLabel = UILabel().then {
//        $0.text = "• 쉬는시간"
//        $0.textColor = .whiteElevated4
//        $0.font = .main1Medium
//    }
//
//    private let breakTimeDisplayLabel = UILabel().then {
//        $0.textColor = .whiteElevated4
//        $0.font = .main1Medium
//        $0.textAlignment = .right
//    }
//
//    private let attendanceTimeMarkLabel = UILabel().then {
//        $0.text = "• 출석률"
//        $0.textColor = .whiteElevated4
//        $0.font = .main1Medium
//    }
//
//    private let attendanceTimeDisplayLabel = UILabel().then {
//        $0.textColor = .whiteElevated4
//        $0.font = .main1Medium
//        $0.textAlignment = .right
//    }
    // 성장 그래프 뷰
    private let graphContentView = UIView().then {
        $0.backgroundColor = .white
    }

    private let graphTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .title2Bold
    }

    private let graphSubtitleLabel = UILabel().then {
        $0.textColor = .whiteElevated4
        $0.font = .main1Medium
    }

    private let graphImageView = UIImageView()

    private let graphStartMonthLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .main1Medium
    }

    private let graphEndMonthLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .main1Medium
    }

    private let viewModel = AnalyzeViewModel()
    lazy var input = AnalyzeViewModel.Input(
        getMonthOfAnalysis: getMonthOfAnalysisRelay.asSignal(),
        getAnalysGraph: getAnalysGraph.asSignal(),
        getNextMonth: dateControllerRightButton.rx.tap,
        getLastMonth: dateControllerLeftButton.rx.tap
    )
    lazy var output = viewModel.transform(input: input)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        timeProgressBar.delegate = self
        timeProgressBar.dataSource = self
        [
            dateControllerLeftButton,
            dateControllerRightButton,
            dateControllerLabel,
            displayTimeLabel,
            timeProgressBar,
            subjectsTimeStackView,
            notingLable,
            graphTitleLabel,
            graphSubtitleLabel,
            graphImageView,
            graphStartMonthLabel,
            graphEndMonthLabel
        ].forEach({ $0.layer.opacity = 0 })
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.monthCount = 0
        getMonthOfAnalysisRelay.accept(Date().toString(to: "yyyy-MM"))
        getAnalysGraph.accept(())
    }

    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension AnalyzeViewController: MultiProgressViewDelegate, MultiProgressViewDataSource {
    func numberOfSections(in progressView: MultiProgressView) -> Int {
        return 4
    }

    func progressView(_ progressView: MultiProgressView, viewForSection section: Int) -> ProgressViewSection {
        let progressView = ProgressViewSection()

        switch section {
        case 0:
            progressView.backgroundColor = .mainElevated
            progressView.addProgressBorder(color: .white, width: 2)
        case 1:
            progressView.backgroundColor = .progressBlue
            progressView.addProgressBorder(color: .white, width: 2)
        case 2:
            progressView.backgroundColor = .progressRed
            progressView.addProgressBorder(color: .white, width: 2)
        default: progressView.backgroundColor = .whiteElevated3
        }
        return progressView
    }
}

extension AnalyzeViewController {
    private func showMonthOfAnalysis() {
        UIView.animate(withDuration: 0.7, animations: { [weak self] in
            guard let self = self else { return }
            [
                self.dateControllerLeftButton,
                self.dateControllerRightButton,
                self.dateControllerLabel,
                self.displayTimeLabel,
                self.timeProgressBar,
                self.subjectsTimeStackView,
                self.notingLable
            ].forEach({ $0.layer.opacity = 1})
        })
    }
    private func showAnalysisGraph() {
        UIView.animate(withDuration: 0.7, animations: { [weak self] in
            guard let self = self else { return }
            [
                self.graphTitleLabel,
                self.graphSubtitleLabel,
                self.graphImageView,
                self.graphStartMonthLabel,
                self.graphEndMonthLabel
            ].forEach({ $0.layer.opacity = 1})
        })
    }
    private func bind() {
        output.monthOfAnalysis.asObservable()
            .subscribe(onNext: { [unowned self] data in
                let isToday = data.yearMonth.contains(Date().toString(to: "yyyy-MM"))
                dateControllerLabel.text = data.yearMonth.toDate(to: "yyyy-MM").toString(to: "yy년 M월 집중시간")
                displayTimeLabel.text = "\(data.totalTime.decimalFormat())분"
                dateControllerRightButton.tintColor = isToday ? .whiteElevated3 : .whiteElevated4
                dateControllerRightButton.isEnabled = !isToday
                subjectsTimeStackView.removeAll()
                notingLable.isHidden = !data.focusResponses.isEmpty
                timeProgressBar.isHidden = data.focusResponses.isEmpty
                data.focusResponses.enumerated().forEach { sectionNum, value in
                    self.timeProgressBar.setProgressWithAnimate(section: sectionNum, to: Float(value.focusedRatio) / 100, withDuration: 0.5)
                    let subjectCell = SubjectAnalyzeCell(
                        emoji: value.emoji,
                        subjectName: value.title,
                        percent: "\(value.focusedRatio)%",
                        time: "\(value.sum.decimalFormat())분"
                    )
                    subjectsTimeStackView.addArrangedSubview(subjectCell)
                }
                showMonthOfAnalysis()
            })
            .disposed(by: disposebag)

        output.analysisGraph.asObservable()
            .subscribe(onNext: { [unowned self] data in
                graphTitleLabel.text = "이번 달에는 \(data.growthPercent)% 성장했어요"
                graphSubtitleLabel.text = "지난달 이맘때보다 \(data.increasedTime)분 더 집중했어요"
                graphStartMonthLabel.text = data.lastMonth.toMonthString
                graphEndMonthLabel.text = data.thisMonth.toMonthString
                graphImageView.image = UIImage(named: "\(data.increasedTime <= 0 ? "no_" : "")increase_graph")
                showAnalysisGraph()
            })
            .disposed(by: disposebag)

        output.resultMonth.asObservable()
            .subscribe(onNext: { data in
                self.getMonthOfAnalysisRelay.accept(data)
            })
            .disposed(by: disposebag)
    }
    private func addSubViews() {
        [
            mainTitleLable,
            scrollerView
        ].forEach({ view.addSubview($0) })

        scrollerView.addSubview(contentView)

        [
            timeContentView,
//            concentrationContentView,
            graphContentView
        ].forEach({ contentView.addSubview($0) })

        [
            dateControllerLeftButton,
            dateControllerRightButton,
            dateControllerLabel,
            displayTimeLabel,
            timeProgressBar,
            subjectsTimeStackView,
            notingLable
        ].forEach({ timeContentView.addSubview($0) })

//        [
//            concentrationLabel,
//            concentrationHelpMessageButton,
//            concentratTimeMarkLabel,
//            concentratTimeDisplayLabel,
//            breakTimeMarkLabel,
//            breakTimeDisplayLabel,
//            attendanceTimeMarkLabel,
//            attendanceTimeDisplayLabel
//        ].forEach({ concentrationContentView.addSubview($0) })

        [
            graphTitleLabel,
            graphSubtitleLabel,
            graphImageView,
            graphStartMonthLabel,
            graphEndMonthLabel
        ].forEach({ graphContentView.addSubview($0) })
    }

    private func makeConstraints() {
        mainTitleLable.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset((view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0) + 7)
        }

        scrollerView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().inset(view.safeAreaInsets.top + 13)
            $0.bottom.equalToSuperview().inset(view.safeAreaInsets.bottom)
        }

        contentView.snp.makeConstraints {
            $0.width.top.bottom.equalToSuperview()
        }
        // 집중시간
        timeContentView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(subjectsTimeStackView).offset(14)
        }
        dateControllerLeftButton.snp.makeConstraints {
            $0.topMargin.equalTo(20)
            $0.leftMargin.equalTo(5)
            $0.width.equalTo(50)
            $0.height.equalTo(30)
        }
        dateControllerLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateControllerLeftButton)
            $0.left.equalTo(dateControllerLeftButton.snp.right).offset(-8)
        }
        dateControllerRightButton.snp.makeConstraints {
            $0.left.equalTo(dateControllerLabel.snp.right).offset(-8)
            $0.centerY.equalTo(dateControllerLeftButton)
            $0.width.equalTo(50)
            $0.height.equalTo(30)
        }
        displayTimeLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(34)
            $0.top.equalTo(dateControllerLabel.snp.bottom).offset(12)
        }
        notingLable.snp.makeConstraints {
            $0.leadingMargin.equalTo(30)
            $0.top.equalTo(displayTimeLabel.snp.bottom).offset(18)
        }
        timeProgressBar.snp.makeConstraints {
            $0.height.equalTo(28)
            $0.top.equalTo(displayTimeLabel.snp.bottom).offset(18)
            $0.left.right.equalToSuperview().inset(23)
        }
        subjectsTimeStackView.snp.makeConstraints {
            $0.top.equalTo(timeProgressBar.snp.bottom).offset(45)
            $0.width.equalToSuperview()
        }
        // 집중력
//        concentrationContentView.snp.makeConstraints {
//            $0.top.equalTo(timeContentView.snp.bottom).offset(12)
//            $0.left.right.equalToSuperview()
//            $0.bottom.equalTo(attendanceTimeDisplayLabel.snp.bottom).offset(32)
//        }
//        concentrationLabel.snp.makeConstraints {
//            $0.leftMargin.equalTo(23)
//            $0.topMargin.equalTo(33)
//        }
//        concentrationHelpMessageButton.snp.makeConstraints {
//            $0.height.width.equalTo(22)
//            $0.centerY.equalTo(concentrationLabel)
//            $0.left.equalTo(concentrationLabel.snp.right).offset(8)
//        }
//        concentratTimeMarkLabel.snp.makeConstraints {
//            $0.leftMargin.equalTo(23)
//            $0.top.equalTo(concentrationLabel.snp.bottom).offset(20)
//        }
//        concentratTimeDisplayLabel.snp.makeConstraints {
//            $0.rightMargin.equalTo(-23)
//            $0.top.equalTo(concentratTimeMarkLabel)
//        }
//        breakTimeMarkLabel.snp.makeConstraints {
//            $0.leftMargin.equalTo(23)
//            $0.top.equalTo(concentratTimeMarkLabel.snp.bottom).offset(20)
//        }
//        breakTimeDisplayLabel.snp.makeConstraints {
//            $0.rightMargin.equalTo(-23)
//            $0.top.equalTo(breakTimeMarkLabel)
//        }
//        attendanceTimeMarkLabel.snp.makeConstraints {
//            $0.leftMargin.equalTo(23)
//            $0.top.equalTo(breakTimeMarkLabel.snp.bottom).offset(20)
//        }
//        attendanceTimeDisplayLabel.snp.makeConstraints {
//            $0.rightMargin.equalTo(-23)
//            $0.top.equalTo(attendanceTimeMarkLabel)
//        }
        // 그래프
        graphContentView.snp.makeConstraints {
            $0.top.equalTo(timeContentView.snp.bottom).offset(12)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(graphImageView.snp.bottom).offset(70)
            $0.bottom.equalToSuperview()
        }
        graphTitleLabel.snp.makeConstraints {
            $0.leftMargin.topMargin.equalTo(32)
        }
        graphSubtitleLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(32)
            $0.top.equalTo(graphTitleLabel.snp.bottom).offset(7)
        }
        graphImageView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(58)
            $0.top.equalTo(graphSubtitleLabel.snp.bottom).offset(50)
            $0.height.equalTo(130)
        }
        graphStartMonthLabel.snp.makeConstraints {
            $0.centerX.equalTo(graphImageView.snp.left)
            $0.top.equalTo(graphImageView.snp.bottom).offset(7)
        }
        graphEndMonthLabel.snp.makeConstraints {
            $0.centerX.equalTo(graphImageView.snp.right)
            $0.top.equalTo(graphImageView.snp.bottom).offset(7)
        }
    }
    // swiftlint:enable function_body_length line_length
}
