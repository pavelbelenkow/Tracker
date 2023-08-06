//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Pavel Belenkow on 23.06.2023.
//

import UIKit

// MARK: - Statistics ViewController Class

final class StatisticsViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var placeholderView: UIView = {
        PlaceholderView(
            image: UIImage.TrackerImage.emptyStatistics,
            title: NSLocalizedString(
                "placeholder.emptyStatistics.title",
                comment: "Title of the state with empty statistics"
            )
        )
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.TrackerColor.white
        addNavigationBar()
        addPlaceholderView()
    }
}

// MARK: - Add Subviews

private extension StatisticsViewController {
    
    func addNavigationBar() {
        let localizedTitle = NSLocalizedString(
            "statistics.title",
            comment: "Title of the statistics in the navigation bar"
        )
        navigationItem.title = localizedTitle
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func addPlaceholderView() {
        view.addSubview(placeholderView)
        
        NSLayoutConstraint.activate([
            placeholderView.widthAnchor.constraint(equalToConstant: 200),
            placeholderView.heightAnchor.constraint(equalToConstant: 200),
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
