//
//  WeekdayCell.swift
//  Tracker
//
//  Created by Pavel Belenkow on 06.07.2023.
//

import UIKit

// MARK: - WeekdayCell class

final class WeekdayCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "weekday"
    
    let switchWeekday: UISwitch = {
        let button = UISwitch()
        button.onTintColor = .blue
        return button
    }()
    
    // MARK: - Methods
    
    func configure(
        with title: String,
        isFirstRow: Bool,
        isLastRow: Bool,
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
        accessoryView = switchWeekday
        
        if isFirstRow {
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if isLastRow {
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: separatorInset)
        } else {
            layer.cornerRadius = 0
        }
    }
}
