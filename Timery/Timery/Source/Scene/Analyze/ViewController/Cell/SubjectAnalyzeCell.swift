import UIKit
import SnapKit
import Then

class SubjectAnalyzeCell: UIView {
    private let emojiLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 40)
    }

    private let etcImageView = UIImageView().then {
        $0.image = UIImage(named: "etc_circle")
        $0.isHidden = true
    }

    private let subjectNameLabel = UILabel().then {
        $0.textColor = .grayDarken2
        $0.font = .title3Bold
    }

    private let percentLabel = UILabel().then {
        $0.textColor = .whiteElevated4
        $0.font = .title3Medium
    }

    private let timeLabel = UILabel().then {
        $0.textColor = .whiteElevated5
        $0.font = .title2Medium
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 75)
    }

    init(
        emoji: String?,
        subjectName: String?,
        percent: String?,
        time: String?
    ) {
        super.init(frame: .zero)
        guard let emoji = emoji else { return }
        if emoji.isEmpty { etcImageView.isHidden = false }
        emojiLabel.text = emoji
        percentLabel.text = percent
        subjectNameLabel.text = subjectName
        timeLabel.text = time
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension SubjectAnalyzeCell {
    private func addSubViews() {

        [
            emojiLabel,
            etcImageView,
            subjectNameLabel,
            percentLabel,
            timeLabel
        ].forEach({ addSubview($0) })
    }

    private func makeConstraints() {
        emojiLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(28)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(40)
        }
        etcImageView.snp.makeConstraints {
            $0.leftMargin.equalTo(25)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(50)
        }
        subjectNameLabel.snp.makeConstraints {
            $0.left.equalTo(emojiLabel.snp.right).offset(24)
            $0.bottom.equalTo(self.snp.centerY).offset(-3)
        }
        percentLabel.snp.makeConstraints {
            $0.left.equalTo(emojiLabel.snp.right).offset(24)
            $0.top.equalTo(self.snp.centerY).offset(4)
        }
        timeLabel.snp.makeConstraints {
            $0.right.equalToSuperview().inset(21)
            $0.centerY.equalToSuperview()
        }
    }
}
