import UIKit
import SnapKit
import Then

class BreakTimeLineCellView: UIView {
    private let contentLabel = UILabel().then {
        $0.font = .indicatorMedium
        $0.textColor = .whiteElevated4
    }

    init(
        content: String
    ) {
        super.init(frame: .zero)
        contentLabel.text = content
        backgroundColor = .whiteElevated1
        layer.cornerRadius = 5
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension BreakTimeLineCellView {
    private func addSubViews() {
        self.addSubview(contentLabel)
    }
    private func makeConstraints() {
        contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leftMargin.equalTo(18)
        }
    }
}
