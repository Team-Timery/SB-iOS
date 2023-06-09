import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

// swiftlint: disable line_length
class TimerViewController: UIViewController {

    let disposeBag = DisposeBag()

    private var subjectList: [MySubjectEntity] = []
    private var todayTotalTime: Int = 0
    private let getSubjectListRelay = PublishRelay<Void>()
    private let deleteSubjectRelay = PublishRelay<Int>()

    private let timerTitleLabel = UILabel().then {
        $0.text = "타이머"
        $0.textColor = .grayDarken4
        $0.font = .miniTitle2Bold
    }

    private let subjectTableView = UITableView().then {
        $0.backgroundColor = .whiteElevated1
    }

    private let addSubjetcButton = UIButton(type: .system).then {
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.25
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.setImage(UIImage(named: "orange_plus"), for: .normal)
        $0.layer.cornerRadius = 35
        $0.backgroundColor = .white
        $0.tintColor = .mainElevated
    }
    private let timerHeaderView = TimerHeaderView()

    private let viewModel = TimerViewModel()
    lazy var input = TimerViewModel.Input(
        getSubjectList: getSubjectListRelay.asSignal(),
        deleteSubject: deleteSubjectRelay.asSignal()
    )
    lazy var output = viewModel.transform(input: input)

    override func viewDidLoad() {
        super.viewDidLoad()
        subjectTableView.delegate = self
        subjectTableView.dataSource = self
        subjectTableView.separatorStyle = .none
        subjectTableView.sectionHeaderTopPadding = 0
        subjectTableView.showsVerticalScrollIndicator = false
        let insetView = UIView()
        insetView.backgroundColor = .clear
        insetView.frame.size.height = 120
        subjectTableView.tableFooterView = insetView
        subjectTableView.register(SubjectsTableViewCell.self, forCellReuseIdentifier: "subjectCell")
        view.backgroundColor = .white
        bind()
    }

    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.getSubjectListRelay.accept(())
        self.subjectTableView.contentOffset.y = 0
//        timerHeaderView.frame.size.height = view.frame.height / 5.5
        subjectTableView.tableHeaderView = timerHeaderView
    }
}

extension TimerViewController: UITableViewDelegate, UITableViewDataSource, SubjectCellTapButtonDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjectList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = subjectTableView.dequeueReusableCell(
            withIdentifier: "subjectCell",
            for: indexPath
        ) as? SubjectsTableViewCell else { return UITableViewCell() }
        cell.timerLabel.text = subjectList[indexPath.row].todayRecord.toTimerString()
        cell.emojiLabel.text = subjectList[indexPath.row].emoji
        cell.subjectLabel.text = subjectList[indexPath.row].title
        cell.subjectID = subjectList[indexPath.row].id
        cell.indexPath = indexPath
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 110
        }
        return 95
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lineView = UIView()
        lineView.backgroundColor = .whiteElevated4
        return lineView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.5
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let timerView = TimerActivateViewController()
        timerView.timerSubjectEntity = subjectList[indexPath.row]
        timerView.todayStudyTime = todayTotalTime
        timerView.modalPresentationStyle = .fullScreen
        present(timerView, animated: true)
    }

    func deleteButtonTapped(id: Int, indexPath: IndexPath, title: String?) {
        let deleteAlert = DeleteSubjectAlertViewController(
            subjectName: title,
            completion: {
                self.subjectList.remove(at: indexPath.row)
                self.subjectTableView.deleteRows(at: [indexPath], with: .fade)
                self.subjectTableView.reloadData()
                self.deleteSubjectRelay.accept(id)
            }
        )
        present(deleteAlert, animated: false)
    }
}

extension TimerViewController {
    private func bind() {
        output.postData.asObservable()
            .subscribe(onNext: { data in
                guard let data = data else { return }
                self.timerHeaderView.timeText = data.totalTime.toTimerString()
                self.todayTotalTime = data.totalTime
                self.subjectList = data.subjectList
                self.subjectTableView.reloadData()
            })
            .disposed(by: disposeBag)

        output.reloadList
            .bind { self.getSubjectListRelay.accept(()) }
            .disposed(by: disposeBag)

        addSubjetcButton.rx.tap
            .bind { [unowned self] in
                let subjectAddAlert = AddSubjectAlertViewController(completion: {
                    self.getSubjectListRelay.accept(())
                })
                present(subjectAddAlert, animated: false)
            }
            .disposed(by: disposeBag)
    }
    private func addSubViews() {
        [
            timerTitleLabel,
            subjectTableView,
            addSubjetcButton
        ].forEach({ view.addSubview($0) })
    }

    private func makeConstraints() {
        timerTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset((view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0) + 7)
        }
        subjectTableView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().inset(view.safeAreaInsets.top + 13)
            $0.bottom.equalToSuperview()
        }
        addSubjetcButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(11)
            $0.bottom.equalToSuperview().inset(view.safeAreaInsets.bottom + 22)
            $0.width.height.equalTo(70)
        }
    }
}
// swiftlint: enable line_length
