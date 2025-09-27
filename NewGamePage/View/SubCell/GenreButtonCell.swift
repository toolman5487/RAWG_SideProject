//
//  GenreButtonCell.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/9/27.
//

import Foundation
import UIKit
import SnapKit

class GenreButtonCell: UICollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
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
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        backgroundColor = .systemBackground
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(8)
        }
    }
    
    func configure(with genre: GameGenreModel, isSelected: Bool) {
        titleLabel.text = genre.name
        setSelected(isSelected)
    }
    
    func setSelected(_ selected: Bool) {
        if selected {
            backgroundColor = .systemBlue
            titleLabel.textColor = .white
            layer.borderColor = UIColor.systemBlue.cgColor
        } else {
            backgroundColor = .systemBackground
            titleLabel.textColor = .label
            layer.borderColor = UIColor.systemGray4.cgColor
        }
    }
}
