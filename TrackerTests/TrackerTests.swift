//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Pavel Belenkow on 07.08.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerCategoryStoreMock: TrackerCategoryStoreProtocol {
    
    private static var categories: [TrackerCategory] = [
        TrackerCategory(
            title: "Важное",
            trackers: [
                Tracker(
                    id: UUID(),
                    title: "Сходить к врачу",
                    color: UIColor.TrackerColor.colorSelection1,
                    emoji: "😪",
                    schedule: Weekday.allCases,
                    completedDays: 0
                )
            ]
        ),
        TrackerCategory(
            title: "Спорт",
            trackers: [
                Tracker(id: UUID(),
                        title: "Покататься на велосипеде",
                        color: UIColor.TrackerColor.colorSelection10,
                        emoji: "🥇",
                        schedule: Weekday.allCases,
                        completedDays: 0
                       )
            ]
        )
    ]
    
    func setDelegate(_ delegate: TrackerCategoryStoreDelegate) {}
    
    func getTrackerCategory(from coreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        TrackerCategory(title: "", trackers: [])
    }
    
    func getCategories() throws -> [TrackerCategory] {
        TrackerCategoryStoreMock.categories
    }
    
    func fetchTrackerCategoryCoreData(title: String) throws -> TrackerCategoryCoreData {
        TrackerCategoryCoreData()
    }
    
    func fetchCategoryCoreData(for category: TrackerCategory) throws -> TrackerCategoryCoreData {
        TrackerCategoryCoreData()
    }
    
    func addCategory(_ category: TrackerCategory) throws {}
    
    func getPinnedCategory() throws -> TrackerCategory {
        TrackerCategory(title: "", trackers: [])
    }
}

final class TrackersViewControllerTests: XCTestCase {
    
    func testViewControllerLightMode() {
        let viewController = TrackersViewController(trackerCategoryStore: TrackerCategoryStoreMock())
        assertSnapshot(matching: viewController, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testViewControllerDarkMode() {
        let viewController = TrackersViewController(trackerCategoryStore: TrackerCategoryStoreMock())
        assertSnapshot(matching: viewController, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}
