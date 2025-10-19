//
//  PopularGameDetailCell.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/10/19.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage
import SkeletonView
import Combine

class PopularGameDetailCell: UICollectionViewCell {
    
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
    
    private var cancellables = Set<AnyCancellable>()
    
    private enum ImageLoadingState {
        case loading
        case loaded(UIImage)
        case failed
        case placeholder
    }
    
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
        ratingLabel.isSkeletonable = true
        ratingIcon.isSkeletonable = true
        
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
        cancellables.removeAll()
        imageView.sd_cancelCurrentImageLoad()
        imageView.image = nil
        titleLabel.text = nil
        ratingLabel.text = nil
        contentView.hideSkeleton()
    }
    
    private func imageLoadingPublisher(for imageURL: String?) -> AnyPublisher<ImageLoadingState, Never> {
        guard let imageURL = imageURL, let url = URL(string: imageURL) else {
            return Just(.placeholder).eraseToAnyPublisher()
        }
        
        return Future<ImageLoadingState, Never> { promise in
            self.imageView.sd_setImage(with: url) { image, error, _, _ in
                if let image = image {
                    promise(.success(.loaded(image)))
                } else {
                    promise(.success(.failed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func handleImageState(_ state: ImageLoadingState) {
        switch state {
        case .loading:
            break
        case .loaded(let image):
            contentView.hideSkeleton()
            imageView.image = image
        case .failed:
            contentView.hideSkeleton()
            imageView.image = UIImage(systemName: "gamecontroller.circle.fill")
            imageView.tintColor = .secondaryLabel
            imageView.contentMode = .scaleAspectFill
        case .placeholder:
            contentView.hideSkeleton()
            imageView.image = UIImage(systemName: "gamecontroller.circle.fill")
            imageView.tintColor = .secondaryLabel
            imageView.contentMode = .scaleAspectFill
        }
    }
    
    func configure(with game: GameListItemModel) {
        cancellables.removeAll()
        contentView.showAnimatedGradientSkeleton()
        imageLoadingPublisher(for: game.backgroundImage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleImageState(state)
                self?.titleLabel.text = game.name
                if let rating = game.rating, rating > 0 {
                    self?.ratingLabel.text = String(format: "%.1f", rating)
                } else {
                    self?.ratingLabel.text = "N/A"
                }
            }
            .store(in: &cancellables)
    }

    func showPlaceholder() {
        cancellables.removeAll()
        
        contentView.showAnimatedGradientSkeleton()
        titleLabel.text = ""
        ratingLabel.text = ""
    }
}
