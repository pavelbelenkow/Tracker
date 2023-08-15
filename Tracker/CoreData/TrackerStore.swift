//
//  TrackerStore.swift
//  Tracker
//
//  Created by Pavel Belenkow on 16.07.2023.
//

import UIKit
import CoreData

// MARK: - Error enumeration

private enum TrackerStoreError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidTitle
    case decodingErrorInvalidColor
    case decodingErrorInvalidEmoji
    case decodingErrorInvalidSchedule
    case decodingErrorInvalidRecords
    case failedToFetchTracker
}

// MARK: - TrackerStoreUpdate structure

struct TrackerStoreUpdate {
    struct Move: Hashable {
        let oldIndexPath: IndexPath
        let newIndexPath: IndexPath
    }
    let insertedSections: IndexSet
    let insertedIndexPaths: [IndexPath]
    let deletedSections: IndexSet
    let deletedIndexPaths: [IndexPath]
    let updatedSections: IndexSet
    let updatedIndexPaths: [IndexPath]
    let movedIndexPaths: Set<Move>
}

// MARK: - Protocols

protocol TrackerStoreDelegate: AnyObject {
    func didUpdate(_ update: TrackerStoreUpdate)
}

protocol TrackerStoreProtocol {
    func setDelegate(_ delegate: TrackerStoreDelegate)
    func getTracker(_ trackerCoreData: TrackerCoreData) throws -> Tracker
    func getTracker(by id: UUID) throws -> Tracker
    func addTracker(_ tracker: Tracker, with category: TrackerCategory) throws
    func isTrackerPinned(by id: UUID) -> Bool
    func pinTracker(_ tracker: Tracker) throws
    func unpinTracker(_ tracker: Tracker) throws
    func editTracker(_ tracker: Tracker, title: String, color: UIColor?, emoji: String, schedule: [Weekday]?, completedDays: Int, category: TrackerCategory) throws
    func deleteTracker(_ tracker: Tracker) throws
}

// MARK: - TrackerStore class

final class TrackerStore: NSObject {

    // MARK: - Properties

    private let context: NSManagedObjectContext
    private let uiColorMarshalling = UIColorMarshalling()

    private var insertedSections: IndexSet = []
    private var insertedIndexPaths: [IndexPath] = []
    private var deletedSections: IndexSet = []
    private var deletedIndexPaths: [IndexPath] = []
    private var updatedSections: IndexSet = []
    private var updatedIndexPaths: [IndexPath] = []
    private var movedIndexPaths: Set<TrackerStoreUpdate.Move> = []
    
    private lazy var trackerCategoryStore: TrackerCategoryStoreProtocol = {
        TrackerCategoryStore(context: context)
    }()
    
    private lazy var trackerRecordStore: TrackerRecordStoreProtocol = {
        TrackerRecordStore(context: context)
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        let trackerDescriptor = NSSortDescriptor(keyPath: \TrackerCoreData.title, ascending: true)
        let categoryDescriptor = NSSortDescriptor(keyPath: \TrackerCoreData.category?.title, ascending: false)
        
        request.sortDescriptors = [trackerDescriptor, categoryDescriptor]
        
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        
        try? controller.performFetch()
        return controller
    }()

    var trackers: [Tracker] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackers = try? objects.map({ try self.getTracker(from: $0) })
        else { return [] }
        return trackers
    }
    
    weak var delegate: TrackerStoreDelegate?

    // MARK: - Initializers

    convenience override init() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
}

// MARK: - Private methods

private extension TrackerStore {
    
    func saveContext() throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }

    func fetchTrackerCoreData(for tracker: Tracker) throws -> TrackerCoreData {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        let predicate = NSPredicate(format: "trackerId == %@", tracker.id as CVarArg)
        
        request.predicate = predicate
        
        guard let trackerCoreData = try context.fetch(request).first else {
            throw TrackerStoreError.failedToFetchTracker
        }
        
        return trackerCoreData
    }
    
    func getTracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.trackerId else {
            throw TrackerStoreError.decodingErrorInvalidId
        }

        guard let title = trackerCoreData.title else {
            throw TrackerStoreError.decodingErrorInvalidTitle
        }

        guard let colorString = trackerCoreData.color else {
            throw TrackerStoreError.decodingErrorInvalidColor
        }

        guard let emoji = trackerCoreData.emoji else {
            throw TrackerStoreError.decodingErrorInvalidEmoji
        }

        guard let scheduleString = trackerCoreData.schedule else {
            throw TrackerStoreError.decodingErrorInvalidSchedule
        }
        
        guard let completedDays = trackerCoreData.record?.count else {
            throw TrackerStoreError.decodingErrorInvalidRecords
        }

        let color = uiColorMarshalling.getColor(from: colorString)
        let schedule = Weekday.getWeekday(from: scheduleString)
        
        return Tracker(
            id: id,
            title: title,
            color: color,
            emoji: emoji,
            schedule: schedule,
            completedDays: completedDays
        )
    }

    func getTracker(trackerId: UUID) throws -> Tracker {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        let predicate = NSPredicate(format: "trackerId == %@", trackerId as CVarArg)
        
        request.predicate = predicate
        
        guard let trackerCoreData = try context.fetch(request).first else {
            throw TrackerStoreError.failedToFetchTracker
        }
        
        return try getTracker(from: trackerCoreData)
    }
    
    func addNewTracker(_ tracker: Tracker, with category: TrackerCategory) throws {
        let trackerCategoryCoreData = try trackerCategoryStore.fetchCategoryCoreData(for: category)
        let trackerCoreData = TrackerCoreData(context: context)

        trackerCoreData.trackerId = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.color = uiColorMarshalling.getHexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = Weekday.getString(from: tracker.schedule)
        trackerCoreData.originalCategoryTitle = category.title
        trackerCoreData.category = trackerCategoryCoreData
        
        try saveContext()
    }
    
    func isTrackerPinned(trackerId: UUID) -> Bool {
        do {
            let pinnedCategory = try trackerCategoryStore.getPinnedCategory()
            return pinnedCategory.trackers.contains { $0.id == trackerId }
        } catch {
            assertionFailure("Failed to find pinned tracker")
            return false
        }
    }
    
    func pinTracker(tracker: Tracker) throws {
        let trackerCoreData = try fetchTrackerCoreData(for: tracker)
        let pinnedCategory = try trackerCategoryStore.getPinnedCategory()
        
        let originalCategoryCoreData = trackerCoreData.category
        let pinnedCategoryCoreData = try trackerCategoryStore.fetchCategoryCoreData(for: pinnedCategory)
        
        if originalCategoryCoreData?.title != pinnedCategoryCoreData.title {
            originalCategoryCoreData?.removeFromTrackers(trackerCoreData)
            pinnedCategoryCoreData.addToTrackers(trackerCoreData)
            trackerCoreData.category = pinnedCategoryCoreData
        }
        
        try saveContext()
    }
    
    func unpinTracker(tracker: Tracker) throws {
        let trackerCoreData = try fetchTrackerCoreData(for: tracker)
        
        if let originalCategoryTitle = trackerCoreData.originalCategoryTitle {
            let originalCategoryCoreData = try trackerCategoryStore.fetchTrackerCategoryCoreData(title: originalCategoryTitle)
            let originalCategory = try trackerCategoryStore.getTrackerCategory(from: originalCategoryCoreData)
            
            let pinnedCategory = trackerCoreData.category
            let newCategory = try trackerCategoryStore.fetchCategoryCoreData(for: originalCategory)
            
            if pinnedCategory?.title != newCategory.title {
                pinnedCategory?.removeFromTrackers(trackerCoreData)
                newCategory.addToTrackers(trackerCoreData)
                trackerCoreData.category = newCategory
            }
        }
        
        try saveContext()
    }
    
    func editTracker(
        _ tracker: Tracker,
        with title: String,
        color: UIColor?,
        emoji: String,
        schedule: [Weekday]?,
        completedDays: Int,
        category: TrackerCategory
    ) throws {
        let trackerCoreData = try fetchTrackerCoreData(for: tracker)
        trackerCoreData.title = title
        trackerCoreData.originalCategoryTitle = category.title
        trackerCoreData.emoji = emoji
        trackerCoreData.color = uiColorMarshalling.getHexString(from: color)
        trackerCoreData.schedule = Weekday.getString(from: schedule)
        
        let previousCategoryCoreData = trackerCoreData.category
        let newCategoryCoreData = try trackerCategoryStore.fetchCategoryCoreData(for: category)
        
        if previousCategoryCoreData != newCategoryCoreData {
            previousCategoryCoreData?.removeFromTrackers(trackerCoreData)
            newCategoryCoreData.addToTrackers(trackerCoreData)
            
            trackerCoreData.category = newCategoryCoreData
        }
        
        try saveContext()
    }
    
    func deleteTracker(tracker: Tracker) throws {
        let trackerCoreData = try fetchTrackerCoreData(for: tracker)
        context.delete(trackerCoreData)
        try saveContext()
    }
}

// MARK: - Protocol methods

extension TrackerStore: TrackerStoreProtocol {
    
    func setDelegate(_ delegate: TrackerStoreDelegate) {
        self.delegate = delegate
    }
    
    func getTracker(_ trackerCoreData: TrackerCoreData) throws -> Tracker {
        try getTracker(from: trackerCoreData)
    }
    
    func getTracker(by id: UUID) throws -> Tracker {
        try getTracker(trackerId: id)
    }
    
    func addTracker(_ tracker: Tracker, with category: TrackerCategory) throws {
        try addNewTracker(tracker, with: category)
    }
    
    func isTrackerPinned(by id: UUID) -> Bool {
        isTrackerPinned(trackerId: id)
    }
    
    func pinTracker(_ tracker: Tracker) throws {
        try pinTracker(tracker: tracker)
    }
    
    func unpinTracker(_ tracker: Tracker) throws {
        try unpinTracker(tracker: tracker)
    }
    
    func editTracker(
        _ tracker: Tracker,
        title: String,
        color: UIColor?,
        emoji: String,
        schedule: [Weekday]?,
        completedDays: Int,
        category: TrackerCategory
    ) throws {
        try editTracker(
            tracker,
            with: title,
            color: color,
            emoji: emoji,
            schedule: schedule,
            completedDays: completedDays,
            category: category
        )
    }
    
    func deleteTracker(_ tracker: Tracker) throws {
        try deleteTracker(tracker: tracker)
    }
}

// MARK: - FetchedResultsController methods

extension TrackerStore: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedSections.removeAll()
        insertedIndexPaths.removeAll()
        deletedSections.removeAll()
        deletedIndexPaths.removeAll()
        updatedSections.removeAll()
        updatedIndexPaths.removeAll()
        movedIndexPaths.removeAll()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate(
            TrackerStoreUpdate(
                insertedSections: insertedSections,
                insertedIndexPaths: insertedIndexPaths,
                deletedSections: deletedSections,
                deletedIndexPaths: deletedIndexPaths,
                updatedSections: updatedSections,
                updatedIndexPaths: updatedIndexPaths,
                movedIndexPaths: movedIndexPaths
            )
        )
        
        insertedSections.removeAll()
        insertedIndexPaths.removeAll()
        deletedSections.removeAll()
        deletedIndexPaths.removeAll()
        updatedSections.removeAll()
        updatedIndexPaths.removeAll()
        movedIndexPaths.removeAll()
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange sectionInfo: NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for type: NSFetchedResultsChangeType
    ) {
        switch type {
        case .insert:
            insertedSections.insert(sectionIndex)
        case .delete:
            deletedSections.insert(sectionIndex)
        case .update:
            updatedSections.insert(sectionIndex)
        default:
            break
        }
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexPaths.append(indexPath)
            }
        case .delete:
            if let indexPath {
                deletedIndexPaths.append(indexPath)
            }
        case .update:
            if let indexPath {
                updatedIndexPaths.append(indexPath)
            }
        case .move:
            if let oldIndexPath = indexPath, let newIndexPath {
                movedIndexPaths.insert(.init(oldIndexPath: oldIndexPath, newIndexPath: newIndexPath))
            }
        default:
            break
        }
    }
}
