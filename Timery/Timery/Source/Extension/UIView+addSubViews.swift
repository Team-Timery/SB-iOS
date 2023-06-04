import UIKit

public extension UIView {
    func addSubViews(views: UIView...) {
        views.forEach(self.addSubview(_:))
    }

    func addSubViews(views: [UIView]) {
        views.forEach(self.addSubview(_:))
    }
}
