//
//  SearchResultsViewController.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/27.
//
import UIKit
import SnapKit
import Combine

final class SearchResultsViewController: UIViewController {
    
    let gameSelected = PassthroughSubject<GameSearchResult, Never>()
    var results: [GameSearchResult] = [] {
        didSet { tableView.reloadData() }
    }
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.register(SearchResultCell.self, forCellReuseIdentifier: "SearchResultCell")
        tableView.rowHeight = 80
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SearchResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 
        results.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        let item = results[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGame = results[indexPath.row]
        gameSelected.send(selectedGame)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
