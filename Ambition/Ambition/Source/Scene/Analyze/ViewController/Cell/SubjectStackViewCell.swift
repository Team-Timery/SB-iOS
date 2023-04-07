//
//  SubjectStackViewCell.swift
//  Ambition
//
//  Created by 조병진 on 2023/03/02.
//

import UIKit
import SnapKit
import Then

class SubjectStackViewCell: UIView {
    private let emojiLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 40)
    }
    
    private let subjectNameLabel = UILabel().then {
        $0.textColor = .grayDarken2
        $0.font = .title3Bold
    }
    
    private let percentLabel = UILabel().then {
        $0.textColor = .whiteElevated4
        $0.font = .title3Medium
    }
    
    private let timeLabel = UILabel().then {
        $0.textColor = .whiteElevated5
        $0.font = .title2Medium
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 75)
    }
    
    init(
        emoji: String?,
        subjectName: String?,
        percent: String?,
        time: String?
    ) {
        super.init(frame: .zero)
        emojiLabel.text = emoji
        percentLabel.text = percent
        subjectNameLabel.text = subjectName
        timeLabel.text = time
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

extension SubjectStackViewCell {
    private func addSubViews() {
        
        [
            emojiLabel,
            subjectNameLabel,
            percentLabel,
            timeLabel
        ].forEach({ addSubview($0) })
    }
    
    private func makeConstraints() {
        emojiLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(28)
            $0.centerY.equalToSuperview()
        }
        subjectNameLabel.snp.makeConstraints {
            $0.left.equalTo(emojiLabel.snp.right).offset(24)
            $0.bottom.equalTo(self.snp.centerY).offset(-3)
        }
        percentLabel.snp.makeConstraints {
            $0.left.equalTo(emojiLabel.snp.right).offset(24)
            $0.top.equalTo(self.snp.centerY).offset(4)
        }
        timeLabel.snp.makeConstraints {
            $0.right.equalToSuperview().inset(21)
            $0.centerY.equalToSuperview()
        }
    }
}
