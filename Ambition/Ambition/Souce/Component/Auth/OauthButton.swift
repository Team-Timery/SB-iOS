//
//  OauthButton.swift
//  Ambition
//
//  Created by 조병진 on 2023/02/11.
//

import Foundation
import UIKit
import SnapKit
import Then

class OauthButton: UIButton {
    
    private let titleTextLabel = UILabel().then {
        $0.font = .title3Medium
    }
    
    private let logoImageView = UIImageView()
    
    init(title: String, logoImage: UIImage?, titleColor: UIColor, backColor: UIColor) {
        super.init(frame: .zero)
        backgroundColor = backColor
        layer.borderWidth = 1
        layer.cornerRadius = 30
        layer.borderColor = UIColor.whiteElevated3?.cgColor
        logoImageView.image = logoImage
        titleTextLabel.text = title
        titleTextLabel.textColor = titleColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        addSubviews()
        makeConstraints()
    }
}

extension OauthButton {
    private func addSubviews() {
        [
            titleTextLabel,
            logoImageView
        ].forEach({ addSubview($0) })
    }
    
    private func makeConstraints() {
        titleTextLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(15)
        }
        
        logoImageView.snp.makeConstraints {
            $0.width.height.equalTo(25)
            $0.centerY.equalToSuperview()
            $0.right.equalTo(titleTextLabel.snp.left).offset(-5)
        }
    }
}
