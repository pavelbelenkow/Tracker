//
//  ScheduleTableView.swift
//  Tracker
//
//  Created by Pavel Belenkow on 01.08.2023.
//

import UIKit

// MARK: - TableView class

final class ScheduleTableView: UITableView {
    
    // MARK: - Properties
    
    private weak var viewController: ScheduleViewController?
    
    // MARK: - Initializers
    
    init(viewController: ScheduleViewController) {
        self.viewController = viewController
        super.init(frame: .zero, style: .plain)
        
        rowHeight = 75
        dataSource = self
        
        register(
            WeekdayCell.self,
            forCellReuseIdentifier: WeekdayCell.reuseIdentifier
        )
        
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension ScheduleTableView {
    
    func configureCell(_ cell: WeekdayCell, at indexPath: IndexPath) {
        guard let viewController else { return }
        
        let title = viewController.getWeekdays()[indexPath.row].rawValue
        let isFirstRow = indexPath.row == 0
        let isLastRow = indexPath.row == viewController.getWeekdays().count - 1
        
        cell.configure(
            with: title,
            isFirstRow: isFirstRow,
            isLastRow: isLastRow,
            separatorInset: self.bounds.width
        )
        
        cell.switchWeekday.tag = indexPath.row
        cell.switchWeekday.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        if let weekday = viewController.selectedWeekdays[indexPath.row] {
            cell.switchWeekday.setOn(weekday, animated: true)
        } else {
            cell.switchWeekday.setOn(false, animated: false)
        }
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        guard let viewController else { return }
        
        let weekdays = Weekday.allCases
        
        // Update the selected weekdays dictionary
        viewController.selectedWeekdays[sender.tag] = sender.isOn
        
        // Update the schedule array based on the selected weekdays
        viewController.schedule = weekdays.enumerated().compactMap { index, weekday in
            viewController.selectedWeekdays[index] == true ? weekday : nil
        }
    }
}

// MARK: - DataSource methods

extension ScheduleTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewController?.getWeekdays().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: WeekdayCell.reuseIdentifier,
            for: indexPath
        )
        
        guard let weekdayCell = cell as? WeekdayCell else {
            return UITableViewCell()
        }
        
        configureCell(weekdayCell, at: indexPath)
        
        return weekdayCell
    }
}
