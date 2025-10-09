//
//  PopularGameViewCell.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/10/7.
//

import Foundation
import UIKit
import SnapKit

protocol PopularGenreListCellDelegate: AnyObject {
    func didSelectGenreType(_ genreType: GenreType)
}

// MARK: - NewGame GenreList

class PopularGenreListCell: UITableViewCell {
    
    weak var delegate: PopularGenreListCellDelegate?
    private var genreTypes: [GenreType] = []
    private var selectedIndex: Int = 0
    
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
    
    func configure(with genreTypes: [GenreType], selectedGenreType: GenreType? = nil) {
        self.genreTypes = genreTypes
       
        if let selectedGenreType = selectedGenreType {
            selectedIndex = genreTypes.firstIndex { genreType in
                switch (genreType, selectedGenreType) {
                case (.all, .all):
                    return true
                case (.genre(let g1), .genre(let g2)):
                    return g1.id == g2.id
                default:
                    return false
                }
            } ?? 0
        }
        
        collectionView.reloadData()
    }
}

extension PopularGenreListCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genreTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreButtonCell", for: indexPath) as! GenreButtonCell
        let genreType = genreTypes[indexPath.item]
        
        let tempGenre = GameGenreModel(
            id: genreType.id,
            name: genreType.displayName,
            slug: genreType.genreModel?.slug ?? "all",
            gamesCount: genreType.genreModel?.gamesCount ?? 0,
            imageBackground: genreType.genreModel?.imageBackground
        )
        
        cell.configure(with: tempGenre, isSelected: indexPath.item == selectedIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedGenreType = genreTypes[indexPath.item]
        delegate?.didSelectGenreType(selectedGenreType)
        selectedIndex = indexPath.item

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
