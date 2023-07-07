//
//  TrackerSearchBar.swift
//  Tracker
//
//  Created by Pavel Belenkow on 28.06.2023.
//

import UIKit

// MARK: - Tracker SearchBar Class

final class TrackerSearchBar: UISearchBar {
    
    // MARK: - Properties
    
    weak var viewController: TrackersViewController?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.searchBarStyle = .minimal
        self.returnKeyType = .go
        self.searchTextField.clearButtonMode = .never
        self.placeholder = "Поиск"
        self.delegate = self
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Delegate methods

extension TrackerSearchBar: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        viewController?.reloadVisibleCategories()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewController?.reloadVisibleCategories()
        searchBar.resignFirstResponder()
    }
}
