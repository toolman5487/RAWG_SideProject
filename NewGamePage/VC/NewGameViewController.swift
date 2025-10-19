//
//  NewGameViewController.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/9/14.
//

import Foundation
import UIKit
import Combine
import SnapKit
import SDWebImage

class NewGameViewController: UIViewController {
    
    private let gameGenreViewModel = NewGameViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return control
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .secondaryLabel
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New and Trending"
        view.backgroundColor = .systemBackground
        setupUI()
        bindingViewModel()
        fetchGenres()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        tableView.register(NGgenreListCell.self, forCellReuseIdentifier: "NGgenreListCell")
        tableView.register(NGgameListCell.self, forCellReuseIdentifier: "NGgameListCell")
        tableView.refreshControl = refreshControl
    }
    
    private func bindingViewModel() {
        gameGenreViewModel.$genreTypes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        gameGenreViewModel.$games
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        gameGenreViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loading in
                if loading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
                if !loading {
                    self?.refreshControl.endRefreshing()
                }
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func fetchGenres() {
        gameGenreViewModel.fetchGenres()
    }
    
    @objc private func handleRefresh() {
        fetchGenres()
    }
}

extension NewGameViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NGgenreListCell", for: indexPath) as! NGgenreListCell
            cell.configure(with: gameGenreViewModel.genreTypes, selectedGenreType: gameGenreViewModel.selectedGenreType)
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NGgameListCell", for: indexPath) as! NGgameListCell
            cell.configure(with: gameGenreViewModel.games)
            cell.delegate = self
            cell.isHidden = gameGenreViewModel.isLoading
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 48
        } else {
            guard !gameGenreViewModel.games.isEmpty else {
                return 100
            }
            
            let rows = (gameGenreViewModel.games.count + 2) / 3
            let cellHeight: CGFloat = 200
            let spacing: CGFloat = 16
            let topInset: CGFloat = 16
            let bottomInset: CGFloat = 16
            
            return CGFloat(rows) * cellHeight + CGFloat(max(rows - 1, 0)) * spacing + topInset + bottomInset
        }
    }
}

extension NewGameViewController: NGgenreListCellDelegate {
    func didSelectGenreType(_ genreType: GenreType) {
        gameGenreViewModel.selectGenreType(genreType)
    }
}

extension NewGameViewController: NGgameListCellDelegate {
    func didSelectGame(_ game: GameListItemModel) {
        let gameDetailVC = GameDetailViewController(gameId: game.id)
        navigationController?.pushViewController(gameDetailVC, animated: true)
    }
}
