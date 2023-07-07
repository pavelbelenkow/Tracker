//
//  DataManager.swift
//  Tracker
//
//  Created by Pavel Belenkow on 29.06.2023.
//

import UIKit

class DataManager {
    static let shared = DataManager()
    
    var categories: [TrackerCategory] = [
        TrackerCategory(
            title: "Хобби",
            trackers: [
                Tracker(
                    id: UUID(),
                    title: "Позаниматься на гитаре",
                    color: UIColor.TrackerColor.colorSelection1,
                    emoji: "🎸",
                    schedule: [Weekday.monday, Weekday.wednesday, Weekday.friday]
                ),
                Tracker(
                    id: UUID(),
                    title: "Покататься на велосипеде",
                    color: UIColor.TrackerColor.colorSelection18,
                    emoji: "🚴‍♂️",
                    schedule: Weekday.allCases
                )
            ]
        ),
        TrackerCategory(
            title: "Здоровье",
            trackers: [
                Tracker(
                    id: UUID(),
                    title: "Прием у дантиста",
                    color: UIColor.TrackerColor.colorSelection3,
                    emoji: "🦷",
                    schedule: [Weekday.friday]
                ),
                Tracker(
                    id: UUID(),
                    title: "Прием у спортивного врача",
                    color: UIColor.TrackerColor.colorSelection7,
                    emoji: "👨🏻‍⚕️",
                    schedule: [Weekday.sunday]
                )
            ]
        )
    ]
    
    func update(categories: [TrackerCategory]) {
        self.categories.append(contentsOf: categories)
    }
    
    private init() {}
}
