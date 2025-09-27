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
    
    private let gameGenreViewModel = GameGenreViewModel()
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
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.register(NGgenreListCell.self, forCellReuseIdentifier: "NGgenreListCell")
        tableView.refreshControl = refreshControl
    }
    
    private func bindingViewModel() {
        gameGenreViewModel.$genres
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        gameGenreViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loading in
                if !loading {
                    self?.refreshControl.endRefreshing()
                }
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NGgenreListCell", for: indexPath) as! NGgenreListCell
        cell.configure(with: gameGenreViewModel.genres)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension NewGameViewController: NGgenreListCellDelegate {
    func didSelectGenre(_ genre: GameGenreModel) {
        print("Selected genre: \(genre.name)")
    }
}
