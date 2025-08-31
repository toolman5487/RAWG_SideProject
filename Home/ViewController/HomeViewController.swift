//
//  HomeViewController.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/9.
//
import Foundation
import UIKit
import SnapKit
import Combine

class HomeViewController: UIViewController {
    
    private let searchViewModel = SearchViewModel()
    private var cancellables = Set<AnyCancellable>()

// MARK: - UI
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: resultsVC)
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search Games"
        controller.searchResultsUpdater = self
        return controller
    }()
    
    private let resultsVC = SearchResultsViewController()

// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupNavigation() {
        self.title = "RAWG"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupBindings() {
        searchViewModel.$searchResults
            .receive(on: DispatchQueue.main)
            .assign(to: \.results, on: resultsVC)
            .store(in: &cancellables)
        
        resultsVC.gameSelected
            .sink { [weak self] selectedGame in
                let gameDetailVC = GameDetailViewController(gameId: selectedGame.id)
                gameDetailVC.gameId = selectedGame.id
                self?.navigationController?.pushViewController(gameDetailVC, animated: true)
            }
            .store(in: &cancellables)
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        searchViewModel.searchGames(query: query)
    }
}
