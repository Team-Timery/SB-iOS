//
//  TimerViewController.swift
//  Ambition
//
//  Created by 조병진 on 2023/02/20.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class TimerViewController: UIViewController {
    
    private let timerTitleLabel = UILabel().then {
        $0.text = "타이머"
        $0.textColor = .black
        $0.font = .title2Bold
    }
    
    private let timerSubtitleLabel = UILabel().then {
        $0.text = "시간측정"
        $0.textColor = .whiteElevated4
        $0.font = .title3Bold
    }
    
    private let dateLabel = RoundBackgroundLabelView(title: "오늘").then {
        $0.layer.cornerRadius = 18
    }
    
    private let timerBackground = UIView().then {
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.whiteElevated4?.cgColor
        $0.backgroundColor = .white
    }
    
    private let timerTimeLabel = UILabel().then {
        $0.text = "00:00:00"
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-Medium", size: 64)
    }
    
    private let subjectTableView = UITableView().then {
        $0.backgroundColor = .clear
    }
    
    private let addSubjetcButton = UIButton(type: .system).then {
        $0.layer.shadowColor = UIColor.gray.cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.setImage(UIImage(named: "orange_plus"), for: .normal)
        $0.layer.cornerRadius = 40
        $0.backgroundColor = .white
        $0.tintColor = .mainElevated
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subjectTableView.delegate = self
        subjectTableView.dataSource = self
        subjectTableView.separatorStyle = .none
        let insetView = UIView()
        insetView.frame.size.height = 15
        subjectTableView.tableHeaderView = insetView
        subjectTableView.tableFooterView = insetView
        subjectTableView.register(SubjectsTableViewCell.self, forCellReuseIdentifier: "subjectCell")
        view.backgroundColor = .whiteElevated1
    }
    
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension TimerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = subjectTableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath) as? SubjectsTableViewCell else { return UITableViewCell() }
        cell.subjectLabel.text = "수학 \(indexPath.row)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}

extension TimerViewController {
    private func addSubViews() {
        [
            timerBackground,
            subjectTableView,
            addSubjetcButton
        ].forEach({ view.addSubview($0) })
        
        [
            timerTitleLabel,
            timerTimeLabel,
            timerSubtitleLabel,
            dateLabel
        ].forEach({ timerBackground.addSubview($0) })
    }
    
    private func makeConstraints() {
        timerBackground.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(view.frame.height / 2.9)
        }
        
        timerTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset((view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0) + 12)
        }
        
        timerSubtitleLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(20)
            $0.top.equalTo(timerTitleLabel.snp.bottom).offset(27)
        }
        
        dateLabel.snp.makeConstraints {
            $0.height.equalTo(36)
            $0.width.equalTo(60)
            $0.left.equalTo(timerSubtitleLabel.snp.right).offset(10)
            $0.centerY.equalTo(timerSubtitleLabel)
        }
        
        timerTimeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(timerSubtitleLabel.snp.bottom).offset((view.frame.height / 2.8) / 10.3)
        }
        
        subjectTableView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(timerBackground.snp.bottom)
            $0.bottom.equalToSuperview()
        }
        
        addSubjetcButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(22)
            $0.bottom.equalToSuperview().inset(view.safeAreaInsets.bottom + 22)
            $0.width.height.equalTo(80)
        }
    }
}
