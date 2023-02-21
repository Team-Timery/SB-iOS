//
//  TapBarController.swift
//  Ambition
//
//  Created by 조병진 on 2023/02/21.
//

import UIKit

class TapBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = .black
        self.tabBar.unselectedItemTintColor = .whiteElevated3
        
        let timerVC = TimerViewController()
        timerVC.tabBarItem.title = "타이머"
        timerVC.tabBarItem.image = UIImage(named: "book")
        
        viewControllers = [timerVC]
    }
}
