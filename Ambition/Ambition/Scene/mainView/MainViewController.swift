//
//  MainViewController.swift
//  Ambition
//
//  Created by 조병진 on 2023/02/06.
//

import UIKit
import SnapKit
import Then

class MainViewController: UIViewController {
    
    private let label = UILabel().then {
        $0.text = "MainView"
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-Black", size: 50)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension MainViewController {
    private func addSubViews() {
        view.addSubview(label)
    }
    
    private func makeConstraints() {
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
