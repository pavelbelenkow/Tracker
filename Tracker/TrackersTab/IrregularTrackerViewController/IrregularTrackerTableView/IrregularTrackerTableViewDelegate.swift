//
//  IrregularTrackerTableViewDelegate.swift
//  Tracker
//
//  Created by Pavel Belenkow on 08.07.2023.
//

import UIKit

// MARK: - Irregular Tracker TableViewDelegate Class

final class IrregularTrackerTableViewDelegate: NSObject & UITableViewDelegate {
    
    // MARK: - Properties
    
    private weak var viewController: IrregularTrackerViewController?
    private var viewModel: CategoryViewModel
    
    // MARK: - Initializers
    
    init(viewController: IrregularTrackerViewController, viewModel: CategoryViewModel = CategoryViewModel()) {
        self.viewController = viewController
        self.viewModel = viewModel
    }
    
    // MARK: - Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController else { return }
        
        let categoryViewController = CategoryViewController(viewModel: viewModel)
        viewModel.getSelectedCategory(from: viewController.indexCategory)
        
        let navigationController = UINavigationController(rootViewController: categoryViewController)
        viewController.present(navigationController, animated: true)
    }
}
