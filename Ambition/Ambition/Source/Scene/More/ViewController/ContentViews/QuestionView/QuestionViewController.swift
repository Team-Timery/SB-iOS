import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class QuestionViewController: UIViewController {
    private var selectIndex: IndexPath?

    private let titleLabel = UILabel().then {
        $0.text = "FAQ"
        $0.textColor = .black
        $0.font = .title1Bold
    }

    private let questionTableView = UITableView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .clear
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        questionTableView.delegate = self
        questionTableView.dataSource = self
        questionTableView.register(QuestionTableViewCell.self, forCellReuseIdentifier: "questionCell")
        questionTableView.separatorStyle = .none
    }

    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension QuestionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "questionCell",
            for: indexPath
        ) as? QuestionTableViewCell else { return UITableViewCell() }

        cell.titleLabel.text = "Q. 앰비션 타이머는 무엇이 다른가요?"
        cell.contentLabel.text = "알잘딱하게 분석을 활용해보세요. 알잘딱알잘딱알잘딱알잘딱"

        cell.contentLabel.isHidden = !(selectIndex == indexPath)
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

extension QuestionViewController {
    private func addSubViews() {
        [
            titleLabel,
            questionTableView
        ].forEach({ view.addSubview($0) })
    }

    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(20)
            $0.topMargin.equalTo(15)
        }
        questionTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
