//
//  WeekDay.swift
//  Tracker
//
//  Created by Pavel Belenkow on 25.06.2023.
//

import Foundation

enum Weekday: String, CaseIterable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    var weekdayLocalizedName: String {
        NSLocalizedString(rawValue, comment: "Titles of all the days of the week")
    }
    
    var weekdayShortName: String {
        NSLocalizedString(String(rawValue.prefix(3)), comment: "Acronyms of all the days of the week")
    }
    
    var weekdayNumber: Int {
        switch self {
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        case .sunday: return 1
        }
    }
    
    static func getString(from weekday: [Weekday]?) -> String? {
        guard let weekday else { return nil }
        return weekday.map { $0.rawValue }.joined(separator: ", ")
    }
    
    static func getWeekday(from string: String?) -> [Weekday]? {
        let array = string?.components(separatedBy: ", ")
        let weekday = Weekday.allCases.filter { array?.contains($0.rawValue) ?? false }
        return weekday.count > 0 ? weekday : nil
    }
}
