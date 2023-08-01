//
//  TrackersCollectionView.swift
//  Tracker
//
//  Created by Pavel Belenkow on 01.08.2023.
//

import UIKit

// MARK: - CollectionView class

final class TrackersCollectionView: UICollectionView {
    
    // MARK: - Properties
    
    private let params = GeometricParams(
        cellCount: 2,
        leftInset: 16,
        rightInset: 16,
        cellSpacing: 9
    )
    
    private weak var viewController: TrackersViewController?
    
    // MARK: - Initializers
    
    init(viewController: TrackersViewController, layout: UICollectionViewFlowLayout) {
        self.viewController = viewController
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = .clear
        
        dataSource = self
        delegate = self
        
        register(
            TrackerSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerSectionHeader.reuseIdentifier
        )
        
        register(
            TrackerCell.self,
            forCellWithReuseIdentifier: TrackerCell.reuseIdentifier
        )
        
        allowsMultipleSelection = false
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DataSource methods

extension TrackersCollectionView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewController?.getVisibleCategories().count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let trackers = viewController?.getVisibleCategories()[section].trackers
        return trackers?.count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cellData = viewController?.getVisibleCategories()
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.reuseIdentifier,
            for: indexPath
        )
        
        guard
            let tracker = cellData?[indexPath.section].trackers[indexPath.row],
            let trackerCell = cell as? TrackerCell,
            let isCompletedToday = viewController?.isTrackerCompletedToday(id: tracker.id, tracker: tracker),
            let completedDays = viewController?.getRecords(for: tracker).filter ({
                $0.trackerId == tracker.id
            }).count
        else {
            return UICollectionViewCell()
        }
        
        trackerCell.delegate = viewController
        trackerCell.configure(
            with: tracker,
            isCompletedToday: isCompletedToday,
            completedDays: completedDays,
            at: indexPath
        )
        
        return trackerCell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        let headerData = viewController?.getVisibleCategories()
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerSectionHeader.reuseIdentifier,
            for: indexPath
        )
        
        guard
            let headerView = view as? TrackerSectionHeader,
            let categoryTitle = headerData?[indexPath.section].title
        else {
            return UICollectionReusableView()
        }
        
        headerView.configure(from: categoryTitle)
        
        return headerView
    }
}

// MARK: - Delegate methods

extension TrackersCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        let cellHeight = CGFloat(integerLiteral: 148)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 12,
            left: params.leftInset,
            bottom: params.leftInset,
            right: params.rightInset
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        params.cellSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 24)
    }
}
