import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import FSCalendar

// swiftlint:disable function_body_length
class CalendarViewController: UIViewController {
    private let dispoeBag = DisposeBag()

    private let selectCalendarRelay = PublishRelay<String>()
    private let getCalendarRecordRelay = BehaviorRelay<String>(value: Date().toString(to: "yyyy-MM"))
    private var eventDays: [String] = [] {
        didSet { calendarView.reloadData() }
    }

    private let topView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight)).then {
        $0.layer.opacity = 0
    }
    private let topShadowView = UIView().then {
        $0.backgroundColor = .whiteElevated3
        $0.layer.opacity = 0
    }

    private let calendarScrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }

    private let contentView = UIView().then {
        $0.backgroundColor = .white
    }

    private let monthTitleLabel = UILabel().then {
        $0.text = Date().toString(to: "M월")
        $0.font = .title2Bold
        $0.textColor = .black
    }

    private let calendarLeftButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "dateController_left_arrow"), for: .normal)
        $0.tintColor = .whiteElevated4
    }

    private let calendarRightButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "dateController_right_arrow"), for: .normal)
        $0.tintColor = .whiteElevated4
    }

    private let calendarView = FSCalendar().then {
        $0.locale = Locale(identifier: "ko_KR")
        $0.scope = .month
    }

    private let calendarStudyTimeMarkLabel = UILabel().then {
        $0.text = "전체 내역"
        $0.font = .title2Bold
        $0.textColor = .black
    }

    private let studyTimeView = CalendarTimeCellView(title: "공부시간")
    private let maxStudyTimeView = CalendarTimeCellView(title: "최대 집중시간")

    private let footerView = UIView().then {
        $0.backgroundColor = .whiteElevated2
    }

    private let timeLineContentView = UIView().then {
        $0.backgroundColor = .white
    }
    private let timeLineTitleMarkLabel = UILabel().then {
        $0.text = "타임라인"
        $0.font = .title3Bold
        $0.textColor = .black
    }
    private lazy var timeLineStackView = UIStackView().then {
        $0.alignment = .trailing
        $0.axis = .vertical
        $0.spacing = 15
    }

    private let viewModel = CalendarViewModel()
    lazy var input = CalendarViewModel.Input(
        selectDate: selectCalendarRelay.asSignal(),
        getMonthOfRecordDay: getCalendarRecordRelay.asDriver()
    )
    lazy var output = viewModel.transform(input: input)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarScrollView.delegate = self
        settingCalendar()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        bind()
    }

    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectCalendarRelay.accept(date.toString(to: "yyyy-MM-dd"))
    }
    // 최대 날짜
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    // 캘린더 이벤트
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if eventDays.contains(date.toString(to: "d")) {
            return 1
        } else {
            return 0
        }
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        monthTitleLabel.text = calendar.currentPage.toString(to: "M월")
        getCalendarRecordRelay.accept(calendar.currentPage.toString(to: "yyyy-MM"))
    }
}

extension CalendarViewController {
    private func bind() {
        output.timeLineDate.asObservable()
            .subscribe(onNext: { data in
                self.timeLineStackView.removeAll()
                data.recordResponses.forEach({
                    if $0.isRecord {
                        let stackItem = SubjectTimeLineCellView(
                            emoji: $0.subject.emoji,
                            subjectName: $0.subject.title,
                            startTime: $0.startedTime,
                            studyTime: "\($0.total / 60 % 60)분 \($0.total % 60)초",
                            memo: $0.memo ?? "기록한 내용이 없습니다",
                            cellWidth: self.view.frame.width / 1.3
                        )
                        self.timeLineStackView.addArrangedSubview(stackItem)
                    } else {
                        let stackItem = BreakTimeLineCellView(
                            content: "\($0.startedTime) ~ \($0.finishedTime) \($0.total / 60 % 60)분 \($0.total % 60)초"
                        )
                        stackItem.snp.makeConstraints {
                            $0.height.equalTo(34)
                            $0.width.equalTo(self.view.frame.width / 1.3)
                        }
                        self.timeLineStackView.addArrangedSubview(stackItem)
                    }
                })
            })
            .disposed(by: dispoeBag)

        output.monthRecordDay.asObservable()
            .subscribe(onNext: { data in
                self.eventDays = data.recordedDays.map { "\($0)" }
            })
            .disposed(by: dispoeBag)

        output.calendarTimeData.asObservable()
            .subscribe(onNext: { data in
                self.studyTimeView.content = data.totalFocusedTime.toTimerString()
                self.maxStudyTimeView.content = data.maxFocusedTime.toTimerString()
            })
            .disposed(by: dispoeBag)
    }

    private func addSubViews() {
        [
            calendarScrollView,
            topView,
            topShadowView
        ].forEach({ view.addSubview($0) })
        calendarScrollView.addSubview(contentView)
        [
            calendarView,
            footerView,
            timeLineContentView,
            monthTitleLabel,
            calendarLeftButton,
            calendarRightButton
        ].forEach({ contentView.addSubview($0) })
        [
            calendarStudyTimeMarkLabel,
            studyTimeView,
            maxStudyTimeView
        ].forEach({ calendarView.addSubview($0) })
        [
            timeLineStackView,
            timeLineTitleMarkLabel
        ].forEach({ timeLineContentView.addSubview($0) })
    }

    private func makeConstraints() {
        topView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(view.safeAreaInsets.top)
            $0.top.equalToSuperview()
        }
        topShadowView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
        // 스크롤뷰
        calendarScrollView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(view.safeAreaInsets.bottom)
        }

        contentView.snp.makeConstraints {
            $0.width.top.bottom.equalToSuperview()
        }
        // 캘린더
        monthTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.topMargin.equalToSuperview()
        }
        calendarLeftButton.snp.makeConstraints {
            $0.width.equalTo(8)
            $0.height.equalTo(17)
            $0.right.equalTo(monthTitleLabel.snp.left).offset(-16)
            $0.centerY.equalTo(monthTitleLabel)
        }
        calendarRightButton.snp.makeConstraints {
            $0.width.equalTo(8)
            $0.height.equalTo(17)
            $0.left.equalTo(monthTitleLabel.snp.right).offset(16)
            $0.centerY.equalTo(monthTitleLabel)
        }
        calendarView.snp.makeConstraints {
            $0.height.equalTo(650)
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(70)
        }
        calendarStudyTimeMarkLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(15)
            $0.topMargin.equalToSuperview()
        }
        studyTimeView.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.width.equalTo(152)
            $0.top.equalTo(calendarStudyTimeMarkLabel.snp.bottom).offset(35)
            $0.right.equalTo(calendarView.snp.centerX).offset(-4)
        }
        maxStudyTimeView.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.width.equalTo(152)
            $0.top.equalTo(calendarStudyTimeMarkLabel.snp.bottom).offset(35)
            $0.left.equalTo(studyTimeView.snp.right).offset(8)
        }
        // 타임라인
        timeLineContentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalTo(footerView.snp.bottom)
            $0.bottom.greaterThanOrEqualTo(timeLineStackView.snp.bottom).offset(40)
            $0.bottom.equalToSuperview()
        }
        timeLineTitleMarkLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.topMargin.equalTo(40)
        }
        timeLineStackView.snp.makeConstraints {
            $0.top.equalTo(timeLineTitleMarkLabel.snp.bottom).offset(28)
            $0.left.right.equalToSuperview().inset(15)
        }
        // 칸 나누는 회색 선
        footerView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(12)
            $0.top.equalTo(calendarView.snp.bottom)
        }
    }

    private func settingCalendar() {
        calendarView.appearance.titleDefaultColor = .grayDarken1
        calendarView.appearance.titleFont = .title3Medium
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        calendarView.placeholderType = .none
        calendarView.backgroundColor = .white

        // 오늘 날짜 설정
        calendarView.appearance.todayColor = .whiteElevated2
        calendarView.appearance.titleTodayColor = .grayDarken1

        // 선택 날짜 설정
        calendarView.appearance.selectionColor = .mainElevated

        // 토~일 날짜 설정
        calendarView.appearance.weekdayFont = .main2Medium
        calendarView.appearance.weekdayTextColor = .whiteElevated4

        // 헤더 설정
        calendarView.calendarHeaderView.isHidden = true
        calendarView.headerHeight = 160

        // 이벤트 설정
        calendarView.appearance.eventDefaultColor = .whiteElevated4
        calendarView.appearance.eventSelectionColor = .whiteElevated4
    }
}

extension CalendarViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        [
            topView,
            topShadowView
        ].forEach({
            $0.layer.opacity = (Float(scrollView.contentOffset.y + view.safeAreaInsets.top)) / 20
        })
    }
}
// swiftlint:enable function_body_length
