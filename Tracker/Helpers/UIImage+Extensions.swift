//
//  UIImage+Extensions.swift
//  Tracker
//
//  Created by Pavel Belenkow on 21.06.2023.
//

import UIKit

extension UIImage {
    
    enum TrackerIcon {
        static let add = UIImage(named: "Add") ?? UIImage(systemName: "plus")!
        static let chevron = UIImage(named: "Chevron") ?? UIImage(systemName: "chevron.right")!
        static let done = UIImage(named: "Done") ?? UIImage(systemName: "checkmark")!
        static let pin = UIImage(named: "Pin") ?? UIImage(systemName: "pin.fill")!
        static let records = UIImage(named: "RecordSelected") ?? UIImage(systemName: "record.circle.fill")!
        static let statistics = UIImage(named: "StatsSelected") ?? UIImage(systemName: "hare.fill")!
    }
    
    enum TrackerImage {
        static let emptyStatistics = UIImage(named: "EmptyStatistics") ?? UIImage(systemName: "eyes")!
        static let emptyTrackers = UIImage(named: "EmptyTrackers") ?? UIImage(systemName: "wand.and.stars")!
        static let nothingFound = UIImage(named: "NothingFound") ?? UIImage(systemName: "eyeglasses")!
        static let onboardingFirstPage = UIImage(named: "OnboardingBackground1")
        static let onboardingSecondPage = UIImage(named: "OnboardingBackground2")
    }
}
