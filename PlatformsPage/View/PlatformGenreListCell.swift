//
//  PlatformGenreListCell.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/10/19.
//

import Foundation
import UIKit
import SnapKit

protocol PlatformGenreListCellDelegate: AnyObject {
    func didSelectGenreType(_ genreType: GenreType)
}

class PlatformGenreListCell: UITableViewCell {
    
    weak var delegate: PlatformGenreListCellDelegate?
    
    private var genreTypes: [GenreType] = []
    private var selectedGenreType: GenreType = .all
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GenreButtonCell.self, forCellWithReuseIdentifier: "GenreButtonCell")
        return collectionView
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
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(48)
        }
    }
    
    func configure(with genreTypes: [GenreType], selectedGenreType: GenreType) {
        self.genreTypes = genreTypes
        self.selectedGenreType = selectedGenreType
        collectionView.reloadData()
    }
}

extension PlatformGenreListCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genreTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreButtonCell", for: indexPath) as! GenreButtonCell
        let genreType = genreTypes[indexPath.item]
        let isSelected = genreType == selectedGenreType
       
        let tempGenre = GameGenreModel(
            id: genreType.id,
            name: genreType.displayName,
            slug: genreType.genreModel?.slug ?? "all",
            gamesCount: genreType.genreModel?.gamesCount ?? 0,
            imageBackground: genreType.genreModel?.imageBackground
        )
        
        cell.configure(with: tempGenre, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let genreType = genreTypes[indexPath.item]
        delegate?.didSelectGenreType(genreType)

        for cell in collectionView.visibleCells {
            if let genreCell = cell as? GenreButtonCell {
                genreCell.setSelected(false)
            }
        }
        
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? GenreButtonCell {
            selectedCell.setSelected(true)
        }
    }
}

extension PlatformGenreListCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let genreType = genreTypes[indexPath.item]
        let text = genreType.displayName
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let textSize = text.size(withAttributes: [.font: font])
        let width = textSize.width + 24 
        return CGSize(width: width, height: 40)
    }
}
