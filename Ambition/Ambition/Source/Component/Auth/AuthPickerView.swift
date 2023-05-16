import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class AuthPickerView: UIViewController {

    let disposeBag = DisposeBag()

    public var pickerData: [Any] = []
    public var pickerButton: UIButton = UIButton()
    public var selectData = PublishRelay<Any?>()
    private var pickerNowSelect: Any?

    private let cancelButton = UIButton(type: .system).then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(UIColor.grayDarken1, for: .normal)
        $0.titleLabel?.font = .indicatorMedium
    }

    private let enterButton = UIButton(type: .system).then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = .indicator
    }

    private let pickerBackgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
    }

    private let pickerView = UIPickerView().then {
        $0.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.1)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerNowSelect = pickerData[0]
        bind()
    }

    override func viewDidLayoutSubviews() {
        addSubviews()
        makeConstraints()
    }
}

extension AuthPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(pickerData[row])"
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerNowSelect = pickerData[row]
    }
}

extension AuthPickerView {
    private func bind() {
        cancelButton.rx.tap
            .bind {
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        enterButton.rx.tap
            .bind {
                self.dismiss(
                    animated: true,
                    completion: { [unowned self] in
                        selectData.accept(pickerNowSelect)
                        pickerButton.setTitle("\(pickerNowSelect ?? "")", for: .normal)
                        pickerButton.setTitleColor(UIColor.black, for: .normal)
                    }
                )
            }
            .disposed(by: disposeBag)
    }

    private func addSubviews() {
        view.addSubview(pickerBackgroundView)
        [
            pickerView,
            cancelButton,
            enterButton
        ].forEach({ pickerBackgroundView.addSubview($0) })
    }

    private func makeConstraints() {
        pickerBackgroundView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(view.frame.height / 3.5)
        }
        pickerView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview()
        }
        cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(15)
        }
        enterButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(15)
        }
    }
}
