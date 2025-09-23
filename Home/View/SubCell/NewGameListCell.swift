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
import Combine

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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
        imageView.sd_cancelCurrentImageLoad()
        imageView.image = nil
        titleLabel.text = nil
        releaseDateLabel.text = nil
        imageView.hideSkeleton()
    }
    
    private func imageLoadingPublisher(for imageURL: String?) -> AnyPublisher<ImageLoadingState, Never> {
        guard let imageURL = imageURL, let url = URL(string: imageURL) else {
            return Just(.placeholder).eraseToAnyPublisher()
        }
        
        return Future<ImageLoadingState, Never> { promise in
            DispatchQueue.main.async {
                self.imageView.showAnimatedGradientSkeleton()
            }
            
            self.imageView.sd_setImage(with: url) { image, error, _, _ in
                if let image = image {
                    promise(.success(.loaded(image)))
                } else {
                    promise(.success(.failed))
                }
            }
        }
        .prepend(.loading)
        .eraseToAnyPublisher()
    }
    
    private func handleImageState(_ state: ImageLoadingState) {
        switch state {
        case .loading:
            imageView.showAnimatedGradientSkeleton()
        case .loaded(let image):
            imageView.hideSkeleton()
            imageView.image = image
        case .failed:
            imageView.hideSkeleton()
            imageView.image = UIImage(systemName: "photo")
            imageView.tintColor = .secondaryLabel
        case .placeholder:
            imageView.hideSkeleton()
            imageView.image = UIImage(systemName: "photo")
            imageView.tintColor = .secondaryLabel
        }
    }
    
    func configure(with game: GameListItemModel) {
        cancellables.removeAll()
        
        titleLabel.text = game.name
        releaseDateLabel.text = game.released ?? "TBA"
        
        imageLoadingPublisher(for: game.backgroundImage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleImageState(state)
            }
            .store(in: &cancellables)
    }
}
