import Foundation
import UIKit

enum AlertStyle {
    case light, dark

    public var backgroungColor: UIColor? {
        switch self {
        case .light:
            return .white
        case .dark:
            return .grayDarken3
        }
    }

    public var textColor: UIColor? {
        switch self {
        case .light:
            return .black
        case .dark:
            return .white
        }
    }

    public var buttonBackgroundColor: UIColor? {
        switch self {
        case .light:
            return .main
        case .dark:
            return .grayDarken2
        }
    }
}
