//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Pavel Belenkow on 16.06.2023.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        let onboardingViewController = OnboardingViewController()
        window.rootViewController = onboardingViewController
        window.makeKeyAndVisible()
        self.window = window
    }
}

