//
//  PlatformsListViewCell.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/10/19.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

class PlatformsListViewCell: UICollectionViewCell {
    
    private var platformGames: [PlatformGame] = []
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PlatformGameCell.self, forCellWithReuseIdentifier: "PlatformGameCell")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(120)
        }
    }
    
    func configure(with platform: PlatformModel) {
        let attributedString = NSMutableAttributedString()

        let nameAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .semibold),
            .foregroundColor: UIColor.label
        ]
        let nameString = NSAttributedString(string: "\(platform.name) ", attributes: nameAttributes)
        attributedString.append(nameString)

        let countAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .regular),
            .foregroundColor: UIColor.secondaryLabel
        ]
        let countString = NSAttributedString(string: "(\(platform.gamesCount.formatted()))", attributes: countAttributes)
        attributedString.append(countString)

        let arrowAttachment = NSTextAttachment()
        arrowAttachment.image = UIImage(systemName: "chevron.right")?.withTintColor(.tertiaryLabel, renderingMode: .alwaysOriginal)
        arrowAttachment.bounds = CGRect(x: 0, y: -4, width: 20, height: 20)
        let arrowString = NSAttributedString(attachment: arrowAttachment)
        attributedString.append(arrowString)
        
        titleLabel.attributedText = attributedString
        
        platformGames = platform.games ?? []
        collectionView.reloadData()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.attributedText = nil
        platformGames.removeAll()
    }
}

extension PlatformsListViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return platformGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlatformGameCell", for: indexPath) as! PlatformGameCell
        cell.configure(with: platformGames[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = getScreenWidth()
        let padding: CGFloat = 32
        let spacing: CGFloat = 16
        let itemWidth = (screenWidth - padding - spacing) / 2.5
        return CGSize(width: itemWidth, height: 200)
    }
}

