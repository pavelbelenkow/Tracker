//
//  StatisticsCollectionView.swift
//  Tracker
//
//  Created by Pavel Belenkow on 15.08.2023.
//

import UIKit

// MARK: - CollectionView class

final class StatisticsCollectionView: UICollectionView {

    // MARK: - Properties

    private let bestPeriodTitle = NSLocalizedString(
        "statistics.bestPeriod.title",
        comment: "Title of the best period of the statistics table cell"
    )
    private let perfectDaysTitle = NSLocalizedString(
        "statistics.perfectDays.title",
        comment: "Title of the perfect days of the statistics table cell"
    )
    private let completedTrackersTitle = NSLocalizedString(
        "statistics.completedTrackers.title",
        comment: "Title of the completed trackers of the statistics table cell"
    )
    private let averageValueTitle = NSLocalizedString(
        "statistics.averageValue.title",
        comment: "Title of the average value of the statistics table cell"
    )

    private lazy var descriptions: [String] = {
        [bestPeriodTitle, perfectDaysTitle,
         completedTrackersTitle, averageValueTitle]
    }()

    private weak var viewController: StatisticsViewController?

    // MARK: - Initializers

    init(viewController: StatisticsViewController, layout: UICollectionViewFlowLayout) {
        self.viewController = viewController
        super.init(frame: .zero, collectionViewLayout: layout)

        backgroundColor = .clear

        dataSource = self
        delegate = self

        register(
            StatisticsCell.self,
            forCellWithReuseIdentifier: StatisticsCell.reuseIdentifier
        )

        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DataSource methods

extension StatisticsCollectionView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        descriptions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StatisticsCell.reuseIdentifier,
            for: indexPath
        )

        guard
            let viewController,
            let statisticsCell = cell as? StatisticsCell
        else {
            return UICollectionViewCell()
        }

        var title: String
        let description = descriptions[indexPath.row]

        switch indexPath.row {
        case 2:
            title = "\(viewController.getRecords().count)"
        default:
            title = "0"
        }

        statisticsCell.configure(with: title, description: description)

        return statisticsCell
    }
}

// MARK: - Delegate methods

extension StatisticsCollectionView: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.bounds.width
        let height: CGFloat = 90

        return CGSize(width: width, height: height)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        12
    }
}
