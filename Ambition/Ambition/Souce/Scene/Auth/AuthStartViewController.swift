//
//  AuthStartViewController.swift
//  Ambition
//
//  Created by 조병진 on 2023/02/10.
//

import UIKit
import SnapKit
import Then

class AuthStartViewController: UIViewController {
    
    private let titleMainLabel = UILabel().then {
        $0.text = "끝가지 가는 열정,"
        $0.textColor = .black
        $0.font = .typograpy
    }
    
    private let titleSubLabel = UILabel().then {
        $0.text = "Ambition"
        $0.textColor = .mainElevated
        $0.font = .typograpy
    }
    
    private let titleindicatorLabel = UILabel().then {
        $0.text = "로그인 후 측정을 시작하세요"
        $0.textColor = .whiteElevated4
        $0.font = .main2Medium
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        addSubviews()
        makeConstraints()
    }
}

extension AuthStartViewController {
    private func addSubviews() {
        [
            titleMainLabel,
            titleSubLabel,
            titleindicatorLabel
        ].forEach({ view.addSubview($0) })
    }
    
    private func makeConstraints() {
        titleMainLabel.snp.makeConstraints {
            $0.topMargin.equalTo(128)
            $0.leftMargin.equalTo(19)
        }
        
        titleSubLabel.snp.makeConstraints {
            $0.top.equalTo(titleMainLabel.snp.bottom)
            $0.left.equalTo(titleMainLabel)
        }
        
        titleindicatorLabel.snp.makeConstraints {
            $0.top.equalTo(titleSubLabel.snp.bottom).offset(5)
            $0.left.equalTo(titleSubLabel)
        }
    }
}
