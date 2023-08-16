//
//  TrackerCell.swift
//  Tracker
//
//  Created by Pavel Belenkow on 28.06.2023.
//

import UIKit

// MARK: - Protocols

protocol TrackerCellDelegate: AnyObject {
    func getSelectedDate() -> Date
    func isPinnedTracker(by trackerId: UUID) -> Bool
    func reloadTrackersWithCategory()
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func uncompleteTracker(id: UUID, at indexPath: IndexPath)
    func updateTracker(_ tracker: Tracker, with completedDays: Int)
}

protocol ContextMenuInteractionDelegate: AnyObject {
    func contextMenuConfiguration(for trackerId: UUID) -> UIContextMenuConfiguration?
}

// MARK: - CollectionViewCell class

final class TrackerCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "tracker"
    
    private lazy var trackerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.TrackerFont.medium16
        label.textAlignment = .center
        label.backgroundColor = UIColor.TrackerColor.white.withAlphaComponent(0.3)
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var pinImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.TrackerIcon.pin
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var trackerTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.TrackerColor.white
        label.font = UIFont.TrackerFont.medium12
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var counterDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.TrackerColor.black
        label.font = UIFont.TrackerFont.medium12
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var plusImage: UIImage = {
        let pointSize = UIImage.SymbolConfiguration(pointSize: 11)
        let image = UIImage(systemName: "plus", withConfiguration: pointSize) ?? UIImage()
        return image
    }()
    
    private lazy var doneImage: UIImage = {
        let pointSize = UIImage.SymbolConfiguration(pointSize: 12)
        let image = UIImage(systemName: "checkmark", withConfiguration: pointSize) ?? UIImage()
        return image
    }()
    
    private lazy var appendDayButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor.TrackerColor.white
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(appendDayButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var contextMenuInteraction: UIContextMenuInteraction = {
        let interaction = UIContextMenuInteraction(delegate: self)
        return interaction
    }()
    
    private let analyticsService = AnalyticsService()
    
    private let currentDate: Date? = nil
    private var isCompletedToday: Bool = false
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    
    weak var delegate: TrackerCellDelegate?
    weak var contextMenuDelegate: ContextMenuInteractionDelegate?
}

// MARK: - Add Subviews

private extension TrackerCell {
    
    func addSubviews() {
        addTrackerView()
        addStackView()
        addEmojiLabel()
        addPinImageView()
        addTrackerTitleLabel()
        addCounterDayLabel()
        addAppendDayButton()
    }
    
    func addTrackerView() {
        contentView.addSubview(trackerView)
        
        NSLayoutConstraint.activate([
            trackerView.heightAnchor.constraint(equalToConstant: 90),
            trackerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func addStackView() {
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: trackerView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    func addEmojiLabel() {
        trackerView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12)
        ])
    }
    
    func addPinImageView() {
        trackerView.addSubview(pinImageView)
        
        NSLayoutConstraint.activate([
            pinImageView.widthAnchor.constraint(equalToConstant: 24),
            pinImageView.heightAnchor.constraint(equalToConstant: 24),
            pinImageView.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            pinImageView.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -4)
        ])
    }
    
    func addTrackerTitleLabel() {
        trackerView.addSubview(trackerTitleLabel)
        
        NSLayoutConstraint.activate([
            trackerTitleLabel.leadingAnchor.constraint(equalTo: emojiLabel.leadingAnchor),
            trackerTitleLabel.bottomAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: -12),
            trackerTitleLabel.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -12)
        ])
    }
    
    func addCounterDayLabel() {
        stackView.addArrangedSubview(counterDayLabel)
    }
    
    func addAppendDayButton() {
        stackView.addArrangedSubview(appendDayButton)
        
        NSLayoutConstraint.activate([
            appendDayButton.widthAnchor.constraint(equalToConstant: 34),
            appendDayButton.heightAnchor.constraint(equalToConstant: 34),
            appendDayButton.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 8)
        ])
    }
}

// MARK: - Private methods

private extension TrackerCell {
    
    func getDaysText(_ number: Int) -> String {
        let localizedCompletedDays = NSLocalizedString("completedDays", comment: "Number of completed days")
        return String.localizedStringWithFormat(localizedCompletedDays, number)
    }
    
    func checkCompletedToday() {
        let opacity: Float = isCompletedToday ? 0.3 : 1.0
        let image = isCompletedToday ? doneImage : plusImage
        
        appendDayButton.setImage(image, for: .normal)
        appendDayButton.layer.opacity = opacity
    }
    
    func checkDate() {
        let selectedDate = delegate?.getSelectedDate() ?? Date()
        let opacity: Float = selectedDate <= currentDate ?? Date() ? 1.0 : 0.3
        
        trackerView.layer.opacity = opacity
        stackView.layer.opacity = opacity
        
        appendDayButton.isEnabled = selectedDate <= currentDate ?? Date()
    }
    
    func checkPinnedTracker(by id: UUID) {
        let isPinnedTracker = delegate?.isPinnedTracker(by: id) ?? false
        pinImageView.isHidden = !isPinnedTracker
    }
    
    @objc func appendDayButtonTapped() {
        analyticsService.report(
            event: "click",
            params: [
                "screen" : "Main",
                "item" : "track"
            ]
        )
        
        guard let trackerId, let indexPath else {
            assert(false, "ID not found")
            return
        }
        
        if isCompletedToday {
            delegate?.uncompleteTracker(id: trackerId, at: indexPath)
        } else {
            delegate?.completeTracker(id: trackerId, at: indexPath)
        }
    }
}

// MARK: - Configure method

extension TrackerCell {
    
    func configure(
        with tracker: Tracker,
        isCompletedToday: Bool,
        completedDays: Int,
        at indexPath: IndexPath
    ) {
        self.isCompletedToday = isCompletedToday
        self.trackerId = tracker.id
        self.indexPath = indexPath
        
        let color = tracker.color
        addSubviews()
        
        trackerView.backgroundColor = color
        appendDayButton.backgroundColor = color
        
        trackerTitleLabel.text = tracker.title
        emojiLabel.text = tracker.emoji
        
        let daysText = getDaysText(completedDays)
        counterDayLabel.text = daysText
        
        checkCompletedToday()
        checkDate()
        checkPinnedTracker(by: tracker.id)
        
        trackerView.addInteraction(contextMenuInteraction)
    }
}

extension TrackerCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard let trackerId else { return nil }
        return contextMenuDelegate?.contextMenuConfiguration(for: trackerId)
    }
}
