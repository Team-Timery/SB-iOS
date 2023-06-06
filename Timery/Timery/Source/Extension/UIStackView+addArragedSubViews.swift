import UIKit

public extension UIStackView {
    func addArrangedSubViews(views: UIView...) {
        views.forEach(self.addArrangedSubview(_:))
    }

    func addArrangedSubViews(views: [UIView]) {
        views.forEach(self.addArrangedSubview(_:))
    }
}
