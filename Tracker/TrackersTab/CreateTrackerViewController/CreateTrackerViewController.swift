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
    func getSelectedEmoji() -> String
    func getSelectedColor() -> UIColor?
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
    
    private lazy var completedDaysStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var completedDaysLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.TrackerColor.black
        label.font = UIFont.TrackerFont.bold32
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.configure(with: .plus)
        button.addTarget(self, action: #selector(appendDays), for: .touchUpInside)
        return button
    }()
    
    private lazy var minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.configure(with: .minus)
        button.addTarget(self, action: #selector(reduceDays), for: .touchUpInside)
        return button
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
        let localizedTitle = NSLocalizedString(
            "textField.tracker.title",
            comment: "Title of the placeholder for typing tracker title in the text field"
        )
        textField.configure(with: localizedTitle)
        textField.delegate = self
        return textField
    }()
    
    private lazy var symbolsConstraintLabel: UILabel = {
        let label = UILabel()
        let localizedTitle = NSLocalizedString(
            "symbolsConstraintLabel.title",
            comment: "Title of the label that displays the maximum number of symbols in the text field up to 38"
        )
        label.text = localizedTitle
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
        let view = CreateTrackerCollectionView(frame: .zero, collectionViewLayout: layout)
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
        let localizedTitle = NSLocalizedString(
            "button.cancel.title",
            comment: "Title of the cancel button"
        )
        button.configure(with: .cancelButton, for: localizedTitle)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        let localizedTitle = getCreateButtonTitle()
        button.configure(with: .createButton, for: localizedTitle)
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let trackerStore: TrackerStoreProtocol = TrackerStore()
    private let trackerCategoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore()
    private let viewModel: CategoryViewModel
    
    private var tracker: Tracker?
    private var trackerCategory: TrackerCategory?
    
    private var completedDays = 0
    private var trackerTitle = ""
    private var categorySubtitle = ""
    private var selectedWeekdays: [Int: Bool] = [:]
    private var emoji: String = ""
    private var color: UIColor?
    
    private var isRegular: Bool
    private var isEditViewController: Bool?
    private var isTrackerCompletedToday: Bool?
    
    private lazy var barTitle: String = getNavigationBarTitle()
    private lazy var titleCells: [String] = getTitleCells()
    
    private lazy var scheduleSubtitle: [Weekday] = {
        isRegular ? [] : Weekday.allCases
    }()
    
    var indexCategory: IndexPath?
    weak var delegate: TrackerCellDelegate?
    
    // MARK: - Initializers
    
    init(isRegular: Bool, viewModel: CategoryViewModel = CategoryViewModel()) {
        self.isRegular = isRegular
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    init(
        tracker: Tracker,
        category: TrackerCategory?,
        isCompletedToday: Bool,
        isRegular: Bool,
        isEditViewController: Bool
    ) {
        self.tracker = tracker
        self.trackerCategory = category
        self.isTrackerCompletedToday = isCompletedToday
        self.isRegular = isRegular
        self.isEditViewController = isEditViewController
        self.viewModel = CategoryViewModel()
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
        fillTrackerData()
        checkDate()
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
        if isEditViewController ?? false {
            addCompletedDaysStackView()
        }
        addStackView()
        addTableView()
        addCollectionView()
        addButtonsStackView()
    }
    
    func addTopNavigationLabel() {
        title = barTitle
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
    
    func addCompletedDaysStackView() {
        contentView.addSubview(completedDaysStackView)
        completedDaysStackView.addArrangedSubview(minusButton)
        completedDaysStackView.addArrangedSubview(completedDaysLabel)
        completedDaysStackView.addArrangedSubview(plusButton)
        
        NSLayoutConstraint.activate([
            completedDaysStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            completedDaysStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    func addStackView() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(trackerTitleTextField)
        stackView.addArrangedSubview(symbolsConstraintLabel)
        
        let topAnchor = isEditViewController ?? false ? completedDaysStackView.bottomAnchor : contentView.topAnchor
        let constant: CGFloat = isEditViewController ?? false ? 40 : 24
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: constant),
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
    
    func getNavigationBarTitle() -> String {
        let editRegularTitle = NSLocalizedString(
            "navBar.editRegularEvent.title",
            comment: "Title of habit editing for the label in the navigation bar"
        )
        let editIrregularTitle = NSLocalizedString(
            "navBar.editIrregularEvent.title",
            comment: "Title of irregular event editing for the label in the navigation bar"
        )
        let newRegularTitle = NSLocalizedString(
            "navBar.newRegularEvent.title",
            comment: "Title of a new habit for the label in the navigation bar"
        )
        let newIrregularTitle = NSLocalizedString(
            "navBar.newIrregularEvent.title",
            comment: "Title of a new irregular event for the label in the navigation bar"
        )
        
        let editTitle = isRegular ? editRegularTitle : editIrregularTitle
        let newTitle = isRegular ? newRegularTitle : newIrregularTitle
        
        guard let isEditViewController else { return newTitle }
        
        return isEditViewController ? editTitle : newTitle
    }
    
    func getTitleCells() -> [String] {
        let localizedCategoryTitle = NSLocalizedString(
            "category.title",
            comment: "Title of the category cell in the table view"
        )
        let localizedScheduleTitle = NSLocalizedString(
            "schedule.title",
            comment: "Title of the schedule cell in the table view"
        )
        
        return isRegular ?
        [localizedCategoryTitle, localizedScheduleTitle] :
        [localizedCategoryTitle]
    }
    
    func getCreateButtonTitle() -> String {
        let createTitle = NSLocalizedString(
            "button.create.title",
            comment: "Title of the create button"
        )
        let saveTitle = NSLocalizedString(
            "button.save.title",
            comment: "Title of the save button"
        )
        
        guard let isEditViewController else { return createTitle }
        
        return isEditViewController ? saveTitle : createTitle
    }
    
    func getDaysText(_ completedDays: Int) -> String {
        let localizedCompletedDays = NSLocalizedString("completedDays", comment: "Number of completed days")
        return String.localizedStringWithFormat(localizedCompletedDays, completedDays)
    }
    
    func fillTrackerData() {
        if let tracker {
            completedDays = tracker.completedDays
            completedDaysLabel.text = getDaysText(completedDays)
            trackerTitleTextField.text = tracker.title
            categorySubtitle = trackerCategory?.title ?? ""
            scheduleSubtitle = tracker.schedule ?? [Weekday]()
            emoji = tracker.emoji
            color = tracker.color
        }
    }
    
    func checkDate() {
        let isCompleted = isTrackerCompletedToday ?? false
        let currentDate = Date()
        let selectedDate = delegate?.getSelectedDate() ?? currentDate
        let isToday = Calendar.current.isDate(currentDate, inSameDayAs: selectedDate)
        let isEnabled = isToday && !isCompleted
        
        plusButton.isEnabled = isEnabled
        plusButton.layer.opacity = isEnabled ? 1.0 : 0.3
        
        minusButton.isEnabled = isToday && isCompleted
        minusButton.layer.opacity = isCompleted ? 1.0 : 0.3
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
    
    func createTracker() {
        guard let trackerTitle = trackerTitleTextField.text, !trackerTitle.isEmpty else {
            return
        }
        
        let newTracker = Tracker(
            id: UUID(),
            title: trackerTitle,
            color: color ?? UIColor(),
            emoji: emoji,
            schedule: scheduleSubtitle,
            completedDays: 0
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
    
    func updateTracker() {
        guard
            let tracker,
            let trackerTitle = trackerTitleTextField.text, !trackerTitle.isEmpty,
            let category = viewModel.getSelectedCategory(from: indexCategory)
        else { return }
        
        do {
            try trackerStore.editTracker(
                tracker,
                title: trackerTitle,
                color: color,
                emoji: emoji,
                schedule: scheduleSubtitle,
                completedDays: completedDays,
                category: category
                )
        } catch {
            assertionFailure("Failed to edit tracker with \(error)")
        }
        
        delegate?.updateTracker(tracker, with: completedDays)
    }
    
    func dismissViewControllers() {
        var currentViewController = self.presentingViewController
        
        while currentViewController is UINavigationController {
            currentViewController = currentViewController?.presentingViewController
        }
        
        currentViewController?.dismiss(animated: true)
    }
    
    func checkTrackerCompletedToday(_ isCompleted: Bool?) {
        guard let isCompleted else { return }
        
        plusButton.isEnabled = !isCompleted
        plusButton.layer.opacity = !isCompleted ? 1.0 : 0.3
        
        minusButton.isEnabled = isCompleted
        minusButton.layer.opacity = isCompleted ? 1.0 : 0.3
    }
    
    func setCompletedDaysText(_ completedDays: Int) {
        isTrackerCompletedToday?.toggle()
        completedDaysLabel.text = getDaysText(completedDays)
        checkTrackerCompletedToday(isTrackerCompletedToday)
    }
    
    @objc func appendDays() {
        completedDays += 1
        setCompletedDaysText(completedDays)
    }
    
    @objc func reduceDays() {
        completedDays -= 1
        setCompletedDaysText(completedDays)
    }
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func createButtonTapped() {
        tracker == nil ? createTracker() : updateTracker()
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
        let localizedEveryDayTitle = NSLocalizedString(
            "everyDay",
            comment: "Title of the subtitle of the schedule cell in the table view"
        )
        
        return selectedWeekdays == Weekday.allCases ?
        localizedEveryDayTitle :
        selectedWeekdays.compactMap { $0.weekdayShortName }.joined(separator: ", ")
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
    
    func getSelectedEmoji() -> String {
        emoji
    }
    
    func getSelectedColor() -> UIColor? {
        color
    }
}
