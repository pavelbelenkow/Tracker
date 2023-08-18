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
    
    private lazy var statisticsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = StatisticsCollectionView(viewController: self, layout: layout)
        return view
    }()
    
    private let trackerStore: TrackerStoreProtocol = TrackerStore()
    private let recordStore: TrackerRecordStoreProtocol = TrackerRecordStore()
    
    private var trackers: [TrackerCoreData] = []
    private var records: [TrackerRecordCoreData] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.TrackerColor.white
        addNavigationBar()
        addPlaceholderView()
        addStatisticsCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
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
    
    func addStatisticsCollectionView() {
        view.addSubview(statisticsCollectionView)
        
        NSLayoutConstraint.activate([
            statisticsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 77),
            statisticsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -34),
            statisticsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statisticsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}


// MARK: - Private methods

private extension StatisticsViewController {
    
    func checkData() {
        placeholderView.isHidden = !trackers.isEmpty
        statisticsCollectionView.isHidden = trackers.isEmpty
    }
    
    func loadData() {
        trackers = trackerStore.trackersCoreData
        records = recordStore.recordsCoreData
        statisticsCollectionView.reloadData()
        checkData()
    }
}

// MARK: - Methods

extension StatisticsViewController {
    
    func getRecords() -> [TrackerRecordCoreData] {
        records
    }
}
