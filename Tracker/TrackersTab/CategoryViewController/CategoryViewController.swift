//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Pavel Belenkow on 28.06.2023.
//

import UIKit

// MARK: - ViewController Class

final class CategoryViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var categoryTableView: UITableView = {
        let tableView = CategoryTableView(viewModel: viewModel)
        return tableView
    }()
    
    private lazy var appendCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        let localizedTitle = NSLocalizedString(
            "button.addCategory.title",
            comment: "Title of the button that adds a new category"
        )
        button.configure(with: .standardButton, for: localizedTitle)
        button.addTarget(self, action: #selector(appendCategoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var placeholderView: UIView = {
        PlaceholderView(
            image: UIImage.TrackerImage.emptyTrackers,
            title: NSLocalizedString(
                "placeholder.emptyCategories.title",
                comment: "Title of the label in the placeholder for empty number of categories"
            )
        )
    }()
    
    private let viewModel: CategoryViewModel
    
    // MARK: - Initializers
    
    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.TrackerColor.white
        
        viewModel.$listOfCategories.bind { [weak self] _ in
            self?.bind()
        }
        
        addSubviews()
        checkCategories()
        bind()
    }
}

// MARK: - Add Subviews

private extension CategoryViewController {
    
    func addSubviews() {
        addTopNavigationLabel()
        addPlaceholderView()
        addAppendCategoryButton()
        addCategoryTableView()
    }
    
    func addTopNavigationLabel() {
        let localizedTitle = NSLocalizedString(
            "category.title",
            comment: "Title of the categories screen label in the navigation bar"
        )
        title = localizedTitle
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.TrackerFont.medium16,
            .foregroundColor: UIColor.TrackerColor.black
        ]
    }
    
    func addCategoryTableView() {
        view.addSubview(categoryTableView)
        
        NSLayoutConstraint.activate([
            categoryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryTableView.bottomAnchor.constraint(equalTo: appendCategoryButton.topAnchor, constant: -16),
            categoryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func addPlaceholderView() {
        view.addSubview(placeholderView)
        
        NSLayoutConstraint.activate([
            placeholderView.widthAnchor.constraint(equalToConstant: 200),
            placeholderView.heightAnchor.constraint(equalToConstant: 200),
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func addAppendCategoryButton() {
        view.addSubview(appendCategoryButton)
        
        NSLayoutConstraint.activate([
            appendCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            appendCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            appendCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - Private methods

private extension CategoryViewController {
    
    func checkCategories() {
        placeholderView.isHidden = !viewModel.listOfCategories.isEmpty
        categoryTableView.isHidden = viewModel.listOfCategories.isEmpty
    }
    
    func bind() {
        viewModel.didUpdateCategories = { [weak self] update in
            guard let self else { return }
            
            self.checkCategories()
            self.categoryTableView.performBatchUpdates {
                self.categoryTableView.insertRows(at: update.insertedIndexPaths, with: .automatic)
                self.categoryTableView.deleteRows(at: update.deletedIndexPaths, with: .automatic)
            }
        }
    }
    
    @objc func appendCategoryButtonTapped() {
        let createCategoryViewController = CreateCategoryViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: createCategoryViewController)
        present(navigationController, animated: true)
    }
}
