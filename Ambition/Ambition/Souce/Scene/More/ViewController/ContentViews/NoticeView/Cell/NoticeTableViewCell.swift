//
//  NoticeTableViewCell.swift
//  Ambition
//
//  Created by 조병진 on 2023/03/09.
//

import UIKit
import SnapKit
import Then

class NoticeTableViewCell: UITableViewCell {
    
    private let contentBackgroundView = UIView().then {
        $0.backgroundColor = .whiteElevated1
        $0.layer.cornerRadius = 15
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .main2Bold
    }
    
    let subtitleLabel = UILabel().then {
        $0.textColor = .grayDarken1
        $0.font = UIFont(name: "Pretendard-Medium", size: 13)
    }
    
    let contentLabel = UILabel().then {
        $0.textColor = .whiteElevated4
        $0.font = UIFont(name: "Pretendard-Medium", size: 13)
        $0.textAlignment = .left
        $0.lineBreakStrategy = .pushOut
        $0.layer.opacity = 0
    }
    
    private let showContentButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "down_arrow_round_line"), for: .normal)
        $0.tintColor = .whiteElevated4
    }
    
    override func layoutSubviews() {
        addSubViews()
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

extension NoticeTableViewCell {
    private func addSubViews() {
        addSubview(contentBackgroundView)
        [
            titleLabel,
            subtitleLabel,
            contentLabel,
            showContentButton
        ].forEach({ contentBackgroundView.addSubview($0) })
    }
    
    private func makeConstraints() {
        contentBackgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.greaterThanOrEqualTo(subtitleLabel.snp.bottom).offset(13)
        }
        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.topMargin.equalTo(13)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.leftMargin.equalTo(20)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(13)
            $0.left.right.equalToSuperview().inset(20)
        }
        showContentButton.snp.makeConstraints {
            $0.width.height.equalTo(18)
            $0.centerY.equalTo(titleLabel.snp.bottom).offset(3)
            $0.rightMargin.equalTo(-23)
        }
    }
}
