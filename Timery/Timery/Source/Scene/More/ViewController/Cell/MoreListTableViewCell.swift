import UIKit
import SnapKit
import Then

class MoreListTableViewCell: UITableViewCell {

    let titleLabel = UILabel().then {
        $0.textColor = .grayDarken4
        $0.font = .mini1Medium
    }

    let emojiLabel = UILabel().then {
        $0.font = .mini1Medium
    }

    let leftSubLabel = UILabel().then {
        $0.textColor = .whiteElevated4
        $0.font = .mini1Medium
    }

    override func layoutSubviews() {
        addSubViews()
        makeConstraints()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension MoreListTableViewCell {
    private func addSubViews() {
        [
            emojiLabel,
            titleLabel,
            leftSubLabel
        ].forEach({ addSubview($0) })
    }

    private func makeConstraints() {
        emojiLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(emojiLabel.snp.right).offset(14)
            $0.centerY.equalToSuperview()
        }
        leftSubLabel.snp.makeConstraints {
            $0.rightMargin.equalTo(-10)
            $0.centerY.equalToSuperview()
        }
    }
}
