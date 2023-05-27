import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class TipsViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var selectIndex: IndexPath?
    private let getTipsRelay = PublishRelay<Void>()
    private var tipsData: TipsListEntity = [] {
        didSet { tipsTableView.reloadData() }
    }

    private let titleLabel = UILabel().then {
        $0.text = "Tips"
        $0.textColor = .black
        $0.font = .title1Bold
    }

    private let tipsTableView = UITableView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .clear
    }

    private let viewModel = TipsViewModel()
    lazy var input = TipsViewModel.Input(getData: getTipsRelay.asSignal())
    lazy var output = viewModel.transform(input: input)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tipsTableView.delegate = self
        tipsTableView.dataSource = self
        tipsTableView.register(TipsTableViewCell.self, forCellReuseIdentifier: "tipCell")
        tipsTableView.separatorStyle = .none
        bind()
        getTipsRelay.accept(())
    }

    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension TipsViewController {
    private func bind() {
        output.content.asObservable()
            .subscribe(onNext: { data in
                self.tipsData = data
            })
            .disposed(by: disposeBag)
    }
    private func addSubViews() {
        [
            titleLabel,
            tipsTableView
        ].forEach({ view.addSubview($0) })
    }

    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leftMargin.equalTo(20)
            $0.topMargin.equalTo(15)
        }
        tipsTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension TipsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tipsData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "tipCell",
            for: indexPath
        ) as? TipsTableViewCell else { return UITableViewCell() }

        cell.titleLabel.text = tipsData[indexPath.row].title
        cell.contentLabel.text = tipsData[indexPath.row].content

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
