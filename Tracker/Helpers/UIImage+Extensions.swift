//
//  UIImage+Extensions.swift
//  Tracker
//
//  Created by Pavel Belenkow on 21.06.2023.
//

import UIKit

extension UIImage {
    enum TrackerIcon {
        case chevron
        case done
        case pin
        case records
        case statistics
        
        var value: UIImage {
            switch self {
            case .chevron:
                return UIImage(named: "Chevron")!
            case .done:
                return UIImage(named: "Done")!
            case .pin:
                return UIImage(named: "Pin")!
            case .records:
                return UIImage(named: "RecordSelected")!
            case .statistics:
                return UIImage(named: "StatsSelected")!
            }
        }
    }
}
