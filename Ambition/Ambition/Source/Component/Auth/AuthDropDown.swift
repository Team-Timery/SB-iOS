//
//  AuthDropDown.swift
//  Ambition
//
//  Created by 조병진 on 2023/02/11.
//

import Foundation
import UIKit
import DropDown
import SnapKit
import Then

class AuthDropDown: UIView {
    let dropDown = DropDown()

    var selectItem: String?
    private var items: [String] = []

    private let titleLabel = UILabel().then {
        $0.textColor = .whiteElevated4
        $0.font = .main2Medium
    }

    private let valueLabel = UILabel().then {
        $0.text = "선택해주세요"
        $0.textColor = .black
        $0.font = .title3Medium
    }

    private let arrowImageView = UIImageView(image: UIImage(named: "dropdown_arrow_down"))

    init(label: String, items: [String]) {
        super.init(frame: .zero)
        titleLabel.text = label
        self.items = items

        backgroundColor = .white
        layer.cornerRadius = 10
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.whiteElevated4?.cgColor

        DropDown.startListeningToKeyboard()
        DropDown.appearance().textColor = .black
        DropDown.appearance().selectedTextColor = .black
        DropDown.appearance().textFont = .title3Medium!
        DropDown.appearance().backgroundColor = .white
        DropDown.appearance().selectionBackgroundColor = UIColor.whiteElevated2!
        DropDown.appearance().setupCornerRadius(10)
        DropDown.appearance().cellHeight = 60
        dropDown.dismissMode = .onTap
        setDropDown()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        addSubviews()
        makeconstraints()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dropDown.show()
        arrowImageView.image = UIImage(named: "dropdown_arrow_up")
    }
}

extension AuthDropDown {
    private func setDropDown() {
        dropDown.dataSource = items
        dropDown.anchorView = self
        dropDown.bottomOffset = CGPoint(x: 0, y: 60)

        dropDown.selectionAction = { [self] _, item in
            valueLabel.text = item
            selectItem = item
            arrowImageView.image = UIImage(named: "dropdown_arrow_down")
        }

        dropDown.cancelAction = { [self] in
            arrowImageView.image = UIImage(named: "dropdown_arrow_down")
        }
    }

    private func addSubviews() {
        [
            titleLabel,
            valueLabel,
            arrowImageView
        ].forEach({ addSubview($0) })
    }

    private func makeconstraints() {
        valueLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(20)
            $0.centerY.equalToSuperview()
        }

        arrowImageView.snp.makeConstraints {
            $0.width.height.equalTo(36)
            $0.right.equalToSuperview().inset(5)
            $0.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(9)
            $0.bottom.equalTo(self.snp.top).offset(-8)
        }
    }
}
