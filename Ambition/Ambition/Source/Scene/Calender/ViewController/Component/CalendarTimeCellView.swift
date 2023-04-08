import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class CalendarTimeCellView: UIView {
    public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    public var content: String? {
        didSet {
            timeLabel.text = content
        }
    }

    private let titleLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.textColor = .whiteElevated4
    }

    private let timeLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.textColor = .black
    }

    init(title: String, times: String? = nil) {
        super.init(frame: .zero)
        backgroundColor = .whiteElevated1
        layer.cornerRadius = 10
        titleLabel.text = title
        timeLabel.text = times
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        addSubViews()
        makeconstraints()
    }
}

extension CalendarTimeCellView {
    private func addSubViews() {
        [
            titleLabel,
            timeLabel
        ].forEach({ addSubview($0) })
    }

    private func makeconstraints() {
        titleLabel.snp.makeConstraints {
            $0.topMargin.equalTo(22)
            $0.leftMargin.equalTo(17)
        }
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(7)
            $0.leftMargin.equalTo(17)
        }
    }
}
