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
    
    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.8)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return button
    }()
    
    private lazy var popularItemsLabel: UILabel = {
        let label = UILabel()
        label.text = "Popular items"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.8)
        return label
    }()
    
    private lazy var gamesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        return stackView
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
        contentView.addSubview(yearLabel)
        contentView.addSubview(followButton)
        contentView.addSubview(popularItemsLabel)
        contentView.addSubview(gamesStackView)
        
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
        
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        followButton.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        popularItemsLabel.snp.makeConstraints { make in
            make.top.equalTo(followButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        gamesStackView.snp.makeConstraints { make in
            make.top.equalTo(popularItemsLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
    }
    
    func configure(with platform: PlatformModel) {
        titleLabel.text = platform.name
        
        if let yearStart = platform.yearStart {
            yearLabel.text = "\(yearStart)"
            yearLabel.isHidden = false
        } else {
            yearLabel.isHidden = true
        }
        
        if let imageURL = platform.imageBackground {
            backgroundImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(systemName: "gamecontroller.fill"))
        } else {
            backgroundImageView.image = UIImage(systemName: "gamecontroller.fill")
            backgroundImageView.tintColor = .systemGray
        }
        
        setupGamesList(platform.games ?? [])
    }
    
    private func setupGamesList(_ games: [PlatformGame]) {
        gamesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let displayGames = Array(games.prefix(6))
        
        for game in displayGames {
            let gameLabel = UILabel()
            gameLabel.text = "\(game.name) \(game.added.formatted())"
            gameLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            gameLabel.textColor = .white.withAlphaComponent(0.9)
            gameLabel.numberOfLines = 1
            
            gamesStackView.addArrangedSubview(gameLabel)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        yearLabel.text = nil
        backgroundImageView.image = nil
        gamesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}
