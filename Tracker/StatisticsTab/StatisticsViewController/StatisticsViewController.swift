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
    
    private let placeholderView: UIView = {
        let view = PlaceholderView(
            image: UIImage.TrackerIcon.emptyStatistics,
            title: "Анализировать пока нечего"
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        navigationItem.title = "Статистика"
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