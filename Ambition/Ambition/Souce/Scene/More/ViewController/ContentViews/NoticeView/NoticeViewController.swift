//
//  NoticeViewController.swift
//  Ambition
//
//  Created by 조병진 on 2023/03/09.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class NoticeViewController: UIViewController {
    
    private let titleLabel = UILabel().then {
        $0.text = "Notice"
        $0.textColor = .black
        $0.font = .title1Bold
    }
    
    private let noticeTableView = UITableView().then {
        $0.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        noticeTableView.delegate = self
        noticeTableView.dataSource = self
        noticeTableView.estimatedRowHeight = 90
        noticeTableView.rowHeight = UITableView.automaticDimension
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = noticeTableView.dequeueReusableCell(withIdentifier: "noticeCell", for: indexPath) as? NoticeTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = "앰비션이 10만 다운로드를 달생했어요."
        cell.subtitleLabel.text = "2023.07.31"
        
        return cell
    }
}
