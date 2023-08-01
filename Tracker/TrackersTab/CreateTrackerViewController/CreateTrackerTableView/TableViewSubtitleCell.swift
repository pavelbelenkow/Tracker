//
//  TableViewSubtitleCell.swift
//  Tracker
//
//  Created by Pavel Belenkow on 01.08.2023.
//

import UIKit

// MARK: - SubtitleCell class

final class TableViewSubtitleCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "cell"
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(
        with title: String,
        categorySubtitle: String,
        scheduleSubtitle: String? = nil,
        isFirstRow: Bool = false,
        isLastRow: Bool = false,
        separatorInset: CGFloat
    ) {
        textLabel?.text = title
        textLabel?.font = UIFont.TrackerFont.regular17
        textLabel?.textColor = UIColor.TrackerColor.black

        detailTextLabel?.text = isFirstRow ? categorySubtitle : scheduleSubtitle
        detailTextLabel?.font = UIFont.TrackerFont.regular17
        detailTextLabel?.textColor = UIColor.TrackerColor.gray

        backgroundColor = UIColor.TrackerColor.background
        layer.masksToBounds = true
        layer.cornerRadius = 16
        self.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        selectionStyle = .none
        accessoryType = .disclosureIndicator
        
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
