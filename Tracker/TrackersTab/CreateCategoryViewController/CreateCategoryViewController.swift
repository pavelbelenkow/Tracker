//
//  CreateCategoryViewController.swift
//  Tracker
//
//  Created by Pavel Belenkow on 03.07.2023.
//

import UIKit

// MARK: - ViewController Class

final class CreateCategoryViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var categoryTitleTextField: UITextField = {
        let textField = UITextField()
        let localizedTitle = NSLocalizedString(
            "textField.category.title",
            comment: "Placeholder title of the text field for typing the category name"
        )
        textField.configure(with: localizedTitle)
        textField.delegate = self
        return textField
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        let localizedTitle = NSLocalizedString(
            "button.confirm.title",
            comment: "Title of the button confirming the action of creating a new category"
        )
        button.configure(with: .standardButton, for: localizedTitle)
        button.backgroundColor = UIColor.TrackerColor.gray
        button.isEnabled = false
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
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
        
        addTopNavigationLabel()
        addCategoryTitleTextField()
        addConfirmButton()
    }
    
    // MARK: - Objective-C methods
    
    @objc private func confirmButtonTapped() {
        if let text = categoryTitleTextField.text, !text.isEmpty {
            let category = TrackerCategory(title: text, trackers: [])
            viewModel.add(category: category)
        }
        
        dismiss(animated: true)
    }
}

// MARK: - Add Subviews

private extension CreateCategoryViewController {
    
    func addTopNavigationLabel() {
        let localizedTitle = NSLocalizedString(
            "navBar.newCategory.title",
            comment: "Title of the new category screen label in the navigation bar"
        )
        title = localizedTitle
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.TrackerFont.medium16,
            .foregroundColor: UIColor.TrackerColor.black
        ]
    }
    
    func addCategoryTitleTextField() {
        view.addSubview(categoryTitleTextField)
        
        NSLayoutConstraint.activate([
            categoryTitleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryTitleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryTitleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func addConfirmButton() {
        view.addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            confirmButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - TextFieldDelegate methods

extension CreateCategoryViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = textField.text else {
            return true
        }
        
        let newLength = text.count + string.count - range.length
        
        if newLength >= 1 && newLength <= 38 {
            confirmButton.isEnabled = true
            confirmButton.backgroundColor = UIColor.TrackerColor.black
        } else {
            confirmButton.isEnabled = false
            confirmButton.backgroundColor = UIColor.TrackerColor.gray
        }
        
        return newLength <= 38
    }
}
