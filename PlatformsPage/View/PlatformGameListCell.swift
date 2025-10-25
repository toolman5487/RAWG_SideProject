//
//  PlatformGameListCell.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/10/19.
//

import Foundation
import UIKit
import SnapKit

protocol PlatformGameListCellDelegate: AnyObject {
    func didSelectGame(_ game: GameListItemModel)
}

class PlatformGameListCell: UITableViewCell {
    
    weak var delegate: PlatformGameListCellDelegate?
    private var games: [GameListItemModel] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PlatformGameDetailCell.self, forCellWithReuseIdentifier: "PlatformGameDetailCell")
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
        }
    }
    
    func configure(with games: [GameListItemModel]) {
        self.games = games
        collectionView.reloadData()
    }
}

extension PlatformGameListCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlatformGameDetailCell", for: indexPath) as! PlatformGameDetailCell
        let game = games[indexPath.item]
        cell.configure(with: game)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let game = games[indexPath.item]
        delegate?.didSelectGame(game)
    }
}

extension PlatformGameListCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 56) / 3
        return CGSize(width: width, height: 200)
    }
}
