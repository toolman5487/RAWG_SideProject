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

// MARK: - Banner

protocol BannerCellDelegate: AnyObject {
    func didSelectBannerGame(_ game: GameListItemModel)
}

class BannerCell: UITableViewCell {
    
    weak var delegate: BannerCellDelegate?
    private var games: [GameListItemModel] = []
    private var currentIndex = 0
    private var timer: Timer?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.5)
        pageControl.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        return pageControl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(scrollView)
        contentView.addSubview(pageControl)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(200)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-4)
        }
    }
    
    private func getScreenWidth() -> CGFloat {
        return window?.windowScene?.screen.bounds.width ?? UIScreen.main.bounds.width
    }
    
    func configure(with games: [GameListItemModel]) {
        self.games = games
        setupBannerViews()
        pageControl.numberOfPages = games.count
        startAutoScroll()
    }
    
    private func setupBannerViews() {
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        
        let screenWidth = getScreenWidth()
        
        for (index, game) in games.enumerated() {
            let bannerView = createBannerView(for: game)
            scrollView.addSubview(bannerView)
            
            bannerView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(screenWidth)
                make.height.equalTo(200)
                make.leading.equalToSuperview().offset(CGFloat(index) * screenWidth)
            }
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(games.count) * screenWidth, height: 200)
    }
    
    private func createBannerView(for game: GameListItemModel) -> UIView {
        let containerView = UIView()
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        titleLabel.text = game.name
        
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-32)
        }
        
        if let imageURL = game.backgroundImage {
            imageView.sd_setImage(with: URL(string: imageURL))
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bannerTapped))
        containerView.addGestureRecognizer(tapGesture)
        containerView.tag = games.firstIndex(of: game) ?? 0
        
        return containerView
    }
    
    @objc private func bannerTapped(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view,
              let gameIndex = games.indices.contains(view.tag) ? games[view.tag] : nil else { return }
        delegate?.didSelectBannerGame(gameIndex)
    }
    
    private func startAutoScroll() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.scrollToNext()
        }
    }
    
    private func scrollToNext() {
        guard !games.isEmpty else { return }
        
        currentIndex = (currentIndex + 1) % games.count
        let screenWidth = getScreenWidth()
        let offsetX = CGFloat(currentIndex) * screenWidth
        
        UIView.animate(withDuration: 0.5) {
            self.scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
        }
        
        pageControl.currentPage = currentIndex
    }
    
    deinit {
        timer?.invalidate()
    }
}

extension BannerCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let screenWidth = getScreenWidth()
        currentIndex = Int(scrollView.contentOffset.x / screenWidth)
        pageControl.currentPage = currentIndex
    }
}

// MARK: - NewGame

protocol NewGameCellDelegate: AnyObject {
    func didSelectGame(_ game: GameListItemModel)
    func didSelectNewGameSection()
}

class NewGameCell: UITableViewCell {
    
    private var games: [GameListItemModel] = []
    
    private func getScreenWidth() -> CGFloat {
        return window?.windowScene?.screen.bounds.width ?? UIScreen.main.bounds.width
    }
    private var cancellables = Set<AnyCancellable>()
    weak var delegate: NewGameCellDelegate?
    
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
        let titleText = title
        let chevronImage = UIImage(systemName: "chevron.forward")
        
        let attachment = NSTextAttachment()
        attachment.image = chevronImage?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
        attachment.bounds = CGRect(x: 0, y: 0, width: 16, height: 16)
        
        let attributedString = NSMutableAttributedString(string: titleText + " ")
        attributedString.append(NSAttributedString(attachment: attachment))
        
        titleLabel.attributedText = attributedString
        
        gamesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] games in
                self?.games = games
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            delegate?.didSelectNewGameSection()
        }
    }
}

extension NewGameCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.isEmpty ? 5 : games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewGameListCell", for: indexPath) as! NewGameListCell
        
        if games.isEmpty {
            cell.showPlaceholder()
        } else {
            cell.configure(with: games[indexPath.item])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = getScreenWidth()
        let padding: CGFloat = 32
        let spacing: CGFloat = 16
        let itemWidth = (screenWidth - padding - spacing) / 2.5
        return CGSize(width: itemWidth, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !games.isEmpty else { return }
        let selectedGame = games[indexPath.item]
        delegate?.didSelectGame(selectedGame)
    }
}

// MARK: - PopularGame

protocol PopularGameCellDelegate: AnyObject {
    func didSelectPopularGame(_ game: GameListItemModel)
    func didSelectPopularGameSection()
}

class PopularGameCell: UITableViewCell {
    
    private var games: [GameListItemModel] = []
    
    private func getScreenWidth() -> CGFloat {
        return window?.windowScene?.screen.bounds.width ?? UIScreen.main.bounds.width
    }
    private var cancellables = Set<AnyCancellable>()
    weak var delegate: PopularGameCellDelegate?
    
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
        collectionView.register(PopularGameListCell.self, forCellWithReuseIdentifier: "PopularGameListCell")
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
        let titleText = title
        let chevronImage = UIImage(systemName: "chevron.forward")
        
        let attachment = NSTextAttachment()
        attachment.image = chevronImage?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
        attachment.bounds = CGRect(x: 0, y: 0, width: 16, height: 16)
        
        let attributedString = NSMutableAttributedString(string: titleText + " ")
        attributedString.append(NSAttributedString(attachment: attachment))
        
        titleLabel.attributedText = attributedString
        
        gamesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] games in
                self?.games = games
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            delegate?.didSelectPopularGameSection()
        }
    }
}

extension PopularGameCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.isEmpty ? 5 : games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularGameListCell", for: indexPath) as! PopularGameListCell
        
        if games.isEmpty {
            cell.showPlaceholder()
        } else {
            cell.configure(with: games[indexPath.item])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = getScreenWidth()
        let padding: CGFloat = 32
        let spacing: CGFloat = 16
        let itemWidth = (screenWidth - padding - spacing) / 2.5
        return CGSize(width: itemWidth, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !games.isEmpty else { return }
        let selectedGame = games[indexPath.item]
        delegate?.didSelectPopularGame(selectedGame)
    }
}
