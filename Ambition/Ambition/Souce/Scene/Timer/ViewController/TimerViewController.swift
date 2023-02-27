//
//  TimerViewController.swift
//  Ambition
//
//  Created by 조병진 on 2023/02/20.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class TimerViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    private let timerTitleLabel = UILabel().then {
        $0.text = "타이머"
        $0.textColor = .black
        $0.font = .title2Bold
    }
    
    private let subjectTableView = UITableView().then {
        $0.backgroundColor = .whiteElevated1
    }
    
    private let addSubjetcButton = UIButton(type: .system).then {
        $0.layer.shadowColor = UIColor.gray.cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.setImage(UIImage(named: "orange_plus"), for: .normal)
        $0.layer.cornerRadius = 40
        $0.backgroundColor = .white
        $0.tintColor = .mainElevated
    }
    
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
    }
    
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let timerHeaderView = TimerHeaderView(timerText: "01:10:23")
        timerHeaderView.frame.size.height = view.frame.height / 4.5
        subjectTableView.tableHeaderView = timerHeaderView
        self.subjectTableView.contentOffset.y = 0
    }
}

extension TimerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = subjectTableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath) as? SubjectsTableViewCell else { return UITableViewCell() }
        cell.subjectLabel.text = "수학 \(indexPath.row)"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0) {
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
        if(scrollView.contentOffset.y < 0) {
            scrollView.contentOffset.y = 0
        }
    }
}

extension TimerViewController {
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
            $0.right.equalToSuperview().inset(22)
            $0.bottom.equalToSuperview().inset(view.safeAreaInsets.bottom + 22)
            $0.width.height.equalTo(80)
        }
    }
}
