//
//  TabBarViewController.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 14.04.2022.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeViewController = HomeViewController()
        let searchViewController = SearchViewController()
        let libraryViewController = LibraryViewController()
        
        homeViewController.title = "Browse"
        searchViewController.title = "Search"
        libraryViewController.title = "Library"
        
        homeViewController.navigationItem.largeTitleDisplayMode = .always
        searchViewController.navigationItem.largeTitleDisplayMode = .always
        libraryViewController.navigationItem.largeTitleDisplayMode = .always
        
        let homeNavigationViewController = UINavigationController(rootViewController: homeViewController)
        let searchNavigationViewController = UINavigationController(rootViewController: searchViewController)
        let libraryNavigationViewController = UINavigationController(rootViewController: libraryViewController)
        
        homeNavigationViewController.navigationBar.prefersLargeTitles = true
        searchNavigationViewController.navigationBar.prefersLargeTitles = true
        libraryNavigationViewController.navigationBar.prefersLargeTitles = true
        
        homeNavigationViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        searchNavigationViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        libraryNavigationViewController.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "books.vertical"), tag: 1)
        
        setViewControllers([homeNavigationViewController, searchNavigationViewController, libraryNavigationViewController], animated: false)
    }

}
