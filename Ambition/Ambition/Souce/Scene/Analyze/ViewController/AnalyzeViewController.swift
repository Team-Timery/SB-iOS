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
import Charts
import RxSwift
import RxCocoa

class AnalyzeViewController: UIViewController {
    
    var chart1Data: [Double]!
    var chart2Data: [Double]!
    var dataPoint: [String]!
    
    var subjects: [subjectTimeModel] = [
        subjectTimeModel(emoji: "🔥", name: "수학", percent: "90.4%", time: "201분"),
        subjectTimeModel(emoji: "🗝️", name: "영어", percent: "30.5%", time: "54분"),
        subjectTimeModel(emoji: "💠", name: "과학", percent: "10.3%", time: "3분")
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
        $0.backgroundColor = .gray
    }
    
    private let concentrationLabel = UILabel().then {
        $0.text = "집중력"
        $0.textColor = .black
        $0.font = .title3Bold
    }

    private let chart = LineChartView().then {
        $0.noDataText = "데이터가 없습니다."
        $0.noDataFont = .title3Medium!
        $0.noDataTextColor = .whiteElevated3!
    }
    //성장 그래프 뷰
    private let graphContentView = UIView().then {
        $0.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        timeProgressBar.delegate = self
        timeProgressBar.dataSource = self
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
        
        chart1Data = [10.4, 3.2, 14.6]
        chart2Data = [3.3, 15.2, 12.4]
        dataPoint = ["1월", "2월"]
        
        setChart(lineChartView: chart, values: [entryData(values: chart1Data), entryData(values: chart2Data)], date: dataPoint)
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
    private func setChart(lineChartView: LineChartView, values: [[ChartDataEntry]], date: [String]) {
        var lineDatas: [LineChartDataSet] = []
        var colors: [NSUIColor] = [.blue, .orange]
        for i in 0..<date.count {
            let lineChartDataSet = LineChartDataSet(entries: values[i], label: date[i])
            lineChartDataSet.setColor(colors[i])
            lineChartDataSet.setCircleColor(colors[i])
            lineChartDataSet.drawCirclesEnabled = false
            lineChartDataSet.lineWidth = 4
            lineChartDataSet.fillColor 
            lineDatas.append(lineChartDataSet)
        }
        
        let lineChartData = LineChartData(dataSets: lineDatas)
        
        lineChartView.data = lineChartData
    }
    
    private func entryData(values: [Double]) -> [ChartDataEntry] {
        var lineDataEntryies: [ChartDataEntry] = []
        
        for i in 0..<values.count {
            let lineDataEntry = ChartDataEntry(x: Double(i), y: values[i])
            lineDataEntryies.append(lineDataEntry)
        }
        
        return lineDataEntryies
    }
    
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
            scrollerView
        ].forEach({ view.addSubview($0) })
        
        scrollerView.addSubview(contentView)
        
        [
            timeContentView,
            concentrationContentView
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
            chart
        ].forEach({ concentrationContentView.addSubview($0) })
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
        concentrationContentView.snp.makeConstraints {
            $0.top.equalTo(timeContentView.snp.bottom).offset(12)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(500)
            $0.bottom.equalToSuperview()
        }
        
        concentrationLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(23)
            $0.topMargin.equalTo(33)
        }
        chart.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(23)
            $0.height.equalTo(300)
            $0.top.equalTo(concentrationLabel.snp.bottom).offset(20)
        }
    }
}
