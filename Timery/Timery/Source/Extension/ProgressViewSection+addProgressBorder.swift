import UIKit
import SnapKit
import MultiProgressView

extension ProgressViewSection {
    func addProgressBorder(color: UIColor, width: Double) {
        let border = UIView().then {
            $0.backgroundColor = color
        }
        self.addSubview(border)
        border.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalTo(width)
            $0.right.equalToSuperview()
        }
    }
}
