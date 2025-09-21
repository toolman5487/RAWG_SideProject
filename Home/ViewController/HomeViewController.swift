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
    private let homeListViewModel = HomeListViewModel()
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
    
    private let tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.backgroundColor = .clear
        tableview.separatorStyle = .none
        tableview.showsVerticalScrollIndicator = false
        return tableview
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupBindings()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupNavigation() {
        self.title = "RAWG"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BannerCell.self, forCellReuseIdentifier: "BannerCell")
        tableView.register(NewGameCell.self, forCellReuseIdentifier: "NewGameCell")
        tableView.register(PopularGameCell.self, forCellReuseIdentifier: "PopularGameCell")
    }
    
    private func setupBindings() {
        searchViewModel.$searchResults
            .receive(on: DispatchQueue.main)
            .assign(to: \.results, on: resultsVC)
            .store(in: &cancellables)
        
        homeListViewModel.$games
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        homeListViewModel.$topGames
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        homeListViewModel.$popularGames
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
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

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BannerCell", for: indexPath) as! BannerCell
            cell.configure(with: homeListViewModel.topGames)
            cell.delegate = self
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewGameCell", for: indexPath) as! NewGameCell
            cell.configure(title: "New and Trending", gamesPublisher: homeListViewModel.$games.eraseToAnyPublisher())
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PopularGameCell", for: indexPath) as! PopularGameCell
            cell.configure(title: "Popular Games", gamesPublisher: homeListViewModel.$popularGames.eraseToAnyPublisher())
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeViewController: NewGameCellDelegate {
    func didSelectGame(_ game: GameListItemModel) {
        let gameDetailVC = GameDetailViewController(gameId: game.id)
        navigationController?.pushViewController(gameDetailVC, animated: true)
    }
    
    func didSelectNewGameSection() {
        let newGameVC = NewGameViewController()
        navigationController?.pushViewController(newGameVC, animated: true)
    }
}

extension HomeViewController: PopularGameCellDelegate {
    func didSelectPopularGame(_ game: GameListItemModel) {
        let gameDetailVC = GameDetailViewController(gameId: game.id)
        navigationController?.pushViewController(gameDetailVC, animated: true)
    }
    
    func didSelectPopularGameSection() {
        print("Navigate to popular games page")
    }
}

extension HomeViewController: BannerCellDelegate {
    func didSelectBannerGame(_ game: GameListItemModel) {
        let gameDetailVC = GameDetailViewController(gameId: game.id)
        navigationController?.pushViewController(gameDetailVC, animated: true)
    }
}


