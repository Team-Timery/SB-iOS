import UIKit
import Then
import SnapKit
import RxGesture
import RxSwift
import RxCocoa

final class RecordDetailViewController: BaseViewController<RecordDetailViewModel>, ViewModelTransformable {
    private lazy var restIconImageView = UIImageView().then {
        $0.image = UIImage(named: "rest_time")
        $0.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
    }
    private lazy var subjectEmojiLabel = UILabel().then {
        $0.font = .title2Medium
    }
    private let subjectLabel = UILabel().then {
        $0.textColor = .grayDarken4
        $0.font = .title2Medium
    }
    private let subjectStackView = UIStackView().then {
        $0.spacing = 6
        $0.axis = .horizontal
    }
    private let studyTimeLabel = UILabel().then {
        $0.textColor = .grayDarken4
        $0.font = .title1Bold
    }
    private let studyStackView = UIStackView().then {
        $0.spacing = 16
        $0.axis = .vertical
    }
    private let memoTitleLabel = UILabel().then {
        $0.text = "메모"
        $0.textColor = .grayDarken4
        $0.font = .mini1Bold
    }
    private let memoContentLabel = UILabel().then {
        $0.font = .mini1Medium
    }
    private let chevronRightImageView = UIImageView().then {
        $0.tintColor = .whiteElevated4
        $0.image = UIImage(systemName: "chevron.right")
    }
    private let memoContentStackView = UIStackView().then {
        $0.spacing = 12
        $0.axis = .horizontal
    }
    private let memoStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    private let recordTimeRangeTitleLabel = UILabel().then {
        $0.text = "측정 시간"
        $0.textColor = .grayDarken4
        $0.font = .mini1Bold
    }
    private let recordTimeRangeContentLabel = UILabel().then {
        $0.textColor = .whiteElevated5
        $0.font = .mini1Medium
    }
    private let recordStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    private let contentStackView = UIStackView().then {
        $0.spacing = 32
        $0.axis = .vertical
    }
    private let startRecordButton = UIButton().then {
        $0.backgroundColor = .mainElevated
        $0.setTitle("측정 시작하기", for: .normal)
        $0.titleLabel?.font = .title3Medium
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
    }

    private let memoChangedRelay = PublishRelay<String>()
    lazy var input: RecordDetailViewModel.Input = .init(
        memoChanged: memoChangedRelay.asObservable()
    )
    lazy var output: RecordDetailViewModel.Output = viewModel.transform(input: input)

    override func addSubViews() {
        studyStackView.addArrangedSubViews(views: [subjectStackView, studyTimeLabel])
        memoContentStackView.addArrangedSubViews(views: [memoContentLabel, chevronRightImageView])
        memoStackView.addArrangedSubViews(views: [memoTitleLabel, memoContentStackView])
        recordStackView.addArrangedSubViews(views: [recordTimeRangeTitleLabel, recordTimeRangeContentLabel])
        contentStackView.addArrangedSubViews(views: [memoStackView, recordStackView])
        view.addSubViews(views: [studyStackView, contentStackView, startRecordButton])
    }

    override func makeConstraints() {
        studyStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.leading.equalToSuperview().inset(24)
        }
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(studyStackView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        startRecordButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(60)
        }
    }

    // swiftlint: disable function_body_length
    override func bind() {
        memoContentStackView.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                let textInputViewController = TextInputViewController(
                    viewModel: TextInputViewModel(maxInputCount: 50, completeionHandler: { text in
                        owner.memoChangedRelay.accept(text)
                    })
                )
                textInputViewController.modalPresentationStyle = .overFullScreen
                owner.present(textInputViewController, animated: true)
            }
            .disposed(by: disposeBag)

        memoContentStackView.rx.longPressGesture(configuration: { gesture, _ in
            gesture.minimumPressDuration = 0.0
        })
        .compactMap { (gesture: UILongPressGestureRecognizer) -> CGFloat? in
            switch gesture.state {
            case .began:
                return 0.6

            case .ended:
                return 1

            default:
                return nil
            }
        }
        .bind(to: memoContentStackView.rx.alpha)
        .disposed(by: disposeBag)

        startRecordButton.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewControllerWithCompletion(animated: true) {
                    NotificationCenter.default.post(name: .selectedTabbarIndex, object: 0)
                }
            }
            .disposed(by: disposeBag)

        startRecordButton.rx.longPressGesture(configuration: { gesture, _ in
            gesture.minimumPressDuration = 0.0
        })
        .compactMap {
            switch $0.state {
            case .began:
                return UIColor.mainDarken

            case .ended:
                return UIColor.mainElevated

            default:
                return nil
            }
        }
        .bind(to: startRecordButton.rx.backgroundColor)
        .disposed(by: disposeBag)

        output.recordDetailEntity
            .drive(with: self, onNext: { (owner, recordTuple) in
                let (recordEntity, recordDetailEntity) = recordTuple
                if owner.subjectStackView.subviews.isEmpty {
                    owner.subjectStackView.addArrangedSubViews(views: [
                        recordEntity.isRecord ? owner.subjectEmojiLabel : owner.restIconImageView,
                        owner.subjectLabel
                    ])
                    if recordEntity.isRecord {
                        owner.subjectEmojiLabel.text = recordEntity.subject.emoji
                    }
                }
                owner.subjectLabel.text = recordEntity.isRecord ? recordEntity.subject.title : "쉬는 시간"
                owner.studyTimeLabel.text = recordEntity.total.toFullTimeString()
                owner.memoContentLabel.text = recordDetailEntity.memo ?? "메모를 남겨보세요"
                owner.memoContentLabel.textColor = recordDetailEntity.memo == nil ? .mainElevated : .whiteElevated4
                owner.recordTimeRangeContentLabel.text = "\(recordEntity.startedTime) ~ \(recordEntity.finishedTime)"
            })
            .disposed(by: disposeBag)
    }
    // swiftlint: enable function_body_length
}
