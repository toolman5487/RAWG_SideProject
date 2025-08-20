//
//  ImageCarouselItemCell.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/20.
//

import Foundation
import UIKit
import SnapKit

class ImageCarouselItemCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
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
    
    func configure(with imageUrl: String) {
        imageView.sd_setImage(with: URL(string: imageUrl))
    }
}
