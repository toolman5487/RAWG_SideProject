//
//  NewGameViewCell.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/9/27.
//

import Foundation
import UIKit
import SnapKit

protocol NGgenreListCellDelegate: AnyObject {
    func didSelectGenre(_ genre: GameGenreModel)
}

// MARK: - NewGame GenreList

class NGgenreListCell: UITableViewCell {
    
    weak var delegate: NGgenreListCellDelegate?
    private var genres: [GameGenreModel] = []
    
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
    
    func configure(with genres: [GameGenreModel]) {
        self.genres = genres
        collectionView.reloadData()
    }
}

extension NGgenreListCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreButtonCell", for: indexPath) as! GenreButtonCell
        let genre = genres[indexPath.item]
        cell.configure(with: genre, isSelected: indexPath.item == 0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedGenre = genres[indexPath.item]
        delegate?.didSelectGenre(selectedGenre)
        
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

// MARK: - NewGame Collection

protocol NGgameListCellDelegate: AnyObject {
    func didSelectGame(_ game: GameListItemModel)
}

class NGgameListCell: UITableViewCell {
    
    weak var delegate: NGgameListCellDelegate?
    private var games: [GameListItemModel] = []
    private var heightConstraint: Constraint?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NewGameListCell.self, forCellWithReuseIdentifier: "NewGameListCell")
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
            heightConstraint = make.height.equalTo(100).constraint
        }
    }
    
    func configure(with games: [GameListItemModel]) {
        self.games = games
        collectionView.reloadData()
        
        let rows = (games.count + 2) / 3
        let cellHeight: CGFloat = 160
        let spacing: CGFloat = 16
        let totalHeight = CGFloat(rows) * cellHeight + CGFloat(rows - 1) * spacing + 32
        
        heightConstraint?.update(offset: totalHeight)
    }
}

extension NGgameListCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewGameListCell", for: indexPath) as! NewGameListCell
        cell.configure(with: games[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedGame = games[indexPath.item]
        delegate?.didSelectGame(selectedGame)
    }
}

extension NGgameListCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 56) / 3
        return CGSize(width: width, height: 160)
    }
} 
