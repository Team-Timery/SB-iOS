import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class TipsTableViewCell: UITableViewCell {

    let contentBackgroundView = UIView().then {
        $0.backgroundColor = .whiteElevated1
        $0.layer.cornerRadius = 15
    }

    private let contentStackView = UIStackView().then {
        $0.spacing = 15
        $0.axis = .vertical
    }

    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .main2Bold
    }

    let contentLabel = UILabel().then {
        $0.textColor = .whiteElevated4
        $0.font = UIFont(name: "Pretendard-Medium", size: 13)
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.lineBreakStrategy = .pushOut
        $0.isHidden = true
    }

    let showContentArrowImageView = UIImageView().then {
        $0.tintColor = .whiteElevated4
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [
            titleLabel,
            contentLabel
        ].forEach({ contentStackView.addArrangedSubview($0) })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }
}

extension TipsTableViewCell {
    private func addSubViews() {
        addSubview(contentBackgroundView)
        [
            contentStackView,
            showContentArrowImageView
        ].forEach({ contentBackgroundView.addSubview($0) })
    }

    private func makeConstraints() {
        contentBackgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalTo(contentStackView.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().inset(5)
        }
        contentStackView.snp.makeConstraints {
            $0.topMargin.equalTo(15)
            $0.left.right.equalToSuperview().inset(20)
        }
        showContentArrowImageView.snp.makeConstraints {
            $0.width.height.equalTo(18)
            $0.centerY.equalTo(titleLabel)
            $0.rightMargin.equalTo(-23)
        }
    }
}
