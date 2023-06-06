import UIKit
import SnapKit
import Then

@available(*, deprecated, message: "Use 'TimeLineCellView'")
class SubjectTimeLineCellView: UIStackView {
    private var cellWidth: Double = 0
    private var showMemo: Bool = false

    private let subjectCellView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.whiteElevated4?.cgColor
        $0.layer.cornerRadius = 10
    }

    private let emojiLabel = UILabel().then {
        $0.font = .typograpy
    }

    private let subjectTitleLabel = UILabel().then {
        $0.font = .main2Medium
        $0.textColor = .whiteElevated4
    }

    private let arrowImageView = UIImageView().then {
        $0.image = UIImage(named: "down_arrow_round_line")
        $0.tintColor = .whiteElevated4
    }

    private let studyTimeLabel = UILabel().then {
        $0.font = .main1Medium
        $0.textColor = .black
    }

    private let studyMemoLabel = UILabel().then {
        $0.text = "기록한 내용이 없습니다"
        $0.font = .main1Medium
        $0.textColor = .grayDarken1
        $0.textAlignment = .left
        $0.lineBreakStrategy = .pushOut
        $0.numberOfLines = 0
        $0.isHidden = true
    }

    private let startTimeLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.textColor = .whiteElevated4
    }

    private let startTimeStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
    }

    private let spacerView = UIView()

    init(
        emoji: String,
        subjectName: String,
        startTime: String,
        studyTime: String,
        memo: String,
        cellWidth: Double
    ) {
        super.init(frame: .zero)
        startTimeLabel.text = startTime
        emojiLabel.text = emoji
        subjectTitleLabel.text = subjectName
        studyTimeLabel.text = studyTime
        studyMemoLabel.text = memo
        self.cellWidth = cellWidth
        axis = .horizontal
        spacing = 8
        alignment = .top
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        subjectCellView.addGestureRecognizer(tapGesture)
        [spacerView, startTimeLabel].forEach({ startTimeStack.addArrangedSubview($0) })
        [startTimeStack, subjectCellView].forEach({ addArrangedSubview($0) })
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension SubjectTimeLineCellView {
    @objc func handleTap(sender: UITapGestureRecognizer) {
        showMemo.toggle()
        studyMemoLabel.isHidden = !showMemo
        if showMemo {
            subjectCellView.snp.remakeConstraints {
                $0.width.equalTo(cellWidth)
                $0.bottom.equalTo(studyMemoLabel.snp.bottom).offset(13)
            }
            arrowImageView.image = UIImage(named: "up_arrow_round_line")
        } else {
            subjectCellView.snp.remakeConstraints {
                $0.width.equalTo(cellWidth)
                $0.bottom.equalTo(studyTimeLabel.snp.bottom).offset(13)
            }
            arrowImageView.image = UIImage(named: "down_arrow_round_line")
        }
    }
}

// MARK: - addSubViews & makeConstraints

extension SubjectTimeLineCellView {
    private func addSubViews() {
        [
            subjectTitleLabel,
            emojiLabel,
            arrowImageView,
            studyTimeLabel,
            studyMemoLabel
        ].forEach({ subjectCellView.addSubview($0) })
    }

    private func makeConstraints() {
        spacerView.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        subjectCellView.snp.makeConstraints {
            $0.width.equalTo(cellWidth)
            $0.bottom.greaterThanOrEqualTo(studyTimeLabel.snp.bottom).offset(13)
        }
        emojiLabel.snp.makeConstraints {
            $0.topMargin.leftMargin.equalTo(16)
        }
        subjectTitleLabel.snp.makeConstraints {
            $0.topMargin.equalTo(13)
            $0.left.equalTo(emojiLabel.snp.right).offset(16)
        }
        arrowImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-16)
            $0.width.height.equalTo(18)
        }
        studyTimeLabel.snp.makeConstraints {
            $0.top.equalTo(subjectTitleLabel.snp.bottom).offset(7)
            $0.left.equalTo(emojiLabel.snp.right).offset(16)
        }
        studyMemoLabel.snp.makeConstraints {
            $0.top.equalTo(emojiLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(18)
        }
    }
}
