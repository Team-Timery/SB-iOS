import UIKit

class NavigationBackButton: UIBarButtonItem {
    override init() {
        super.init()
        image = UIImage(named: "navigation_back_button")
        tintColor = .whiteElevated4
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
