import UIKit
import Then
import SnapKit

final class TimeLineCellView: UIView, AddViewable, ConstraintMakable {
    private let recordEntity: RecordEntity
    private var recordTitle: String {
        recordEntity.isRecord ? recordEntity.subject.title : "쉬는 시간"
    }
    private var recordRangeTimeText: String {
        "\(recordEntity.startedTime) ~ \(recordEntity.finishedTime)"
    }
    private var recordStudyTimeText: String {
        recordEntity.total.toFullTimeString()
    }
    private lazy var recordEmojiLabel = UILabel().then {
        $0.text = recordEntity.subject.emoji
        $0.font = .miniTypograph
    }
    private lazy var restTimeImageView = UIImageView().then {
        $0.image = UIImage(named: "rest_time")
    }
    private let subjectLabel = UILabel().then {
        $0.font = .mini1Bold
        $0.textColor = .grayDarken4
    }
    private let recordTimeRangeLabel = UILabel().then {
        $0.font = .mini2Medium
        $0.textColor = .grayDarken1
    }
    private let recordStackView = UIStackView().then {
        $0.alignment = .leading
        $0.axis = .vertical
        $0.spacing = 6
    }
    private let studyTimeLabel = UILabel().then {
        $0.font = .mini1Medium
        $0.textColor = .whiteElevated5
    }

    init(recordEntity: RecordEntity) {
        self.recordEntity = recordEntity
        super.init(frame: .zero)
        addSubViews()
        makeConstraints()
        subjectLabel.text = recordTitle
        recordEmojiLabel.text = recordEntity.subject.emoji
        recordTimeRangeLabel.text = recordRangeTimeText
        studyTimeLabel.text = recordStudyTimeText
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubViews() {
        self.recordStackView.addArrangedSubViews(views: [
            subjectLabel,
            recordTimeRangeLabel
        ])
        self.addSubViews(views: [
            recordStackView,
            studyTimeLabel,
            recordEntity.isRecord ? recordEmojiLabel : restTimeImageView
        ])
    }

    func makeConstraints() {
        if recordEntity.isRecord {
            recordEmojiLabel.snp.makeConstraints {
                $0.leading.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
        } else {
            restTimeImageView.snp.makeConstraints {
                $0.leading.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
        }
        studyTimeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        recordStackView.snp.makeConstraints {
            let trailingAnchor = recordEntity.isRecord ?
            recordEmojiLabel.snp.trailing :
            restTimeImageView.snp.trailing
            $0.leading.equalTo(trailingAnchor).offset(20)
            $0.trailing.equalTo(studyTimeLabel.snp.leading)
            $0.centerY.equalToSuperview()
        }
    }
}
