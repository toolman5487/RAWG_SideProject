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
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "Home",
                                          image: UIImage(systemName: "house"),
                                          selectedImage: UIImage(systemName: "house.fill"))

        let otherVC = GameDetailViewController()
        otherVC.title = "Game"
        let otherNav = UINavigationController(rootViewController: otherVC)
        otherNav.tabBarItem = UITabBarItem(title: "Game",
                                           image: UIImage(systemName: "gamecontroller"),
                                           selectedImage: UIImage(systemName: "gamecontroller.fill"))

        viewControllers = [homeNav, otherNav]
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
