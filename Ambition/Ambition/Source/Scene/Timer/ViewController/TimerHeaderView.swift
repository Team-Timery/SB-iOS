//
//  TimerHeaderView.swift
//  Ambition
//
//  Created by 조병진 on 2023/02/25.
//

import UIKit
import SnapKit
import Then

class TimerHeaderView: UIView {
    private let timerSubtitleLabel = UILabel().then {
        $0.text = "시간측정"
        $0.textColor = .whiteElevated4
        $0.font = .title3Bold
    }
    
    private let dateLabel = RoundBackgroundLabelView(title: "오늘").then {
        $0.layer.cornerRadius = 18
    }
    
    private let timerTimeLabel = UILabel().then {
        $0.text = "00:00:00"
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-Medium", size: 64)
    }
    
    init(timerText: String? = "00:00:00") {
        super.init(frame: .zero)
        self.timerTimeLabel.text = timerText
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension TimerHeaderView {
    private func addSubViews() {
        [
            timerTimeLabel,
            timerSubtitleLabel,
            dateLabel
        ].forEach({ addSubview($0) })
    }
    
    private func makeConstraints() {
        
        timerSubtitleLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(20)
            $0.topMargin.equalTo(8)
        }
        
        dateLabel.snp.makeConstraints {
            $0.height.equalTo(36)
            $0.width.equalTo(60)
            $0.left.equalTo(timerSubtitleLabel.snp.right).offset(10)
            $0.centerY.equalTo(timerSubtitleLabel)
        }
        
        timerTimeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(timerSubtitleLabel.snp.bottom).offset(self.frame.height / 10.5)
        }
    }
}
