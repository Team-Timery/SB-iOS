import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class SubjectsTableViewCell: UITableViewCell {

    weak var delegate: SubjectCellTapButtonDelegate?

    private let cellBackgroundView = UIView().then {
        $0.layer.shadowColor = UIColor.gray.cgColor
        $0.layer.shadowOpacity = 0.8
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
    }

    let disposeBag = DisposeBag()

    var subjectID: Int = 0
    var indexPath: IndexPath = IndexPath()

    let emojiLabel = UILabel().then {
        $0.text = "🔥"
        $0.font = UIFont(name: "Pretendard-Medium", size: 40)
    }

    let subjectLabel = UILabel().then {
        $0.minimumScaleFactor = 5
        $0.textColor = .black
        $0.font = .title2Medium
    }

    let timerLabel = UILabel().then {
        $0.text = "00:00:00"
        $0.textColor = .black
        $0.font = .title2Medium
    }

    let deleteButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "trash_can"), for: .normal)
        $0.tintColor = .whiteElevated3
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        addSubviews()
        makeConstraints()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension SubjectsTableViewCell {
    private func bind() {
        deleteButton.rx.tap
            .bind { [unowned self] in
                delegate?.deleteButtonTapped(
                    id: subjectID,
                    indexPath: indexPath,
                    title: subjectLabel.text
                )
            }
            .disposed(by: disposeBag)
    }

    private func addSubviews() {
        addSubview(cellBackgroundView)

        [
            emojiLabel,
            subjectLabel,
            timerLabel,
            deleteButton
        ].forEach({ cellBackgroundView.addSubview($0) })
    }

    private func makeConstraints() {
        cellBackgroundView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(15)
            $0.height.equalTo(85)
            $0.bottom.equalToSuperview()
        }
        emojiLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(24)
            $0.centerY.equalToSuperview()
        }
        subjectLabel.setContentCompressionResistancePriority(.init(0), for: .horizontal)
        subjectLabel.setContentHuggingPriority(.init(0), for: .horizontal)
        subjectLabel.snp.makeConstraints {
            $0.left.equalTo(emojiLabel.snp.right).offset(26)
            $0.right.equalTo(timerLabel.snp.left)
            $0.centerY.equalToSuperview()
        }
        timerLabel.setContentCompressionResistancePriority(.init(1), for: .horizontal)
        timerLabel.snp.makeConstraints {
            $0.right.equalTo(deleteButton.snp.left).offset(-10)
            $0.centerY.equalToSuperview()
        }
        deleteButton.snp.makeConstraints {
            $0.width.equalTo(35)
            $0.rightMargin.equalTo(-12)
            $0.top.bottom.equalToSuperview().inset(2)
            $0.centerY.equalToSuperview()
        }
    }
}
