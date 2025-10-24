//
//  GameItemCell.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/10/19.
//

import Foundation
import UIKit
import SnapKit

class GameItemCell: UITableViewCell {
    
    private lazy var gameNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.label
        label.textAlignment = .left
        return label
    }()
    
    private lazy var addedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor.secondaryLabel
        label.textAlignment = .right
        return label
    }()
    
    private lazy var bookmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bookmark.fill")
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(gameNameLabel)
        contentView.addSubview(addedLabel)
        contentView.addSubview(bookmarkImageView)
        
        gameNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(addedLabel.snp.leading).offset(-8)
        }
        
        bookmarkImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
        
        addedLabel.snp.makeConstraints { make in
            make.trailing.equalTo(bookmarkImageView.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with game: PlatformGame) {
        gameNameLabel.text = game.name
        addedLabel.text = game.added.formatted()
    }
}
