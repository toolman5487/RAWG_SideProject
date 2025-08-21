//
//  GameDetailTableView.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/10.
//

import Foundation
import UIKit
import SnapKit

class GameDetailTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        setupTableViewStyle()
        registerCells()
    }
    
    private func setupTableViewStyle() {
        backgroundColor = .systemBackground
        separatorStyle = .none
        allowsSelection = false
        rowHeight = UITableView.automaticDimension
    }
    
    private func registerCells() {
        register(ImageCarouselCell.self, forCellReuseIdentifier: "ImageCarouselCell")
        register(GameInfoCell.self, forCellReuseIdentifier: "GameInfoCell")
        register(RatingCell.self, forCellReuseIdentifier: "RatingCell")
        register(DescriptionCell.self, forCellReuseIdentifier: "DescriptionCell")
        register(MetacriticCell.self, forCellReuseIdentifier: "MetacriticCell")
    }
}



