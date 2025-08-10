//
//  GameDetailViewController.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/10.
//

import Foundation
import UIKit
import SnapKit
import Combine

class GameDetailViewController: UIViewController {
    
    private let viewModel = GameDetailViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        fetchGameDetail()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "載入中..."
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupBindings() {
        viewModel.$gameDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] gameDetail in
                if let gameDetail = gameDetail {
                    self?.title = gameDetail.name ?? "未知遊戲"
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.showErrorAlert(message: errorMessage)
                }
            }
            .store(in: &cancellables)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Erro",
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "確定", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func fetchGameDetail() {
        viewModel.fetchGameDetail(gameId: 46889)
    }
}
