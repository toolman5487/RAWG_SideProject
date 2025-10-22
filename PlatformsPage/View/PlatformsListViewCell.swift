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
    
    
    
    private lazy var gamesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
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
        
        gamesStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
    }
    
    func configure(with platform: PlatformModel) {
        titleLabel.text = platform.name
        
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
        let displayGames = Array(games.prefix(3))
        
        for game in displayGames {
            let containerView = UIView()
            
            let gameNameLabel = UILabel()
            gameNameLabel.text = game.name
            gameNameLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
            gameNameLabel.textColor = UIColor.label
            
            let addedLabel = UILabel()
            addedLabel.text = game.added.formatted()
            addedLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            addedLabel.textColor = UIColor.secondaryLabel
            
            let bookmarkImageView = UIImageView()
            bookmarkImageView.image = UIImage(systemName: "bookmark.fill")
            bookmarkImageView.tintColor = .secondaryLabel
            bookmarkImageView.contentMode = .scaleAspectFit
            
            containerView.addSubview(gameNameLabel)
            containerView.addSubview(addedLabel)
            containerView.addSubview(bookmarkImageView)
            
            gameNameLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.centerY.equalToSuperview()
                make.top.bottom.equalToSuperview()
            }
            
            addedLabel.snp.makeConstraints { make in
                make.trailing.equalTo(bookmarkImageView.snp.leading).offset(-8)
                make.centerY.equalToSuperview()
            }
            
            bookmarkImageView.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
                make.centerY.equalToSuperview()
                make.width.height.equalTo(16)
            }
            
            containerView.snp.makeConstraints { make in
                make.height.equalTo(20)
            }
            
            gamesStackView.addArrangedSubview(containerView)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        backgroundImageView.image = nil
        gamesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}
