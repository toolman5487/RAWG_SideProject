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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with screenshot: Screenshot) {
        if let imageUrl = screenshot.image {
            imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(systemName: "gamecontroller.circle.fill"))
        }
    }
}
