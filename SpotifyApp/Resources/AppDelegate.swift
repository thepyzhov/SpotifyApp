//
//  AppDelegate.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 14.04.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        if AuthManager.shared.isSignedIn {
            AuthManager.shared.refreshAccessTokenIfNeeded(completion: nil)
            window.rootViewController = TabBarViewController()
        } else {
            let welcomeNavigationViewController = UINavigationController(rootViewController: WelcomeViewController())
            welcomeNavigationViewController.navigationBar.prefersLargeTitles = true
            welcomeNavigationViewController.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
            window.rootViewController = welcomeNavigationViewController
        }
        
        window.makeKeyAndVisible()

        self.window = window
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

