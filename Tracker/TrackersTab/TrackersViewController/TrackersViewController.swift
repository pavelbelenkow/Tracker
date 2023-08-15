//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Pavel Belenkow on 16.06.2023.
//

import UIKit

//MARK: - ViewController class

final class TrackersViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var addTrackerButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor.TrackerColor.black
        button.setImage(UIImage.TrackerIcon.add, for: .normal)
        button.addTarget(self, action: #selector(addTrackerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = .current
        datePicker.calendar.firstWeekday = 2
        datePicker.layer.cornerRadius = 8
        datePicker.clipsToBounds = true
        datePicker.addTarget(self, action: #selector(datePickerDateChanged), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.heightAnchor.constraint(equalToConstant: 34).isActive = true
        datePicker.widthAnchor.constraint(equalToConstant: 110).isActive = true
        return datePicker
    }()
    
    private lazy var searchBar: TrackerSearchBar = {
        let searchBar = TrackerSearchBar()
        searchBar.delegate = self
        searchBar.searchTextField.addTarget(self, action: #selector(searchBarTapped), for: .editingDidEndOnExit)
        return searchBar
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        recognizer.cancelsTouchesInView = false
        return recognizer
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = TrackersCollectionView(viewController: self, layout: layout)
        return view
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        let localizedTitle = NSLocalizedString(
            "button.filters.title",
            comment: "Title of the tracker filtering button"
        )
        button.backgroundColor = UIColor.TrackerColor.blue
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.tintColor = UIColor.TrackerColor.white
        button.setTitle(localizedTitle, for: .normal)
        button.titleLabel?.font = UIFont.TrackerFont.regular17
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var placeholderView: UIView = {
        PlaceholderView(
            image: UIImage.TrackerImage.emptyTrackers,
            title: NSLocalizedString(
                "placeholder.emptyTrackers.title",
                comment: "Title of the state with empty trackers"
            )
        )
    }()
    
    private lazy var filteredPlaceholderView: UIView = {
        PlaceholderView(
            image: UIImage.TrackerImage.nothingFound,
            title: NSLocalizedString(
                "placeholder.nothingFound.title",
                comment: "Title of the state with empty filtered trackers"
            )
        )
    }()
    
    private let trackerStore: TrackerStoreProtocol = TrackerStore()
    private let trackerCategoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore()
    private let trackerRecordStore: TrackerRecordStoreProtocol = TrackerRecordStore()
    
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var currentDate: Date?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.TrackerColor.white
        
        trackerStore.setDelegate(self)
        
        addSubviews()
        reloadData()
    }
}

// MARK: - Add Subviews

private extension TrackersViewController {
    
    func addSubviews() {
        addNavigationBar()
        addSearchTrackersTextField()
        addFilterButton()
        addTrackersCollectionView()
        addPlaceholderView(placeholderView)
    }
    
    func addNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addTrackerButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        let localizedTitle = NSLocalizedString(
            "trackers.title",
            comment: "Title of the trackers on the navigation bar"
        )
        title = localizedTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: UIFont.TrackerFont.bold34,
            .foregroundColor: UIColor.TrackerColor.black
        ]
    }
    
    func addSearchTrackersTextField() {
        view.addSubview(searchBar)
        view.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
    }
    
    func addTrackersCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 34),
            collectionView.bottomAnchor.constraint(equalTo: filterButton.topAnchor, constant: -16),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func addFilterButton() {
        view.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func addPlaceholderView(_ placeholder: UIView) {
        view.addSubview(placeholder)
        
        NSLayoutConstraint.activate([
            placeholder.widthAnchor.constraint(equalToConstant: 200),
            placeholder.heightAnchor.constraint(equalToConstant: 200),
            placeholder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholder.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Private methods

private extension TrackersViewController {
    
    func reloadData() {
        do {
            categories = try trackerCategoryStore.getCategories()
        } catch {
            assertionFailure("Failed to get categories with \(error)")
        }
        datePickerDateChanged()
    }
    
    func updatePlaceholderViews() {
        if !categories.isEmpty && visibleCategories.isEmpty {
            addPlaceholderView(filteredPlaceholderView)
            filterButton.isHidden = false
            placeholderView.isHidden = true
            collectionView.isHidden = true
        } else if categories.isEmpty {
            placeholderView.isHidden = false
            filteredPlaceholderView.isHidden = true
        } else {
            placeholderView.isHidden = true
            collectionView.isHidden = false
        }
        
        filteredPlaceholderView.isHidden = !visibleCategories.isEmpty
        filterButton.isHidden = visibleCategories.isEmpty
    }
    
    func filterCategories() -> [TrackerCategory] {
        currentDate = datePicker.date
        let calendar = Calendar.current
        let filterWeekday = calendar.component(.weekday, from: currentDate ?? Date())
        let filterText = (searchBar.searchTextField.text ?? "").lowercased()
        
        return categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty ||
                tracker.title.lowercased().contains(filterText)
                
                let dateCondition = tracker.schedule?.contains { weekday in
                    weekday.weekdayNumber == filterWeekday
                } ?? false
                
                return textCondition && dateCondition
            }
            
            if trackers.isEmpty {
                return nil
            }
            
            return TrackerCategory(title: category.title, trackers: trackers)
        }
    }
    
    func reloadVisibleCategories() {
        visibleCategories = filterCategories()
        updatePlaceholderViews()
        collectionView.reloadData()
    }
    
    func presentTrackerViewController(
        for tracker: Tracker,
        with category: TrackerCategory?,
        isTrackerCompleteToday: Bool
    ) {
        let isRegular = tracker.schedule != Weekday.allCases ? true : false
        
        let viewController = CreateTrackerViewController(
            tracker: tracker,
            category: category,
            isCompletedToday: isTrackerCompleteToday,
            isRegular: isRegular,
            isEditViewController: true
        )
        viewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
    
    func pinTracker(by id: UUID) {
        do {
            let tracker = try trackerStore.getTracker(by: id)
            try trackerStore.pinTracker(tracker)
            reloadData()
        } catch {
            assertionFailure("Failed to pin tracker with \(error)")
        }
    }
    
    func unpinTracker(by id: UUID) {
        do {
            let tracker = try trackerStore.getTracker(by: id)
            try trackerStore.unpinTracker(tracker)
            reloadData()
        } catch {
            assertionFailure("Failed to unpin tracker with \(error)")
        }
    }
    
    func editTracker(by id: UUID) {
        do {
            let tracker = try trackerStore.getTracker(by: id)
            let trackerCategory = categories.first(where: { $0.trackers.contains(where: { $0.id == id }) })
            let isTrackerCompletedToday = isTrackerCompletedToday(id: id, tracker: tracker)
            
            presentTrackerViewController(
                for: tracker,
                with: trackerCategory,
                isTrackerCompleteToday: isTrackerCompletedToday
            )
        } catch {
            assertionFailure("Failed to edit tracker with \(error)")
        }
    }
}

// MARK: - Objective-C methods

private extension TrackersViewController {
    
    @objc func addTrackerButtonTapped() {
        let trackerTypeViewController = TrackerTypeViewController()
        trackerTypeViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: trackerTypeViewController)
        present(navigationController, animated: true)
    }
    
    @objc func datePickerDateChanged() {
        reloadVisibleCategories()
    }
    
    @objc func searchBarTapped() {
        reloadVisibleCategories()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func filterButtonTapped() {
        print("Filter button tapped")
    }
}

// MARK: - Methods

extension TrackersViewController {
    
    func getVisibleCategories() -> [TrackerCategory] {
        visibleCategories
    }
    
    func getRecords(for tracker: Tracker) -> [TrackerRecord] {
        do {
            return try trackerRecordStore.fetchRecords(for: tracker)
        } catch {
            assertionFailure("Failed to get records for tracker")
            return []
        }
    }
}

// MARK: - SearchBarDelegate methods

extension TrackersViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        reloadVisibleCategories()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        reloadVisibleCategories()
        searchBar.resignFirstResponder()
    }
}

// MARK: - TrackerCellDelegate methods

extension TrackersViewController: TrackerCellDelegate {
    
    private func isSameTrackerRecord(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        currentDate = datePicker.date
        
        let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: currentDate ?? Date())
        return trackerRecord.trackerId == id && isSameDay
    }
    
    func isTrackerCompletedToday(id: UUID, tracker: Tracker) -> Bool {
        do {
            return try trackerRecordStore.fetchRecords(for: tracker).contains { trackerRecord in
                isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
            }
        } catch {
            assertionFailure("Failed to get records for tracker")
            return false
        }
    }
    
    func getSelectedDate() -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: datePicker.date)
        guard let selectedDate = calendar.date(from: dateComponents) else { return Date() }
        return selectedDate
    }
    
    func isPinnedTracker(by trackerId: UUID) -> Bool {
        trackerStore.isTrackerPinned(by: trackerId)
    }
    
    func reloadTrackersWithCategory() {
        reloadData()
    }
    
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(trackerId: id, date: getSelectedDate())
        try? trackerRecordStore.addRecord(with: trackerRecord.trackerId, by: trackerRecord.date)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(trackerId: id, date: getSelectedDate())
        try? trackerRecordStore.deleteRecord(with: trackerRecord.trackerId, by: trackerRecord.date)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func updateTracker(_ tracker: Tracker, with completedDays: Int) {
        let trackerRecords = try? trackerRecordStore.fetchRecords(for: tracker)
        let trackerRecordDate = trackerRecords?.first(where: { $0.trackerId == tracker.id })
        let isCompletedToday = isTrackerCompletedToday(id: tracker.id, tracker: tracker)
        
        if tracker.completedDays != completedDays {
            if isCompletedToday {
                try? trackerRecordStore.deleteRecord(with: tracker.id, by: trackerRecordDate?.date ?? Date())
            } else {
                try? trackerRecordStore.addRecord(with: tracker.id, by: trackerRecordDate?.date ?? Date())
            }
        }
    }
}

// MARK: - ContextMenuInteractionDelegate methods

extension TrackersViewController: ContextMenuInteractionDelegate {
    
    func contextMenuConfiguration(for trackerId: UUID) -> UIContextMenuConfiguration? {
        let pinAction = UIAction(title: "Закрепить") { [weak self] _ in
            guard let self else { return }
            self.pinTracker(by: trackerId)
        }
        
        let unpinAction = UIAction(title: "Открепить") { [weak self] _ in
            guard let self else { return }
            self.unpinTracker(by: trackerId)
        }
        
        let editAction = UIAction(title: "Редактировать") { [weak self] _ in
            guard let self else { return }
            self.editTracker(by: trackerId)
        }
        
        let deleteAction = UIAction(title: "Удалить", attributes: .destructive) { _ in
            print("Tapped DELETE for tracker")
        }
        
        let isTrackerPinned = trackerStore.isTrackerPinned(by: trackerId)
        
        var menuItems: [UIAction] = []
        if isTrackerPinned {
            menuItems = [unpinAction, editAction, deleteAction]
        } else {
            menuItems = [pinAction, editAction, deleteAction]
        }
        
        let menu = UIMenu(children: menuItems)
        
        return UIContextMenuConfiguration(actionProvider: { _ in menu })
    }
}

// MARK: - TrackerStoreDelegate methods

extension TrackersViewController: TrackerStoreDelegate {
    
    func didUpdate(_ update: TrackerStoreUpdate) {
        collectionView.performBatchUpdates {
            collectionView.insertSections(update.insertedSections)
            collectionView.insertItems(at: update.insertedIndexPaths)
            
            collectionView.deleteSections(update.deletedSections)
            collectionView.deleteItems(at: update.deletedIndexPaths)
            
            collectionView.reloadSections(update.updatedSections)
            collectionView.reloadItems(at: update.updatedIndexPaths)
            
            for move in update.movedIndexPaths {
                collectionView.moveItem(at: move.oldIndexPath, to: move.newIndexPath)
            }
        }
    }
}
