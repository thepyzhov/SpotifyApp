//
//  SceneDelegate.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 14.04.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        if AuthManager.shared.isSignedIn {
            window.rootViewController = TabBarViewController()
        } else {
            let welcomeNavigationViewController = UINavigationController(rootViewController: WelcomeViewController())
            welcomeNavigationViewController.navigationBar.prefersLargeTitles = true
            welcomeNavigationViewController.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
            window.rootViewController = welcomeNavigationViewController
        }
        
        window.makeKeyAndVisible()
        
        self.window = window
    }
}

