import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class TodayReviewView: UIView, AddViewable, ConstraintMakable {
    private let reviewStackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .vertical
        $0.spacing = 8
    }
    private let todayReviewTitleLabel = UILabel().then {
        $0.font = .main1Bold
        $0.textColor = .whiteElevated5
        $0.text = "오늘의 한줄평 ✍️"
    }
    private let reviewContentLabel = UILabel().then {
        $0.font = .main2Medium
    }
    private let chevronRightImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = .whiteElevated4
    }
    @Invalidating(wrappedValue: nil, .display) private var review: String?

    init(review: String?) {
        super.init(frame: .zero)
        addSubViews()
        makeConstraints()
        self.backgroundColor = .whiteElevated1
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        setReview(review: review)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.reviewContentLabel.text = self.review ?? "한줄평을 입력해주세요"
        self.reviewContentLabel.textColor = self.review == nil ? .mainElevated : .whiteElevated4
    }

    func addSubViews() {
        self.reviewStackView.addArrangedSubViews(views: [
            todayReviewTitleLabel,
            reviewContentLabel
        ])
        self.addSubViews(views: [
            reviewStackView,
            chevronRightImageView
        ])
    }

    func makeConstraints() {
        reviewStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(28)
        }
        chevronRightImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }

    func setReview(review: String?) {
        self.review = review
    }
}

extension Reactive where Base: TodayReviewView {
    var review: Binder<String?> {
        return Binder(self.base) { reviewView, text in
            reviewView.setReview(review: text)
        }
    }
}
