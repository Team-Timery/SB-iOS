import Then
import UIKit
import SnapKit
import RxCocoa

final class TextInputViewController: BaseViewController<TextInputViewModel>, ViewModelTransformable {
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

    override func addSubViews() {
        view.addSubViews(views: [
            xmarkButton,
            completeButton,
            contentTextView
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentTextView.becomeFirstResponder()
    }

    override func makeConstraints() {
        xmarkButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
            $0.size.equalTo(20)
        }

        completeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(20)
        }

        contentTextView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
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
    }
}
