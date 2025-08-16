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
    
    private let gameDetailVM = GameDetailViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView: GameDetailTableView = {
        let tableView = GameDetailTableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindingVM()
        fetchGameDetail()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindingVM() {
        gameDetailVM.$gameDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] gameDetail in
                self?.title = gameDetail?.nameOriginal ?? "Unknown Game"
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        gameDetailVM.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] errorMessage in
                guard let self = self else { return }
                AlertHelper.showErrorAlert(from: self, message: errorMessage)
            }
            .store(in: &cancellables)
    }
    
    private func fetchGameDetail() {
        gameDetailVM.fetchGameDetail(gameId: 46889)
    }
}

extension GameDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameDetailVM.gameDetail != nil ? 2 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GameHeaderCell", for: indexPath) as! GameHeaderCell
            cell.configure(with: gameDetailVM.gameDetail)
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GameInfoCell", for: indexPath) as! GameInfoCell
            cell.configure(with: gameDetailVM.gameDetail)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
