import Foundation
import UIKit
import SnapKit
import Then

class ListHeaderView: UIView {
    private let titleLabel = UILabel().then {
        $0.textColor = .grayDarken4
    }

    init(
        title: String?,
        font: UIFont?
    ) {
        super.init(frame: .zero)
        titleLabel.text = title
        titleLabel.font = font
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension ListHeaderView {
    private func addSubViews() {
        addSubview(titleLabel)
    }

    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(25)
            $0.topMargin.equalTo(5)
        }
    }
}
