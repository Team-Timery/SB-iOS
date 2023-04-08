import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class NoticeViewController: UIViewController {

    private var selectIndex: IndexPath?

    private let titleLabel = UILabel().then {
        $0.text = "Notice"
        $0.textColor = .black
        $0.font = .title1Bold
    }

    private let noticeTableView = UITableView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .clear
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        noticeTableView.delegate = self
        noticeTableView.dataSource = self
        noticeTableView.register(NoticeTableViewCell.self, forCellReuseIdentifier: "noticeCell")
        noticeTableView.separatorStyle = .none
    }

    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension NoticeViewController {
    private func addSubViews() {
        [
            titleLabel,
            noticeTableView
        ].forEach({ view.addSubview($0) })
    }
    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(20)
            $0.topMargin.equalTo(15)
        }
        noticeTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension NoticeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "noticeCell",
            for: indexPath
        ) as? NoticeTableViewCell else { return UITableViewCell() }

        cell.titleLabel.text = "공지사항 입니다."
        cell.subtitleLabel.text = "2023.07.31"
        cell.contentLabel.text = """
        안녕하세요 앰비션 앱이 정식 버전을 런칭했어요.

        아무튼 그렇다고요.
        """
        cell.contentLabel.isHidden = selectIndex == indexPath ? false : true
        let arrowImage = UIImage(named: "\(selectIndex == indexPath ? "up" : "down")_arrow_round_line")
        cell.showContentArrowImageView.image = arrowImage?.withRenderingMode(.alwaysTemplate)
        cell.layoutIfNeeded()

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectCell = selectIndex {
            if selectCell == indexPath {
                selectIndex = nil
            } else {
                selectIndex = indexPath
            }
            tableView.reloadRows(at: [selectCell, indexPath], with: .automatic)
        } else {
            selectIndex = indexPath
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
