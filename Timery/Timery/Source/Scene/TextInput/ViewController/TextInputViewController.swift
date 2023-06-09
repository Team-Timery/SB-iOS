import Then
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TextInputViewController: BaseViewController<TextInputViewModel>, ViewModelTransformable {
    private let inputTextCountLabel = UILabel().then {
        $0.textColor = .grayDarken1
        $0.font = .mini2Medium
    }
    private let xmarkButton = UIButton().then {
        $0.setImage(UIImage(named: "xmark"), for: .normal)
    }
    private let completeButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.whiteElevated5, for: .normal)
        $0.titleLabel?.font = .title2Medium
    }
    private let contentTextView = UITextView().then {
        $0.textColor = .whiteElevated5
        $0.font = .title2Medium
    }

    lazy var input: TextInputViewModel.Input = .init(
        completeButtonDidTap: completeButton.rx.tap.asObservable(),
        contentTextDidChange: contentTextView.rx.text.orEmpty.asObservable()
    )
    lazy var output: TextInputViewModel.Output = viewModel.transform(input: input)

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentTextView.do {
            var topCorrect = ($0.bounds.size.height - $0.contentSize.height * $0.zoomScale) / 2
            topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect
            $0.contentInset.top = topCorrect
            $0.textAlignment = .center
            $0.becomeFirstResponder()
        }
    }

    override func addSubViews() {
        view.addSubViews(views: [
            xmarkButton,
            inputTextCountLabel,
            completeButton,
            contentTextView
        ])
    }

    override func makeConstraints() {
        xmarkButton.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.size.equalTo(28)
        }
        inputTextCountLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.centerX.equalToSuperview()
        }
        completeButton.snp.makeConstraints {
            $0.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(20)
        }
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(completeButton.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }

    override func bind() {
        xmarkButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        output.contentText
            .drive(contentTextView.rx.text)
            .disposed(by: disposeBag)

        output.completionHandled
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        Driver.combineLatest(output.contentText, output.maxInputCount)
            .map { "\($0.count)/\($1)" }
            .drive(inputTextCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
