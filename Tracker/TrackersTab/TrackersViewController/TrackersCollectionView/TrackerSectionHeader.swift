//
//  TrackerSectionHeader.swift
//  Tracker
//
//  Created by Pavel Belenkow on 30.06.2023.
//

import UIKit

// MARK: - TrackerSectionHeader class

final class TrackerSectionHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "header"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.TrackerFont.bold19
        label.textColor = UIColor.TrackerColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Methods
    
    private func addTitleLabel() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28)
        ])
    }
    
    func configure(from title: String) {
        titleLabel.text = title
        addTitleLabel()
    }
}
