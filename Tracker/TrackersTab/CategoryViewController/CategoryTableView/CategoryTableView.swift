//
//  CategoryTableView.swift
//  Tracker
//
//  Created by Pavel Belenkow on 30.07.2023.
//

import UIKit

// MARK: - CategoryTableView class

final class CategoryTableView: UITableView {
    
    // MARK: - Properties
    
    private var viewModel: CategoryViewModel
    
    // MARK: - Initializers
    
    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero, style: .plain)
        
        backgroundColor = .clear
        rowHeight = 75
        
        dataSource = self
        delegate = self
        
        register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseIdentifier)
        
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented ")
    }
}

// MARK: - Private methods

private extension CategoryTableView {
    
    func configureCell(_ cell: CategoryCell, at indexPath: IndexPath) {
        let categories = viewModel.listOfCategories
        let category = categories[indexPath.row]
        
        let isFirstRow = indexPath.row == 0
        let isLastRow = indexPath.row == categories.count - 1
        let isCellSelected = indexPath == viewModel.selectedIndexPath
        
        cell.configure(
            with: category.title,
            isFirstRow: isFirstRow,
            isLastRow: isLastRow,
            isSelected: isCellSelected,
            separatorInset: self.bounds.width
        )
    }
}

// MARK: - DataSource methods

extension CategoryTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.listOfCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryCell.reuseIdentifier,
            for: indexPath
        )
        
        guard let categoryCell = cell as? CategoryCell else {
            return UITableViewCell()
        }
        
        configureCell(categoryCell, at: indexPath)
        
        return categoryCell
    }
}

// MARK: - Delegate methods

extension CategoryTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedIndexPath.flatMap { tableView.cellForRow(at: $0) }?.accessoryType = .none
        
        if let selectedCategory = viewModel.getSelectedCategory(from: indexPath) {
            viewModel.didSelectCategory?(selectedCategory.title, viewModel.selectedIndexPath)
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
            NotificationCenter.default
                .post(
                    name: Notification.Name("dismissCategoryViewController"),
                    object: nil
                )
        }
    }
}
