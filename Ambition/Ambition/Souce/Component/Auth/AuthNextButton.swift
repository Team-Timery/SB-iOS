//
//  AuthNextButton.swift
//  Ambition
//
//  Created by 조병진 on 2023/02/09.
//

import Foundation
import UIKit
import SnapKit
import Then

class AuthNextButton: UIButton {
    
    init(label: String) {
        super.init(frame: .zero)
        backgroundColor = .mainElevated
        setTitle(label, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.title2Bold
        layer.cornerRadius = 30
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
