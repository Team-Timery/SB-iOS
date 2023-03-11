//
//  AnalyzeViewController.swift
//  Ambition
//
//  Created by 조병진 on 2023/02/28.
//

import UIKit
import SnapKit
import Then
import MultiProgressView
import RxSwift
import RxCocoa

class AnalyzeViewController: UIViewController {
    
    var chart1Data: [Double]!
    var chart2Data: [Double]!
    var dataPoint: [String]!
    
    //더미 데이터
    var subjects: [subjectTimeModel] = [
        subjectTimeModel(emoji: "🔥", name: "수학", percent: "90.4%", time: "201분"),
        subjectTimeModel(emoji: "🗝️", name: "영어", percent: "30.5%", time: "54분"),
        subjectTimeModel(emoji: "💠", name: "과학", percent: "10.3%", time: "3분"),
        subjectTimeModel(emoji: "🔄", name: "더보기", percent: "0.3%", time: "1,034분")
    ]
    
    let disposebag = DisposeBag()
    
    private let mainTitleLable = UILabel().then {
        $0.text = "분석"
        $0.textColor = .black
        $0.font = .title2Bold
    }
    
    private let scrollerView = UIScrollView().then {
        $0.backgroundColor = .clear
    }
    
    private let contentView = UIView().then {
        $0.backgroundColor = .whiteElevated2
    }
    //시간 분석 뷰
    private let timeContentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let dateControllerLeftButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "dateController_left_arrow"), for: .normal)
    }
    
    private let dateControllerRightButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "dateController_right_arrow"), for: .normal)
    }
    
    private let dateControllerLabel = UILabel().then {
        $0.text = "1월 집중시간"
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
        $0.trackBackgroundColor = .whiteElevated2
    }
    
    private let subjectsTimeStackView = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .clear
        $0.alignment = .fill
    }
    
    //집중력 분석 뷰
    private let concentrationContentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let concentrationLabel = UILabel().then {
        $0.text = "집중력"
        $0.textColor = .black
        $0.font = .title3Bold
    }
    
    private let concentrationHelpMessageButton = UIButton(type: .system).then {
        $0.tintColor = .whiteElevated3
        $0.setImage(UIImage(named: "circle_question_mark"), for: .normal)
    }
    
    private let concentratTimeMarkLabel = UILabel().then {
        $0.text = "• 집중시간"
        $0.textColor = .whiteElevated4
        $0.font = .main1Medium
    }
    
    private let concentratTimeDisplayLabel = UILabel().then {
        $0.textColor = .whiteElevated4
        $0.font = .main1Medium
        $0.textAlignment = .right
    }
    
    private let breakTimeMarkLabel = UILabel().then {
        $0.text = "• 쉬는시간"
        $0.textColor = .whiteElevated4
        $0.font = .main1Medium
    }
    
    private let breakTimeDisplayLabel = UILabel().then {
        $0.textColor = .whiteElevated4
        $0.font = .main1Medium
        $0.textAlignment = .right
    }
    
    private let attendanceTimeMarkLabel = UILabel().then {
        $0.text = "• 출석률"
        $0.textColor = .whiteElevated4
        $0.font = .main1Medium
    }
    
    private let attendanceTimeDisplayLabel = UILabel().then {
        $0.textColor = .whiteElevated4
        $0.font = .main1Medium
        $0.textAlignment = .right
    }

    //성장 그래프 뷰
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        timeProgressBar.delegate = self
        timeProgressBar.dataSource = self
        
        //더미 데이터
        graphTitleLabel.text = "이번 달에는 17% 성장했어요"
        graphSubtitleLabel.text = "지난달 이맘때보다 321분 더 집중했어요"
        concentratTimeDisplayLabel.text = "보통"
        breakTimeDisplayLabel.text = "부족함"
        attendanceTimeDisplayLabel.text = "매우높음"
        graphStartMonthLabel.text = "1월"
        graphEndMonthLabel.text = "2월"
        timeProgressBar.setProgress(section: 0, to: 0.91)
        timeProgressBar.setProgress(section: 1, to: 0.06)
        timeProgressBar.setProgress(section: 2, to: 0.015)
        timeProgressBar.setProgress(section: 3, to: 0.015)
        subjects.forEach({
            let view = SubjectStackViewCell(
                emoji: $0.emoji,
                subjectName: $0.name,
                percent: $0.percent,
                time: $0.time
            )
            subjectsTimeStackView.addArrangedSubview(view)
        })
        graphImageView.image = UIImage(named: "increase_graph")
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
        
        if(section == 0) {
            addProgressBorder(view: progressView, color: .white, width: 2)
            progressView.backgroundColor = .mainElevated
        } else if (section == 1) {
            addProgressBorder(view: progressView, color: .white, width: 2)
            progressView.backgroundColor = .main
        } else if (section == 2) {
            addProgressBorder(view: progressView, color: .white, width: 2)
            progressView.backgroundColor = .red
        } else {
            progressView.backgroundColor = .whiteElevated3
        }
        return progressView
    }
}

extension AnalyzeViewController {
    private func addProgressBorder(view: ProgressViewSection, color: UIColor, width: Float) {
        let border = UIView().then {
            $0.backgroundColor = color
        }
        view.addSubview(border)
        border.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalTo(width)
            $0.right.equalToSuperview()
        }
    }
    private func addSubViews() {
        [
            mainTitleLable,
            scrollerView,
            graphContentView
        ].forEach({ view.addSubview($0) })
        
        scrollerView.addSubview(contentView)
        
        [
            timeContentView,
            concentrationContentView,
            graphContentView
        ].forEach({ contentView.addSubview($0) })
        
        [
            dateControllerLeftButton,
            dateControllerRightButton,
            dateControllerLabel,
            displayTimeLabel,
            timeProgressBar,
            subjectsTimeStackView
        ].forEach({ timeContentView.addSubview($0) })
        
        [
            concentrationLabel,
            concentrationHelpMessageButton,
            concentratTimeMarkLabel,
            concentratTimeDisplayLabel,
            breakTimeMarkLabel,
            breakTimeDisplayLabel,
            attendanceTimeMarkLabel,
            attendanceTimeDisplayLabel
        ].forEach({ concentrationContentView.addSubview($0) })
        
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
        //집중시간
        timeContentView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(subjectsTimeStackView).offset(14)
        }
        dateControllerLeftButton.snp.makeConstraints{
            $0.topMargin.equalTo(20)
            $0.leftMargin.equalTo(26)
            $0.width.equalTo(8)
            $0.height.equalTo(17)
        }
        dateControllerLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateControllerLeftButton)
            $0.left.equalTo(dateControllerLeftButton.snp.right).offset(14)
        }
        dateControllerRightButton.snp.makeConstraints{
            $0.left.equalTo(dateControllerLabel.snp.right).offset(14)
            $0.centerY.equalTo(dateControllerLeftButton)
            $0.width.equalTo(8)
            $0.height.equalTo(17)
        }
        displayTimeLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(34)
            $0.top.equalTo(dateControllerLabel.snp.bottom).offset(12)
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
        
        //집중력
        concentrationContentView.snp.makeConstraints {
            $0.top.equalTo(timeContentView.snp.bottom).offset(12)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(attendanceTimeDisplayLabel.snp.bottom).offset(32)
        }
        concentrationLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(23)
            $0.topMargin.equalTo(33)
        }
        concentrationHelpMessageButton.snp.makeConstraints {
            $0.height.width.equalTo(22)
            $0.centerY.equalTo(concentrationLabel)
            $0.left.equalTo(concentrationLabel.snp.right).offset(8)
        }
        concentratTimeMarkLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(23)
            $0.top.equalTo(concentrationLabel.snp.bottom).offset(20)
        }
        concentratTimeDisplayLabel.snp.makeConstraints {
            $0.rightMargin.equalTo(-23)
            $0.top.equalTo(concentratTimeMarkLabel)
        }
        breakTimeMarkLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(23)
            $0.top.equalTo(concentratTimeMarkLabel.snp.bottom).offset(20)
        }
        breakTimeDisplayLabel.snp.makeConstraints {
            $0.rightMargin.equalTo(-23)
            $0.top.equalTo(breakTimeMarkLabel)
        }
        attendanceTimeMarkLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(23)
            $0.top.equalTo(breakTimeMarkLabel.snp.bottom).offset(20)
        }
        attendanceTimeDisplayLabel.snp.makeConstraints {
            $0.rightMargin.equalTo(-23)
            $0.top.equalTo(attendanceTimeMarkLabel)
        }
        //그래프
        graphContentView.snp.makeConstraints {
            $0.top.equalTo(concentrationContentView.snp.bottom).offset(12)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(500)
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
}
