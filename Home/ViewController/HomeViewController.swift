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
        resultsVC.onSelect = { [weak self] item in
            // push 到詳情頁等動作
        }
    }
    
    private func setupNavigation() {
        self.title = "RAWG"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !query.isEmpty else {
            resultsVC.results = []
            return
        }
        // TODO: 呼叫搜尋後指派結果
        // resultsVC.results = fetchedResults
    }
}
