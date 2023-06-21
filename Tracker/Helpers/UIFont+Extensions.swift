//
//  UIFont+Extensions.swift
//  Tracker
//
//  Created by Pavel Belenkow on 21.06.2023.
//

import UIKit

extension UIFont {
    enum TrackerFont {
        case regular17
        case medium10
        case medium12
        case medium16
        case bold19
        case bold32
        case bold34
        
        var value: UIFont {
            switch self {
            case .regular17:
                return UIFont.systemFont(ofSize: 17)
            case .medium10:
                return UIFont.systemFont(ofSize: 10, weight: .medium)
            case .medium12:
                return UIFont.systemFont(ofSize: 12, weight: .medium)
            case .medium16:
                return UIFont.systemFont(ofSize: 16, weight: .medium)
            case .bold19:
                return UIFont.boldSystemFont(ofSize: 19)
            case .bold32:
                return UIFont.boldSystemFont(ofSize: 32)
            case .bold34:
                return UIFont.boldSystemFont(ofSize: 34)
            }
        }
    }
}
