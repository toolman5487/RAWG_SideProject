//
//  MetacriticPlatformCell.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/21.
//

import Foundation
import UIKit
import SnapKit

class MetacriticPlatformCell: UICollectionViewCell {
    
    private let platformIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        return imageView
    }()
    
    private let platformNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
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
        backgroundColor = .systemGray6
        layer.cornerRadius = 10
        
        let stackView = UIStackView(arrangedSubviews: [platformIcon, platformNameLabel, scoreLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.distribution = .fill
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        platformIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
    }
    
    func configure(with platform: MetacriticPlatform, viewModel: GameDetailViewModel?) {
        platformNameLabel.text = platform.platform?.name ?? "Unknown"
        
        if let metascore = platform.metascore {
            let attributedString = NSMutableAttributedString()
            
            let scoreAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16, weight: .bold),
                .foregroundColor: viewModel?.getMetacriticColor(for: metascore) ?? .label
            ]
            
            let separatorAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16, weight: .medium),
                .foregroundColor: UIColor.label
            ]
            
            attributedString.append(NSAttributedString(string: "\(metascore)", attributes: scoreAttributes))
            attributedString.append(NSAttributedString(string: " / 100", attributes: separatorAttributes))
            
            scoreLabel.attributedText = attributedString
        } else {
            scoreLabel.text = "N/A"
            scoreLabel.textColor = .secondaryLabel
        }
        
        let iconName = viewModel?.getPlatformIcon(for: platform.platform?.name ?? "") ?? "gamecontroller"
        platformIcon.image = UIImage(systemName: iconName)
    }
}
