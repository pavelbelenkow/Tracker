//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Pavel Belenkow on 07.08.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testViewController() {
        let vc = TrackersViewController()
        assertSnapshot(matching: vc, as: .image)
    }
}
