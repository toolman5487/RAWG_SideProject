//
//  InfoPillCell.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/16.
//

import Foundation
import UIKit
import SnapKit

class InfoPillCell: UICollectionViewCell {
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center
        label.textColor = .systemBackground
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
        backgroundColor = .label
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        contentView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configure(with text: String) {
        valueLabel.text = text
    }
}
