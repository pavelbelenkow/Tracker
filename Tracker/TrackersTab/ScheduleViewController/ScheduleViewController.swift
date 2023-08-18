//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Pavel Belenkow on 02.07.2023.
//

import UIKit

// MARK: - ViewController class

final class ScheduleViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var scheduleTableView: UITableView = {
        let tableView = ScheduleTableView(viewController: self)
        return tableView
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        let localizedTitle = NSLocalizedString(
            "button.confirm.title",
            comment: "Title of the button confirming the action of selected days in the schedule screen"
        )
        button.configure(with: .standardButton, for: localizedTitle)
        button.backgroundColor = UIColor.TrackerColor.black
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let weekdayList: [Weekday] = Weekday.allCases
    
    var schedule: [Weekday] = []
    var selectedWeekdays: [Int : Bool] = [:]
    weak var delegate: UpdateTrackerInformationDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.TrackerColor.white

        addTopNavigationLabel()
        addConfirmButton()
        addScheduleTableView()
    }
    
    // MARK: - Methods
    
    func getWeekdays() -> [Weekday] {
        weekdayList
    }
    
    // MARK: - Objective-C methods
    
    @objc private func confirmButtonTapped() {
        delegate?.updateScheduleSubtitle(
            from: schedule,
            at: selectedWeekdays
        )
        
        dismiss(animated: true)
    }
}

// MARK: - Add Subviews

private extension ScheduleViewController {
    
    func addTopNavigationLabel() {
        let localizedTitle = NSLocalizedString(
            "schedule.title",
            comment: "Title of the schedule screen label in the navigation bar"
        )
        title = localizedTitle
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.TrackerFont.medium16,
            .foregroundColor: UIColor.TrackerColor.black
        ]
    }
    
    func addScheduleTableView() {
        view.addSubview(scheduleTableView)
        
        NSLayoutConstraint.activate([
            scheduleTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            scheduleTableView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -39),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func addConfirmButton() {
        view.addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            confirmButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}

