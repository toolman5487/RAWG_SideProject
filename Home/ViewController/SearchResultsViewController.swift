//
//  SearchResultsViewController.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/27.
//
import UIKit
import SnapKit

final class SearchResultsViewController: UIViewController {
    
    let tableView = UITableView()
    var results: [GameSearchResult] = [] {
        didSet { tableView.reloadData() }
    }
    var onSelect: ((GameSearchResult) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SearchResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { results.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = results[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelect?(results[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
