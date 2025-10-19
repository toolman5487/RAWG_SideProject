//
//  MainTabBarController.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/9.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        configureAppearance()
    }

    private func setupTabs() {
        let homeVC = HomeViewController()
        homeVC.title = "Home"
        let homeTab = UITab(title: "Home", image: UIImage(systemName: "house"), identifier: "home") { _ in
            let homeNav = UINavigationController(rootViewController: homeVC)
            return homeNav
        }
        
        let otherVC = PlatformsViewController()
        otherVC.title = "Platform"
        let gameTab = UITab(title: "Platform", image: UIImage(systemName: "gamecontroller.fill"), identifier: "game") { _ in
            let gameNav = UINavigationController(rootViewController: otherVC)
            return gameNav
        }
        
        let searchVC = SearchTabViewController()
        searchVC.title = "Search"
        let searchTab = UISearchTab { tab in
            let searchNav = UINavigationController(rootViewController: searchVC)
            searchNav.navigationBar.prefersLargeTitles = true
            return searchNav
        }
        
        self.tabs = [homeTab, gameTab, searchTab]
        
        if #available(iOS 26.0, *) {
            self.tabBarMinimizeBehavior = .onScrollDown
        }
    }

    private func configureAppearance() {
        tabBar.isTranslucent = true
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        appearance.backgroundEffect = blurEffect
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = nil
    }
}
