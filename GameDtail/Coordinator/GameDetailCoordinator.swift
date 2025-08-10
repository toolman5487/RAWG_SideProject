//
//  GameDetailCoordinator.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/10.
//

import Foundation
import UIKit
import Combine

protocol Coordinator {
    func start()
}

class GameDetailCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let gameId: Int
    private weak var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController, gameId: Int, parentCoordinator: Coordinator? = nil) {
        self.navigationController = navigationController
        self.gameId = gameId
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let viewModel = GameDetailViewModel()
        let viewController = GameDetailViewController()
        
        viewController.coordinator = self
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "錯誤", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default))
        navigationController.present(alert, animated: true)
    }

    func goBack() {
        navigationController.popViewController(animated: true)
    }
    
    func finish() {
        navigationController.popViewController(animated: true)
    }
}
