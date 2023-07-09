//
//  Tracker.swift
//  Tracker
//
//  Created by Pavel Belenkow on 21.06.2023.
//

import UIKit

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: [Weekday]?
}
