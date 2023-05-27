import UIKit

extension UIStackView {
    func removeAll() {
        for item in self.subviews {
            item.removeFromSuperview()
        }
    }
}
