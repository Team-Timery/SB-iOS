import UIKit
import SnapKit
import Then

class AutoLoginWaitViewController: UIViewController {
    public func dismissView() {
        self.dismiss(animated: false)
    }

    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "Timery_logo")
    }

    override func viewDidLoad() {
        view.backgroundColor = .white
    }

    override func viewDidLayoutSubviews() {
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
