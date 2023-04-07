//
//  SubjectsTableViewCell.swift
//  Ambition
//
//  Created by 조병진 on 2023/02/23.
//

import UIKit
import SnapKit
import Then

class SubjectsTableViewCell: UITableViewCell {
    
    private let cellBackgroundView = UIView().then {
        $0.layer.shadowColor = UIColor.gray.cgColor
        $0.layer.shadowOpacity = 0.8
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
    }
    
    let emojiLabel = UILabel().then {
        $0.text = "🔥"
        $0.font = UIFont(name: "Pretendard-Medium", size: 40)
    }
    
    let subjectLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .title2Medium
    }
    
    let timerLabel = UILabel().then {
        $0.text = "00:00:00"
        $0.textColor = .black
        $0.font = .title2Medium
    }
    
    let deleteButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "trash_can"), for: .normal)
        $0.tintColor = .whiteElevated3
    }
    
    override func layoutSubviews() {
        addSubviews()
        makeConstraints()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension SubjectsTableViewCell {
    private func addSubviews() {
        addSubview(cellBackgroundView)
        
        [
            emojiLabel,
            subjectLabel,
            timerLabel,
            deleteButton
        ].forEach({ cellBackgroundView.addSubview($0) })
    }
    
    private func makeConstraints() {
        cellBackgroundView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(15)
            $0.height.equalTo(85)
            $0.bottom.equalToSuperview()
        }
        emojiLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(24)
            $0.centerY.equalToSuperview()
        }
        subjectLabel.snp.makeConstraints {
            $0.left.equalTo(emojiLabel.snp.right).offset(26)
            $0.centerY.equalToSuperview()
        }
        timerLabel.snp.makeConstraints {
            $0.right.equalTo(deleteButton.snp.left).offset(-17)
            $0.centerY.equalToSuperview()
        }
        deleteButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.rightMargin.equalTo(-20)
            $0.centerY.equalToSuperview()
        }
    }
}
