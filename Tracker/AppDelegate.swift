//
//  AppDelegate.swift
//  Tracker
//
//  Created by Pavel Belenkow on 16.06.2023.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        AnalyticsService.activate()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfiguration.storyboard = nil
        sceneConfiguration.sceneClass = UIWindowScene.self
        sceneConfiguration.delegateClass = SceneDelegate.self
        return sceneConfiguration
    }
}

