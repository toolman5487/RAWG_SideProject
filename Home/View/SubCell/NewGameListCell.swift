//
//  NewGameListCell.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/9/13.
//
 
import Foundation
import UIKit
import SnapKit
import SDWebImage
import SkeletonView

class NewGameListCell: UICollectionViewCell {
    
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
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        return label
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
        releaseDateLabel.isSkeletonable = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(releaseDateLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        
        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        releaseDateLabel.text = nil
        DispatchQueue.main.async {
            self.showSkeletonForAll()
        }
    }
    
    private func showSkeletonForAll() {
        DispatchQueue.main.async {
            self.imageView.showAnimatedGradientSkeleton()
            self.titleLabel.showAnimatedGradientSkeleton()
            self.releaseDateLabel.showAnimatedGradientSkeleton()
        }
    }
    
    private func hideSkeletonForLabels() {
        DispatchQueue.main.async {
            self.titleLabel.hideSkeleton()
            self.releaseDateLabel.hideSkeleton()
        }
    }
    
    private func hideSkeletonForImage() {
        DispatchQueue.main.async {
            self.imageView.hideSkeleton()
        }
    }
    
    func configure(with game: GameListItemModel) {
        DispatchQueue.main.async {
            self.titleLabel.text = game.name
            if let released = game.released {
                self.releaseDateLabel.text = released
            } else {
                self.releaseDateLabel.text = "TBA"
            }
            self.hideSkeletonForLabels()
        }
        
        if let imageURL = game.backgroundImage, let url = URL(string: imageURL) {
            DispatchQueue.main.async {
                self.imageView.showAnimatedGradientSkeleton()
            }
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
