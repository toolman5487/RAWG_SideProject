//
//  SearchResultCell.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/31.
//

import UIKit
import SnapKit
import SDWebImage

class SearchResultCell: UITableViewCell {
    
    // MARK: - UI Components
    private let gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8  
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        selectionStyle = .none
        
        contentView.addSubview(gameImageView)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(titleLabel)
        contentView.addSubview(releaseDateLabel)
        
        gameImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(gameImageView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(gameImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
        }
        
        releaseDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    // MARK: - Configuration
    func configure(with game: GameSearchResult) {
        titleLabel.text = game.name
        releaseDateLabel.text = game.released ?? "Release date unknown"
        
        if let imageURLString = game.backgroundImage {
            activityIndicator.startAnimating()
            gameImageView.sd_setImage(
                with: URL(string: imageURLString),
                placeholderImage: nil,
                options: [.progressiveLoad, .refreshCached],
                completed: { [weak self] _, _, _, _ in
                    self?.activityIndicator.stopAnimating()
                }
            )
        } else {
            gameImageView.image = nil
            activityIndicator.startAnimating()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gameImageView.sd_cancelCurrentImageLoad()
        gameImageView.image = nil
        activityIndicator.stopAnimating()
        titleLabel.text = nil
        releaseDateLabel.text = nil
    }
}
