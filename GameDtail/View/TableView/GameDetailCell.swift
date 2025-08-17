//
//  GameDetailCell.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/16.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage


// MARK: - HeaderImage
class GameHeaderCell: UITableViewCell {
    
    private let gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(gameImageView)
        gameImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(gameImageView.snp.width).multipliedBy(0.6)
            make.bottom.equalToSuperview() 
        }
    }
    
    func configure(with game: GameDetailModel?) {
        guard let game = game else { return }
        if let imageUrl = game.backgroundImage {
            gameImageView.sd_setImage(with: URL(string: imageUrl))
        }
    }
}

// MARK: - Info
class GameInfoCell: UITableViewCell {
    
    private var infoItems: [String] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(collectionView)
        contentView.addSubview(descriptionLabel)
        
        collectionView.register(InfoPillCell.self, forCellWithReuseIdentifier: "InfoPillCell")
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }

    func configure(with game: GameDetailModel?) {
        guard let game = game else { return }
        
        infoItems.removeAll()
        
        if let released = game.released {
            infoItems.append("Released: \(released)")
        }
        
        if game.tba == true {
            infoItems.append("TBA")
        }
        
        if let esrbRating = game.esrbRating?.name {
            infoItems.append("ESRB: \(esrbRating)")
        }
        
        if let updated = game.updated {
            infoItems.append("Updated: \(updated)")
        }
        
        if let description = game.description {
            let cleanDescription = description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            descriptionLabel.text = cleanDescription
        } else {
            descriptionLabel.text = "No description available."
        }
        
        collectionView.reloadData()
    }
}

extension GameInfoCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infoItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoPillCell", for: indexPath) as! InfoPillCell
        let text = infoItems[indexPath.item]
        cell.configure(with: text)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = infoItems[indexPath.item]
        let textWidth = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .semibold)]).width
        return CGSize(width: textWidth + 32, height: 40)
    }
}

// MARK: - Rating
class RatingCell: UITableViewCell {
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let starStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()
    
    private let totalRatingsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(ratingLabel)
        contentView.addSubview(starStackView)
        contentView.addSubview(totalRatingsLabel)
        
        ratingLabel.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
        }
        
        starStackView.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        totalRatingsLabel.snp.makeConstraints { make in
            make.top.equalTo(starStackView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
        
        setupStars()
    }
    
    private func setupStars() {
        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.image = UIImage(systemName: "star")
            starImageView.tintColor = .systemYellow
            starImageView.contentMode = .scaleAspectFit
            starStackView.addArrangedSubview(starImageView)
        }
    }
    
    func configure(with game: GameDetailModel?) {
        guard let game = game else { return }
        
        if let rating = game.rating {
            ratingLabel.text = String(format: "%.1f", rating)
            updateStars(rating: rating)
        } else {
            ratingLabel.text = "N/A"
        }
        
        if let ratingsCount = game.ratingsCount {
            totalRatingsLabel.text = "\(ratingsCount) ratings"
        } else {
            totalRatingsLabel.text = "No ratings"
        }
    }
    
    private func updateStars(rating: Double) {
        let fullStars = Int(rating)
        let hasHalfStar = rating.truncatingRemainder(dividingBy: 1) >= 0.5
        for (index, starView) in starStackView.arrangedSubviews.enumerated() {
            guard let starImageView = starView as? UIImageView else { continue }
            
            if index < fullStars {
                starImageView.image = UIImage(systemName: "star.fill")
                starImageView.tintColor = .systemYellow
            } else if index == fullStars && hasHalfStar {
                starImageView.image = UIImage(systemName: "star.leadinghalf.filled")
                starImageView.tintColor = .systemYellow
            } else {
                starImageView.image = UIImage(systemName: "star")
                starImageView.tintColor = .systemGray3
            }
        }
    }
}
