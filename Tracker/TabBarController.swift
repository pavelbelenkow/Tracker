//
//  TabBarController.swift
//  Tracker
//
//  Created by Pavel Belenkow on 23.06.2023.
//

import UIKit

//MARK: - TabBarController Class

final class TabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let borderView = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        borderView.backgroundColor = UIColor.TrackerColor.gray
        tabBar.addSubview(borderView)
        
        let trackersViewController = TrackersViewController()
        let statisticsViewController = StatisticsViewController()
        
        let trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsViewController)
        
        trackersNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("trackers.title", comment: "Title of the trackers item on the tab bar"),
            image: UIImage.TrackerIcon.records,
            tag: 0
        )
        statisticsNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("statistics.title", comment: "Title of the statistics item on the tab bar"),
            image: UIImage.TrackerIcon.statistics,
            tag: 1
        )
        
        self.viewControllers = [trackersNavigationController, statisticsNavigationController]
    }
}
