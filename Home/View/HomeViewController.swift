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
    
    
// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = "RAWG"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
}
