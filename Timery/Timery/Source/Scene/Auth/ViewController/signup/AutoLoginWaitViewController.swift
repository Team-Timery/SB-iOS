import UIKit
import SnapKit
import Then

class AutoLoginWaitViewController: UIViewController {
    public func dismissView() {
        self.dismiss(animated: false)
    }

    private let indicatorView = UIActivityIndicatorView().then {
        $0.startAnimating()
        $0.color = .white
        $0.style = .large
    }

    override func viewDidLoad() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
    }

    override func viewDidLayoutSubviews() {
        view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
