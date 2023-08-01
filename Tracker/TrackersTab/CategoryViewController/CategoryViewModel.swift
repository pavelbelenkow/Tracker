//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Pavel Belenkow on 31.07.2023.
//

import Foundation

// MARK: - CategoryViewModel class

final class CategoryViewModel {
    
    // MARK: - Properties
    
    @CategoryObservable
    private(set) var listOfCategories: [TrackerCategory] = []
    private(set) var selectedIndexPath: IndexPath?
    
    private let trackerCategoryStore: TrackerCategoryStoreProtocol
    
    var didUpdateCategories: ((TrackerCategoryStoreUpdate) -> Void)?
    var didSelectCategory: ((String?, IndexPath?) -> Void)?
    
    // MARK: - Initializers
    
    init(trackerCategoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore()) {
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerCategoryStore.setDelegate(self)
        listOfCategories = loadCategories()
    }
}

// MARK: - Methods

extension CategoryViewModel {
    
    func loadCategories() -> [TrackerCategory] {
        do {
            return try trackerCategoryStore.getCategories()
        } catch {
            assertionFailure("Failed to get categories with \(error)")
            return []
        }
    }
    
    func getSelectedCategory(from indexPath: IndexPath?) {
        selectedIndexPath = indexPath
        
        let categories = listOfCategories
        let categoryTitle = categories[indexPath?.row ?? 0].title
        
        didSelectCategory?(categoryTitle, indexPath)
    }
    
    func add(category: TrackerCategory) {
        do {
            try trackerCategoryStore.addCategory(category)
            listOfCategories = loadCategories()
        } catch {
            assertionFailure("Failed to add category with \(error)")
        }
    }
}

// MARK: - Delegate methods

extension CategoryViewModel: TrackerCategoryStoreDelegate {
    
    func didUpdate(_ update: TrackerCategoryStoreUpdate) {
        listOfCategories = loadCategories()
        didUpdateCategories?(update)
    }
}
