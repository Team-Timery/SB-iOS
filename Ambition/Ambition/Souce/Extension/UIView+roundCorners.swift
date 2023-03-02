//
//  UIView+roundCorners.swift
//  Ambition
//
//  Created by 조병진 on 2023/02/20.
//

import Foundation
import UIKit

extension UIView {
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = false
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
}
