//
//  TrackerTypeViewController.swift
//  Tracker
//
//  Created by Pavel Belenkow on 28.06.2023.
//

import UIKit

// MARK: - ViewController Class

final class TrackerTypeViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var regularTrackerButton: UIButton = {
        let button = UIButton(type: .system)
        let localizedTitle = NSLocalizedString(
            "button.regularEvent.title",
            comment: "Title of the habit button"
        )
        button.configure(with: .standardButton, for: localizedTitle)
        button.addTarget(self, action: #selector(regularTrackerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var irregularTrackerButton: UIButton = {
        let button = UIButton(type: .system)
        let localizedTitle = NSLocalizedString(
            "button.irregularEvent.title",
            comment: "Title of the irregular event button"
        )
        button.configure(with: .standardButton, for: localizedTitle)
        button.addTarget(self, action: #selector(irregularTrackerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: TrackerCellDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.TrackerColor.white
        
        addTopNavigationLabel()
        addRegularTrackerButton()
        addIrregularTrackerButton()
    }
}

// MARK: - Add Subviews

private extension TrackerTypeViewController {
    
    func addTopNavigationLabel() {
        let localizedTitle = NSLocalizedString(
            "navBar.newTracker.title",
            comment: "Title of the tracker's type selection in navigation bar"
        )
        title = localizedTitle
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.TrackerFont.medium16,
            .foregroundColor: UIColor.TrackerColor.black
        ]
    }
    
    func addRegularTrackerButton() {
        view.addSubview(regularTrackerButton)
        
        NSLayoutConstraint.activate([
            regularTrackerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            regularTrackerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            regularTrackerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func addIrregularTrackerButton() {
        view.addSubview(irregularTrackerButton)
        
        NSLayoutConstraint.activate([
            irregularTrackerButton.topAnchor.constraint(equalTo: regularTrackerButton.bottomAnchor, constant: 16),
            irregularTrackerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            irregularTrackerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - Objective-C methods

private extension TrackerTypeViewController {
    
    @objc func regularTrackerButtonTapped() {
        let regularTrackerViewController = CreateTrackerViewController(isRegular: true)
        regularTrackerViewController.delegate = delegate
        
        let navigationController = UINavigationController(rootViewController: regularTrackerViewController)
        present(navigationController, animated: true)
    }
    
    @objc func irregularTrackerButtonTapped() {
        let irregularTrackerViewController = CreateTrackerViewController(isRegular: false)
        irregularTrackerViewController.delegate = delegate
        
        let navigationController = UINavigationController(rootViewController: irregularTrackerViewController)
        present(navigationController, animated: true)
    }
}
