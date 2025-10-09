//
//  PopularGameViewController.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/9/21.
//

import Foundation
import UIKit
import Combine
import SnapKit
import SDWebImage

class PopularGameViewController: UIViewController {
    
    private let viewModel = GameGenreViewModel()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Popular"
        view.backgroundColor = .systemBackground
        setupUI()
        bindingViewModel()
        viewModel.fetchGenres()
    }
    
    private func setupUI(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.register(PopularGenreListCell.self, forCellReuseIdentifier: "PopularGenreListCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension PopularGameViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PopularGenreListCell", for: indexPath) as! PopularGenreListCell
            cell.configure(with: viewModel.genreTypes, selectedGenreType: viewModel.selectedGenreType)
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.backgroundColor = UIColor.systemGray6
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 48
        } else {
            return UITableView.automaticDimension
        }
    }
}

extension PopularGameViewController: PopularGenreListCellDelegate {
    func didSelectGenreType(_ genreType: GenreType) {
        viewModel.selectGenreType(genreType)
    }
}
