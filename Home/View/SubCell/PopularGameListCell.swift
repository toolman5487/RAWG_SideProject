//
//  PopularGameListCell.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/9/21.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage
import SkeletonView

class PopularGameListCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.8
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemYellow
        return label
    }()
    
    private lazy var ratingIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .systemOrange
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.isSkeletonable = true
        imageView.isSkeletonable = true
        titleLabel.isSkeletonable = true
        ratingIcon.isSkeletonable = true
        ratingLabel.isSkeletonable = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingIcon)
        contentView.addSubview(ratingLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        
        ratingIcon.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview()
            make.size.equalTo(12)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ratingIcon)
            make.leading.equalTo(ratingIcon.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.sd_cancelCurrentImageLoad()
        imageView.image = nil
        titleLabel.text = nil
        ratingLabel.text = nil
        DispatchQueue.main.async {
            self.titleLabel.hideSkeleton()
            self.ratingIcon.hideSkeleton()
            self.ratingLabel.hideSkeleton()
            self.imageView.hideSkeleton()
        }
    }
    
    private func showAllSkeleton() {
        DispatchQueue.main.async {
            self.imageView.showAnimatedGradientSkeleton()
            self.titleLabel.showAnimatedGradientSkeleton()
            self.ratingIcon.showAnimatedGradientSkeleton()
            self.ratingLabel.showAnimatedGradientSkeleton()
        }
    }
    
    private func hideSkeletonForLabels() {
        DispatchQueue.main.async {
            self.titleLabel.hideSkeleton()
            self.ratingIcon.hideSkeleton()
            self.ratingLabel.hideSkeleton()
        }
    }
    
    private func hideSkeletonForImage() {
        DispatchQueue.main.async {
            self.imageView.hideSkeleton()
        }
    }
    
    func configure(with game: GameListItemModel) {
        showAllSkeleton()
        
        titleLabel.text = game.name
        if let rating = game.rating, rating > 0 {
            ratingLabel.text = String(format: "%.1f", rating)
        } else {
            ratingLabel.text = "N/A"
        }
        
        DispatchQueue.main.async {
            self.hideSkeletonForLabels()
        }
        
        if let imageURL = game.backgroundImage, let url = URL(string: imageURL) {
            imageView.sd_setImage(with: url) { [weak self] _, _, _, _ in
                self?.hideSkeletonForImage()
            }
        } else {
            DispatchQueue.main.async {
                self.imageView.image = UIImage(systemName: "photo")
                self.imageView.tintColor = .secondaryLabel
                self.hideSkeletonForImage()
            }
        }
    }
}

