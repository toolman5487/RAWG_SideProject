//
//  GameHeaderCell.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/10.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

class GameHeaderCell: UITableViewCell {
    
    private let gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(gameImageView)
        gameImageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
            make.height.equalTo(gameImageView.snp.width).multipliedBy(0.6)
        }
    }
    
    func configure(with game: GameDetailModel?) {
        guard let game = game else { return }
        if let imageUrl = game.backgroundImage {
            gameImageView.sd_setImage(with: URL(string: imageUrl))
        }
    }
}
