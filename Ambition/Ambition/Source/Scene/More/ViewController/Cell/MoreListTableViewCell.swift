import UIKit
import SnapKit
import Then

class MoreListTableViewCell: UITableViewCell {

    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .title3Medium
    }

    let arrowImage = UIImageView(image: UIImage(named: "round_left_arrow"))

    let leftSubLabel = UILabel().then {
        $0.textColor = .whiteElevated4
        $0.font = .main1Medium
    }

    override func layoutSubviews() {
        addSubViews()
        makeConstraints()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension MoreListTableViewCell {
    private func addSubViews() {
        [
            titleLabel,
            arrowImage,
            leftSubLabel
        ].forEach({ addSubview($0) })
    }

    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(10)
            $0.centerY.equalToSuperview()
        }
        arrowImage.snp.makeConstraints {
            $0.rightMargin.equalTo(-8)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(18)
        }
        leftSubLabel.snp.makeConstraints {
            $0.rightMargin.equalTo(-8)
            $0.centerY.equalToSuperview()
        }
    }
}
