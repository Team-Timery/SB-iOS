import UIKit
import SnapKit
import Then

class RoundBackgroundLabelView: UIView {

    private let textLabel = UILabel().then {
        $0.textColor = .whiteElevated4
        $0.font = .mini1Medium
    }

    init(title: String) {
        super.init(frame: .zero)
        textLabel.text = title
        layer.borderWidth = 1
        layer.borderColor = UIColor.whiteElevated2?.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        addSubViews()
        makeconstraints()
    }
}

extension RoundBackgroundLabelView {
    private func addSubViews() {
        addSubview(textLabel)
    }

    private func makeconstraints() {
        textLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
