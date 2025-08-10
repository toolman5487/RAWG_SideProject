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
        title = "Loading..."
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupBindings() {
        viewModel.$gameDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] gameDetail in
                self?.title = gameDetail?.name ?? "Unknown Game"
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] errorMessage in
                guard let self = self else { return }
                AlertHelper.showErrorAlert(from: self, message: errorMessage)
            }
            .store(in: &cancellables)
    }
    
    private func fetchGameDetail() {
        viewModel.fetchGameDetail(gameId: 46889)
    }
}
