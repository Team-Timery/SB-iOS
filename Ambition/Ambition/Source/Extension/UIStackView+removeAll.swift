//
//  UIStackView+removeAll.swift
//  Ambition
//
//  Created by 조병진 on 2023/05/13.
//

import UIKit

extension UIStackView {
    func removeAll() {
        for item in self.subviews {
            item.removeFromSuperview()
        }
    }
}
