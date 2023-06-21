//
//  UIColor+Extensions.swift
//  Tracker
//
//  Created by Pavel Belenkow on 21.06.2023.
//

import UIKit

extension UIColor {
    enum TrackerColor {
        case black
        case white
        case background
        case blue
        case red
        case gray
        case lightGray
        case colorSelection1
        case colorSelection2
        case colorSelection3
        case colorSelection4
        case colorSelection5
        case colorSelection6
        case colorSelection7
        case colorSelection8
        case colorSelection9
        case colorSelection10
        case colorSelection11
        case colorSelection12
        case colorSelection13
        case colorSelection14
        case colorSelection15
        case colorSelection16
        case colorSelection17
        case colorSelection18
        
        var value: UIColor {
            switch self {
            case .black:
                return UIColor(named: "TrackerBlack")!
            case .white:
                return UIColor(named: "TrackerWhite")!
            case .background:
                return UIColor(named: "TrackerBackground")!
            case .blue:
                return UIColor(named: "TrackerBlue")!
            case .red:
                return UIColor(named: "TrackerRed")!
            case .gray:
                return UIColor(named: "TrackerGray")!
            case .lightGray:
                return UIColor(named: "TrackerLightGray")!
            case .colorSelection1:
                return UIColor(named: "TrackerColorSelection1")!
            case .colorSelection2:
                return UIColor(named: "TrackerColorSelection2")!
            case .colorSelection3:
                return UIColor(named: "TrackerColorSelection3")!
            case .colorSelection4:
                return UIColor(named: "TrackerColorSelection4")!
            case .colorSelection5:
                return UIColor(named: "TrackerColorSelection5")!
            case .colorSelection6:
                return UIColor(named: "TrackerColorSelection6")!
            case .colorSelection7:
                return UIColor(named: "TrackerColorSelection7")!
            case .colorSelection8:
                return UIColor(named: "TrackerColorSelection8")!
            case .colorSelection9:
                return UIColor(named: "TrackerColorSelection9")!
            case .colorSelection10:
                return UIColor(named: "TrackerColorSelection10")!
            case .colorSelection11:
                return UIColor(named: "TrackerColorSelection11")!
            case .colorSelection12:
                return UIColor(named: "TrackerColorSelection12")!
            case .colorSelection13:
                return UIColor(named: "TrackerColorSelection13")!
            case .colorSelection14:
                return UIColor(named: "TrackerColorSelection14")!
            case .colorSelection15:
                return UIColor(named: "TrackerColorSelection15")!
            case .colorSelection16:
                return UIColor(named: "TrackerColorSelection16")!
            case .colorSelection17:
                return UIColor(named: "TrackerColorSelection17")!
            case .colorSelection18:
                return UIColor(named: "TrackerColorSelection18")!
            }
        }
    }
}
