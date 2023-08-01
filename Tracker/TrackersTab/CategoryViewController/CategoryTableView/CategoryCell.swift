//
//  CategoryCell.swift
//  Tracker
//
//  Created by Pavel Belenkow on 03.07.2023.
//

import UIKit

// MARK: - CategoryCell class

final class CategoryCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "category"
    
    // MARK: - Methods
    
    func configure(
        with title: String,
        isFirstRow: Bool,
        isLastRow: Bool,
        isSelected: Bool,
        separatorInset: CGFloat
    ) {
        textLabel?.text = title
        textLabel?.font = UIFont.TrackerFont.regular17
        textLabel?.textColor = UIColor.TrackerColor.black
        
        backgroundColor = UIColor.TrackerColor.background
        layer.masksToBounds = true
        layer.cornerRadius = 16
        self.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        selectionStyle = .none
        accessoryType = isSelected ? .checkmark : .none
        
        switch (isFirstRow, isLastRow) {
        case (true, true):
            self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: separatorInset)
        case (true, false):
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case (false, true):
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: separatorInset)
        default:
            layer.cornerRadius = 0
        }
    }
}
