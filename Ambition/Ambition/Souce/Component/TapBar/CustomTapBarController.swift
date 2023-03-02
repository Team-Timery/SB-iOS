//
//  TapBarController.swift
//  Ambition
//
//  Created by 조병진 on 2023/02/21.
//

import UIKit

class CustomTapBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
        
        let timerVC = TimerViewController()
        timerVC.tabBarItem.title = "타이머"
        timerVC.tabBarItem.image = UIImage(named: "tabbar_timer")
        
        let recordVC = TimerViewController()
        recordVC.tabBarItem.title = "측정 기록"
        recordVC.tabBarItem.image = UIImage(named: "tabbar_record")
        
        let analyzeVC = AnalyzeViewController()
        analyzeVC.tabBarItem.title = "분석"
        analyzeVC.tabBarItem.image = UIImage(named: "tabbar_analyze")
        
        let moreVC = TimerActivateViewController()
        moreVC.tabBarItem.title = "더보기"
        moreVC.tabBarItem.image = UIImage(named: "tabbar_more")
        
        viewControllers = [
            timerVC,
            recordVC,
            analyzeVC,
            moreVC
        ]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = self.tabBar.frame
        let customHeight = 61 + self.view.safeAreaInsets.bottom
        tabFrame.size.height = customHeight
        tabFrame.origin.y = self.view.frame.size.height - customHeight
        self.tabBar.frame = tabFrame
    }
}

extension CustomTapBarController {
    private func setUpTabBar() {
        let fontAttributes = [NSAttributedString.Key.font: UIFont.indicator]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes as [NSAttributedString.Key : Any], for: .normal)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
        UITabBar.appearance().backgroundColor = .white
        self.tabBar.tintColor = .black
        self.tabBar.unselectedItemTintColor = .whiteElevated3
        self.tabBar.layer.borderWidth = 1
        self.tabBar.layer.borderColor = UIColor.whiteElevated2?.cgColor
    }
}
