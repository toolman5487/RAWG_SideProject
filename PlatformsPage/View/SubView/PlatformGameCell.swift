//
//  PlatformGameCell.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/10/19.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

class PlatformGameCell: UICollectionViewCell {
    
    private lazy var gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .tertiaryLabel
        return imageView
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
        contentView.addSubview(gameImageView)
        
        gameImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with game: PlatformGame) {
        if let imageURL = game.backgroundImage {
            gameImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(systemName: "gamecontroller.fill"))
        } else {
            gameImageView.image = UIImage(systemName: "gamecontroller.fill")
            gameImageView.tintColor = .label
            gameImageView.layer.cornerRadius = 8
            gameImageView.clipsToBounds = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gameImageView.image = nil
    }
}
