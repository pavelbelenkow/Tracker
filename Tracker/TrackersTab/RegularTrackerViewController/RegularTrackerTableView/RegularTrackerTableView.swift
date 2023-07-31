//
//  RegularTrackerTableView.swift
//  Tracker
//
//  Created by Pavel Belenkow on 31.07.2023.
//

import UIKit

final class RegularTrackerTableView: UITableView {
    
    private var viewModel: CategoryViewModel
    private weak var viewController: RegularTrackerViewController?
    
    init(viewModel: CategoryViewModel, viewController: RegularTrackerViewController) {
        self.viewModel = viewModel
        self.viewController = viewController
        super.init(frame: .zero, style: .plain)
        
        rowHeight = 75
        
        dataSource = self
        delegate = self
        
        register(
            RegularTrackerTableViewSubtitleCell.self,
            forCellReuseIdentifier: RegularTrackerTableViewSubtitleCell.reuseIdentifier
        )
        
        isScrollEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension RegularTrackerTableView {
    
    func configureCell(_ cell: RegularTrackerTableViewSubtitleCell, at indexPath: IndexPath) {
        guard let viewController else { return }
        
        let titles = viewController.getTitles()
        let title = titles[indexPath.row]
        
        let categorySubtitle = viewController.getCategorySubtitle()
        let scheduleSubtitle = viewController.getScheduleSubtitle(from: viewController.getSchedule())
        
        let isFirstRow = indexPath.row == 0
        
        cell.configure(
            with: title,
            categorySubtitle: categorySubtitle,
            scheduleSubtitle: scheduleSubtitle,
            isFirstRow: isFirstRow
        )
    }
    
    func presentViewController(for viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        self.viewController?.present(navigationController, animated: true)
    }
}

extension RegularTrackerTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewController?.getTitles().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: RegularTrackerTableViewSubtitleCell.reuseIdentifier,
            for: indexPath
        )
        
        guard let itemCell = cell as? RegularTrackerTableViewSubtitleCell else {
            return UITableViewCell()
        }
        
        configureCell(itemCell, at: indexPath)
        
        return itemCell
    }
}

extension RegularTrackerTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController else { return }
        
        if indexPath.row == 0 {
            let categoryViewController = CategoryViewController(viewModel: viewModel)
            viewModel.getSelectedCategory(from: viewController.indexCategory)
            presentViewController(for: categoryViewController)
        } else {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.delegate = viewController
            scheduleViewController.schedule = viewController.getSchedule()
            scheduleViewController.selectedWeekdays = viewController.getSelectedWeekdays()
            presentViewController(for: scheduleViewController)
        }
    }
}
