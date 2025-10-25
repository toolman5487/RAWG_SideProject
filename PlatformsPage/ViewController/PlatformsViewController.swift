//
//  PlatformsViewController.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/10/25.
//

import Foundation
import UIKit
import SnapKit
import Combine

class PlatformsViewController: UIViewController {
    
    var selectedPlatform: PlatformModel?
    private let viewModel = PlatformGamesViewModel()
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
        view.backgroundColor = .systemBackground
        
        if let platform = selectedPlatform {
            self.title = platform.name
            viewModel.configure(with: platform)
        } else {
            self.title = "Platforms"
        }
        
        setupUI()
        bindingViewModel()
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
        
        tableView.register(PlatformGenreListCell.self, forCellReuseIdentifier: "PlatformGenreListCell")
        tableView.register(PlatformGameListCell.self, forCellReuseIdentifier: "PlatformGameListCell")
        tableView.refreshControl = refreshControl
    }
    
    private func bindingViewModel() {
        viewModel.$genreTypes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$games
            .receive(on: DispatchQueue.main)
            .sink { [weak self] games in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
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
    
    @objc private func handleRefresh() {
        viewModel.fetchGenres()
    }
}

extension PlatformsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlatformGenreListCell", for: indexPath) as! PlatformGenreListCell
            cell.configure(with: viewModel.genreTypes, selectedGenreType: viewModel.selectedGenreType)
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlatformGameListCell", for: indexPath) as! PlatformGameListCell
            cell.configure(with: viewModel.games)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 48
        } else {
            guard !viewModel.games.isEmpty else {
                return 100
            }
            
            let rows = (viewModel.games.count + 2) / 3
            let cellHeight: CGFloat = 200
            let spacing: CGFloat = 16
            let topInset: CGFloat = 16
            let bottomInset: CGFloat = 16
            
            return CGFloat(rows) * cellHeight + CGFloat(max(rows - 1, 0)) * spacing + topInset + bottomInset
        }
    }
}

extension PlatformsViewController: PlatformGenreListCellDelegate {
    func didSelectGenreType(_ genreType: GenreType) {
        viewModel.selectGenreType(genreType)
    }
}

extension PlatformsViewController: PlatformGameListCellDelegate {
    func didSelectGame(_ game: GameListItemModel) {
        let gameDetailVC = GameDetailViewController(gameId: game.id)
        navigationController?.pushViewController(gameDetailVC, animated: true)
    }
}
