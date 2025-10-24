//
//  PlatformsListViewCell.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/10/19.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

class PlatformsListViewCell: UICollectionViewCell {
    
    private var platformGames: [PlatformGame] = []
    private var currentPlatformBackgroundImage: String?
    private var displayGames: [PlatformGame] = []
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    
    
    private lazy var gamesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(GameItemCell.self, forCellReuseIdentifier: "GameItemCell")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(overlayView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(gamesTableView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        gamesTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
            make.height.equalTo(120)
        }
        
        gamesTableView.delegate = self
        gamesTableView.dataSource = self
    }
    
    func configure(with platform: PlatformModel) {
        titleLabel.text = platform.name
        
        if let imageURL = platform.imageBackground {
            backgroundImageView.sd_setImage(with: URL(string: imageURL))
        } else {
            backgroundImageView.image = UIImage(systemName: "gamecontroller.fill")
            backgroundImageView.tintColor = .secondaryLabel
            backgroundImageView.contentMode = .scaleAspectFit
        }
        
        setupGamesList(platform.games ?? [])
    }
    
    private func setupGamesList(_ games: [PlatformGame]) {
        displayGames = Array(games.prefix(5))
        gamesTableView.reloadData()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        backgroundImageView.image = nil
        displayGames = []
    }
}

extension PlatformsListViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameItemCell", for: indexPath) as! GameItemCell
        let game = displayGames[indexPath.row]
        cell.configure(with: game)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 24
    }
}
