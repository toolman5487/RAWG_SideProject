//
//  ScreenshotItemCell.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/23.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

class ScreenshotItemCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = .label
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(activityIndicator)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configure(with screenshot: Screenshot) {
        if let imageUrl = screenshot.image {
            activityIndicator.startAnimating()
            
            let options: SDWebImageOptions = [
                .progressiveLoad,
                .refreshCached,
                .highPriority,
                .avoidAutoSetImage
            ]
            
            imageView.sd_setImage(
                with: URL(string: imageUrl),
                placeholderImage: UIImage(systemName: "gamecontroller.circle.fill")?.withTintColor(.label, renderingMode: .alwaysOriginal),
                options: options,
                completed: { [weak self] image, error, cacheType, url in
                    DispatchQueue.main.async {
                        self?.activityIndicator.stopAnimating()
                        
                        if let image = image {
                            self?.imageView.image = image
                        }
                    }
                }
            )
        } else {
            imageView.image = UIImage(systemName: "gamecontroller.circle.fill")
            imageView.tintColor = .label
        }
    }
}
