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
        homeVC.title = "首頁"
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "首頁",
                                          image: UIImage(systemName: "house"),
                                          selectedImage: UIImage(systemName: "house.fill"))

        let otherVC = GameDetailViewController()
        otherVC.title = "遊戲詳細"
        let otherNav = UINavigationController(rootViewController: otherVC)
        otherNav.tabBarItem = UITabBarItem(title: "遊戲詳細",
                                           image: UIImage(systemName: "square.grid.2x2"),
                                           selectedImage: UIImage(systemName: "square.grid.2x2.fill"))

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
