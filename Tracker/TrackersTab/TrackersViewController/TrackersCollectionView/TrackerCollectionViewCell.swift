//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Pavel Belenkow on 28.06.2023.
//

import UIKit

// MARK: - Protocols

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func updateTrackers()
    func completedTracker(id: UUID, at indexPath: IndexPath)
    func uncompletedTracker(id: UUID, at indexPath: IndexPath)
}

// MARK: - Tracker CollectionViewCell Class

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "tracker"
    
    private let trackerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.TrackerFont.medium16
        label.textAlignment = .center
        label.backgroundColor = UIColor.TrackerColor.white.withAlphaComponent(0.3)
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let trackerTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.TrackerColor.white
        label.font = UIFont.TrackerFont.medium12
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let counterDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.TrackerColor.black
        label.font = UIFont.TrackerFont.medium12
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let plusImage: UIImage = {
        let pointSize = UIImage.SymbolConfiguration(pointSize: 11)
        let image = UIImage(systemName: "plus", withConfiguration: pointSize) ?? UIImage()
        return image
    }()
    
    private let doneImage: UIImage = {
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
    
    private var isCompletedToday: Bool = false
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    
    weak var delegate: TrackerCollectionViewCellDelegate?
    
    // MARK: - Methods
    
    private func addSubviews() {
        addTrackerView()
        addStackView()
        addEmojiLabel()
        addTrackerTitleLabel()
        addCounterDayLabel()
        addAppendDayButton()
    }
    
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
        
        let wordDay = completedDays
        counterDayLabel.text = "\(wordDay) дней"
        
        if isCompletedToday {
            appendDayButton.setImage(doneImage, for: .normal)
            appendDayButton.layer.opacity = 0.3
        } else {
            appendDayButton.layer.opacity = 1.0
            appendDayButton.setImage(plusImage, for: .normal)
        }
    }
    
    // MARK: - Objective-C methods
    
    @objc private func appendDayButtonTapped() {
        guard let trackerId, let indexPath else {
            assert(false, "ID not found")
            return
        }
        
        if isCompletedToday {
            delegate?.uncompletedTracker(id: trackerId, at: indexPath)
        } else {
            delegate?.completedTracker(id: trackerId, at: indexPath)
        }
    }
}

// MARK: - Add Subviews

private extension TrackerCollectionViewCell {
    
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
