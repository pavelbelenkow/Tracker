//
//  CreateTrackerTableView.swift
//  Tracker
//
//  Created by Pavel Belenkow on 01.08.2023.
//

import UIKit

// MARK: - TableView class

final class CreateTrackerTableView: UITableView {
    
    // MARK: - Properties
    
    private var viewModel: CategoryViewModel
    private weak var viewController: CreateTrackerViewController?
    
    // MARK: - Initializers
    
    init(viewModel: CategoryViewModel, viewController: CreateTrackerViewController) {
        self.viewModel = viewModel
        self.viewController = viewController
        super.init(frame: .zero, style: .plain)
        
        rowHeight = 75
        
        dataSource = self
        delegate = self
        
        register(
            SubtitleCell.self,
            forCellReuseIdentifier: SubtitleCell.reuseIdentifier
        )
        
        isScrollEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension CreateTrackerTableView {
    func configureCell(_ cell: SubtitleCell, at indexPath: IndexPath) {
        guard let viewController else { return }
        
        let titles = viewController.getTitles()
        let title = titles[indexPath.row]
        
        let categorySubtitle = viewController.getCategorySubtitle()
        let scheduleSubtitle = viewController.getScheduleSubtitle(from: viewController.getSchedule())
        
        let isFirstRow = indexPath.row == 0
        let isLastRow = indexPath.row == titles.count - 1
        
        cell.configure(
            with: title,
            categorySubtitle: categorySubtitle,
            scheduleSubtitle: scheduleSubtitle,
            isFirstRow: isFirstRow,
            isLastRow: isLastRow,
            separatorInset: self.bounds.width
        )
    }
    
    func presentViewController(for viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        self.viewController?.present(navigationController, animated: true)
    }
}

// MARK: - DataSource methods

extension CreateTrackerTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewController?.getTitles().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SubtitleCell.reuseIdentifier,
            for: indexPath
        )
        
        guard let subtitleCell = cell as? SubtitleCell else {
            return UITableViewCell()
        }
        
        configureCell(subtitleCell, at: indexPath)
        
        return subtitleCell
    }
}

// MARK: - Delegate methods

extension CreateTrackerTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController else { return }
        
        if indexPath.row == 0 {
            let categoryViewController = CategoryViewController(viewModel: viewModel)
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
