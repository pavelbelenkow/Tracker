//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Pavel Belenkow on 01.08.2023.
//

import UIKit

// MARK: - Protocols

protocol UpdateTrackerInformationDelegate: AnyObject {
    func updateScheduleSubtitle(from weekday: [Weekday]?, at selectedWeekday: [Int: Bool])
    func updateSelectedEmoji(_ emoji: String)
    func updateSelectedColor(_ color: UIColor)
}

// MARK: - ViewController class

final class CreateTrackerViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var trackerTitleTextField: UITextField = {
        let textField = UITextField()
        textField.configure(with: "Введите название трекера")
        textField.delegate = self
        return textField
    }()
    
    private lazy var symbolsConstraintLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.textColor = UIColor.TrackerColor.red
        label.font = UIFont.TrackerFont.regular17
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let view = CreateTrackerTableView(viewModel: viewModel, viewController: self)
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = EmojiColorCollectionView(frame: .zero, collectionViewLayout: layout)
        view.selectionDelegate = self
        return view
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        view.distribution = .fillProportionally
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.configure(with: .cancelButton, for: "Отменить")
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.configure(with: .createButton, for: "Создать")
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let trackerStore: TrackerStoreProtocol = TrackerStore()
    private let trackerCategoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore()
    private let viewModel: CategoryViewModel
    
    private var trackerTitle = ""
    private var categorySubtitle = ""
    private var selectedWeekdays: [Int: Bool] = [:]
    private var emoji: String = ""
    private var color: UIColor?
    
    private var isRegular: Bool
    
    private lazy var titleCells: [String] = {
        isRegular ? ["Категория", "Расписание"] : ["Категория"]
    }()
    
    private lazy var scheduleSubtitle: [Weekday] = {
        isRegular ? [] : Weekday.allCases
    }()
    
    var indexCategory: IndexPath?
    weak var delegate: TrackerCollectionViewCellDelegate?
    
    // MARK: - Initializers
    
    init(isRegular: Bool, viewModel: CategoryViewModel = CategoryViewModel()) {
        self.isRegular = isRegular
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
        
        addSubviews()
        updateCategorySubtitleAndIndexCategory()
        updateCreateButton()
    }
}

// MARK: - Add Subviews

private extension CreateTrackerViewController {
    
    func addSubviews() {
        addTopNavigationLabel()
        addScrollView()
        addContentView()
        addStackView()
        addTableView()
        addCollectionView()
        addButtonsStackView()
    }
    
    func addTopNavigationLabel() {
        title = isRegular ? "Новая привычка" : "Новое нерегулярное событие"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.TrackerFont.medium16,
            .foregroundColor: UIColor.TrackerColor.black
        ]
    }
    
    func addScrollView() {
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func addContentView() {
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: view.frame.width),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor)
        ])
    }
    
    func addStackView() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(trackerTitleTextField)
        stackView.addArrangedSubview(symbolsConstraintLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func addTableView() {
        contentView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: isRegular ? 150 : 75),
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func addCollectionView() {
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32)
        ])
        
        collectionView.layoutIfNeeded()
        collectionView.heightAnchor.constraint(equalToConstant: collectionView.contentSize.height).isActive = true
    }
    
    func addButtonsStackView() {
        contentView.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(createButton)
        
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -34),
            buttonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - Private methods

private extension CreateTrackerViewController {
    
    func updateCreateButton() {
        let isButtonEnabled =
        !(trackerTitleTextField.text?.isEmpty ?? true) &&
        !categorySubtitle.isEmpty &&
        !scheduleSubtitle.isEmpty &&
        !emoji.isEmpty &&
        color != nil
        
        createButton.isEnabled = isButtonEnabled
        createButton.backgroundColor = isButtonEnabled ? UIColor.TrackerColor.black : UIColor.TrackerColor.gray
    }
    
    func updateCategorySubtitleAndIndexCategory() {
        viewModel.didSelectCategory = { [weak self] titleCategory, indexPath in
            guard let self else { return }
            
            self.categorySubtitle = titleCategory ?? ""
            self.indexCategory = indexPath
            
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .none)
            
            self.updateCreateButton()
        }
    }
    
    func createTracker() {
        guard let trackerTitle = trackerTitleTextField.text, !trackerTitle.isEmpty else {
            return
        }
        
        let newTracker = Tracker(
            id: UUID(),
            title: trackerTitle,
            color: color ?? UIColor(),
            emoji: emoji,
            schedule: scheduleSubtitle
        )
        
        let categoryTitle = categorySubtitle
        
        do {
            let categories = try trackerCategoryStore.getCategories()
            if let index = categories.firstIndex(where: { $0.title == categoryTitle }) {
                let existingCategory = categories[index]
                let updatedTrackers = existingCategory.trackers + [newTracker]
                let updatedCategory = TrackerCategory(
                    title: existingCategory.title,
                    trackers: updatedTrackers
                )
                
                try trackerStore.addTracker(newTracker, with: updatedCategory)
            } else {
                let newCategory = TrackerCategory(
                    title: categoryTitle,
                    trackers: [newTracker]
                )
                try trackerStore.addTracker(newTracker, with: newCategory)
            }
        } catch {
            assertionFailure("Failed to add tracker with \(error)")
        }
    }
    
    func dismissViewControllers() {
        var currentViewController = self.presentingViewController
        
        while currentViewController is UINavigationController {
            currentViewController = currentViewController?.presentingViewController
        }
        
        currentViewController?.dismiss(animated: true)
    }
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func createButtonTapped() {
        createTracker()
        delegate?.reloadTrackersWithCategory()
        dismissViewControllers()
    }
}

// MARK: - Methods

extension CreateTrackerViewController {
    
    func getTitles() -> [String] {
        titleCells
    }
    
    func getCategorySubtitle() -> String {
        categorySubtitle
    }
    
    func getSchedule() -> [Weekday] {
        scheduleSubtitle
    }
    
    func getSelectedWeekdays() -> [Int: Bool] {
        selectedWeekdays
    }
    
    func getScheduleSubtitle(from selectedWeekdays: [Weekday]) -> String {
        selectedWeekdays == Weekday.allCases ?
        "Каждый день" : selectedWeekdays.compactMap { $0.weekdayShortName }.joined(separator: ", ")
    }
}

// MARK: - UITextFieldDelegate methods

extension CreateTrackerViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        updateCreateButton()
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        updateCreateButton()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        updateCreateButton()
        return true
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            return true
        }
        
        let newLength = text.count + string.count - range.length
        symbolsConstraintLabel.isHidden = (newLength <= 38)
        
        updateCreateButton()
        
        return newLength <= 38
    }
}

// MARK: - UpdateTrackerInformationDelegate methods

extension CreateTrackerViewController: UpdateTrackerInformationDelegate {
    
    func updateScheduleSubtitle(from weekday: [Weekday]?, at selectedWeekday: [Int : Bool]) {
        scheduleSubtitle = weekday ?? []
        selectedWeekdays = selectedWeekday
        
        let indexPath = IndexPath(row: 1, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
        
        updateCreateButton()
    }
    
    func updateSelectedEmoji(_ emoji: String) {
        self.emoji = emoji
        updateCreateButton()
    }
    
    func updateSelectedColor(_ color: UIColor) {
        self.color = color
        updateCreateButton()
    }
}
