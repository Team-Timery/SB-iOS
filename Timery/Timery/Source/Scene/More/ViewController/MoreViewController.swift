import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import MessageUI

// swiftlint: disable line_length
class MoreViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let logoutRelay = PublishRelay<Void>()
    private let quitUserRelay = PublishRelay<Void>()

    private let sectionTitle = [
        "공지",
        "도움말",
        "앱 정보",
        "약관 및 정책",
        "피드백"
//        "계정 관리"
    ]
    private let listElement = [
        [("📢", "공지사항"), ("📔", "타이머리 이야기")],
        [("💬", "자주 묻는 질문"), ("✅", "타이머리로 갓생살기")],
        [("ℹ️", "버전정보")],
        [("📄", "이용약관"), ("📄", "개인정보 처리방침")],
        [("📧", "이메일 보내기")]
//        [("", "로그아웃"), ("", "회원탈퇴")]
    ]

    private let topView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight)).then {
        $0.layer.opacity = 0
    }

    private let topShadowView = UIView().then {
        $0.backgroundColor = .whiteElevated3
        $0.layer.opacity = 0
    }

    private let listTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.contentInsetAdjustmentBehavior = .scrollableAxes
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.sectionHeaderTopPadding = 5
    }

    private let viewModel = MoreViewModel()
    lazy var input = MoreViewModel.Input(
        logout: self.logoutRelay.asSignal(),
        quitUser: self.quitUserRelay.asSignal()
    )
    lazy var output = viewModel.transform(input: input)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(MoreListTableViewCell.self, forCellReuseIdentifier: "listCell")
        let headerView = ListHeaderView(title: "더보기", font: .miniTitle2Bold)
        headerView.frame.size.height = 60
        listTableView.tableHeaderView = headerView
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
        bind()
    }

    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension MoreViewController {

    private func bind() {
        output.isLogoutSucceed.asObservable()
            .bind {
                self.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: disposeBag)

        output.isQuitUserSucceed.asObservable()
            .bind {
                self.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    private func addSubViews() {
        [
            listTableView,
            topView,
            topShadowView
        ].forEach({ view.addSubview($0) })

    }
    private func makeConstraints() {
        topView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(view.safeAreaInsets.top)
            $0.top.equalToSuperview()
        }
        topShadowView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
        listTableView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalToSuperview()
        }
    }

    // MARK: - 나중에 로직 변경해야 할듯

    private func selectPath(selectName: String) {
        switch selectName {
        case "회원정보":
            let userInfoView = UserInfoViewController()
            navigationController?.pushViewController(userInfoView, animated: true)
        case "공지사항":
            let noticeView = NoticeViewController()
            navigationController?.pushViewController(noticeView, animated: true)
        case "타이머리 이야기":
            if let url = URL(string: "https://timery.notion.site/0501f10811204d7f9f95f999f06fb964") {
                UIApplication.shared.open(url)
            }
        case "자주 묻는 질문":
            let questionView = QuestionViewController()
            navigationController?.pushViewController(questionView, animated: true)
        case "타이머리로 갓생살기":
            let tipsView = TipsViewController()
            navigationController?.pushViewController(tipsView, animated: true)
        case "이용약관":
            if let url = URL(string: "https://timery.notion.site/961026a89ec9492ab6359fe9b301f083") {
                UIApplication.shared.open(url)
            }
        case "개인정보 처리방침":
            if let url = URL(string: "https://timery.notion.site/c849a43a4b8c40c69192f061c166fbbc") {
                UIApplication.shared.open(url)
            }
        case "이메일 보내기":
            sendEmail()
        case "로그아웃":
            let logoutAlert = LogoutAlert(
                completion: {
                    self.logoutRelay.accept(())
                },
                alertStyle: .light
            )
            present(logoutAlert, animated: false)
        case "회원탈퇴":
            let quitAlert = QuitAlertViewController(
                completion: {
                    self.quitUserRelay.accept(())
                },
                alertStyle: .light
            )
            present(quitAlert, animated: false)
        default:
            print(selectName + " defalte")
        }
    }

    private func sendEmail() {
       if MFMailComposeViewController.canSendMail() {
           let composeVC = MFMailComposeViewController()
           composeVC.mailComposeDelegate = self
           composeVC.setToRecipients(["timery.help@gmail.com"])
           composeVC.setSubject("제목을 입력하세요.")
           composeVC.setMessageBody("", isHTML: false)
           self.present(composeVC, animated: true)
       } else {
           let errorAlert = SimpleAlertViewController(
            titleText: "이메일을 보낼수 없음",
            messageText: "현재 이메일을 보낼수 없는 것으로 보이네요. 공식 이메일 앱을 다운하거나 로그인 해주세요!",
            alertStyle: .light
           )
           self.present(errorAlert, animated: false)
       }
   }
}

extension MoreViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true)
    }
}

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return ListHeaderView(title: sectionTitle[section], font: .miniTitle3Bold)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listElement[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = listTableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? MoreListTableViewCell
        else { return UITableViewCell() }
        if indexPath.section == 2 {
            var version: String? {
                guard let dictionary = Bundle.main.infoDictionary,
                      let version = dictionary["CFBundleShortVersionString"] as? String else {return nil}

                let versionAndBuild: String = "\(version)"
                return versionAndBuild
            }
            cell.leftSubLabel.text = version
        }
        cell.emojiLabel.text = listElement[indexPath.section][indexPath.row].0
        cell.titleLabel.text = listElement[indexPath.section][indexPath.row].1

        cell.rx.longPressGesture(configuration: { gesture, _ in
            gesture.minimumPressDuration = 0.0
        })
        .filter { _ in indexPath.section != 2}
        .compactMap {
            switch $0.state {
            case .began:
                return UIColor.whiteElevated2

            case .ended:
                return UIColor.white

            default:
                return nil
            }
        }
        .bind(to: cell.rx.backgroundColor)
        .disposed(by: disposeBag)
        cell.rx.tapGesture()
            .throttle(.milliseconds(100), latest: false, scheduler: MainScheduler.instance)
            .filter { _ in indexPath.section != 2}
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.selectPath(selectName: cell.titleLabel.text!)
            }
            .disposed(by: disposeBag)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        [
            topView,
            topShadowView
        ].forEach({
            $0.layer.opacity = (Float(scrollView.contentOffset.y + view.safeAreaInsets.top)) / 20
        })
    }
}
// swiftlint: enable line_length
