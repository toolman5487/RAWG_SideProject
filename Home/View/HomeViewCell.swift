//
//  HomeViewCell.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/9/7.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage
import Combine

// MARK: - NewGame
class NewGameCell: UITableViewCell {
    
    private var games: [GameListItemModel] = []
    private var cancellables = Set<AnyCancellable>()
    
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
        collectionView.dataSource = self
        collectionView.delegate = self
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(200)
        }
    }
    
    func configure(title: String, gamesPublisher: AnyPublisher<[GameListItemModel], Never>) {
        titleLabel.text = title
        
        gamesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] games in
                self?.games = games
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension NewGameCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewGameListCell", for: indexPath) as! NewGameListCell
        cell.configure(with: games[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 32
        let spacing: CGFloat = 16
        let itemWidth = (screenWidth - padding - spacing) / 3
        return CGSize(width: itemWidth, height: 200)
    }
}
