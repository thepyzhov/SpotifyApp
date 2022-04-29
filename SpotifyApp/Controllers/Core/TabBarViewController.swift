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

        let browseViewController = BrowseViewController()
        let searchViewController = SearchViewController()
        let libraryViewController = LibraryViewController()
        
        browseViewController.title = "Browse"
        searchViewController.title = "Search"
        libraryViewController.title = "Library"
        
        browseViewController.navigationItem.largeTitleDisplayMode = .always
        searchViewController.navigationItem.largeTitleDisplayMode = .always
        libraryViewController.navigationItem.largeTitleDisplayMode = .always
        
        let browseNavigationViewController = UINavigationController(rootViewController: browseViewController)
        let searchNavigationViewController = UINavigationController(rootViewController: searchViewController)
        let libraryNavigationViewController = UINavigationController(rootViewController: libraryViewController)
        
        browseNavigationViewController.navigationBar.tintColor = .label
        searchNavigationViewController.navigationBar.tintColor = .label
        libraryNavigationViewController.navigationBar.tintColor = .label
        
        browseNavigationViewController.navigationBar.prefersLargeTitles = true
        searchNavigationViewController.navigationBar.prefersLargeTitles = true
        libraryNavigationViewController.navigationBar.prefersLargeTitles = true
        
        browseNavigationViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        searchNavigationViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        libraryNavigationViewController.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "books.vertical"), tag: 1)
        
        setViewControllers([browseNavigationViewController, searchNavigationViewController, libraryNavigationViewController], animated: false)
    }

}
