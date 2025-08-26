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
        let controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search Games ..."
        return controller
    }()
    
// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigation()
    }
    
    private func setupNavigation() {
        self.title = "RAWG"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}
