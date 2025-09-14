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
import Combine


// MARK: - ImageCarousel
class ImageCarouselCell: UITableViewCell {
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.pageIndicatorTintColor = .secondaryLabel
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCarouselItemCell.self, forCellWithReuseIdentifier: "ImageCarouselItemCell")
        return collectionView
    }()
    
    private var imageUrls: [String] = []
    
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
        contentView.addSubview(pageControl)
        
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(collectionView.snp.width).multipliedBy(0.6)
            make.bottom.equalToSuperview()
            
            pageControl.snp.makeConstraints { make in
                make.bottom.equalTo(collectionView.snp.bottom).offset(-16)
                make.centerX.equalToSuperview()
                make.height.equalTo(20)
            }
            
            pageControl.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            pageControl.layer.cornerRadius = 10
            pageControl.layer.masksToBounds = true
            pageControl.currentPageIndicatorTintColor = .white
            pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.5)
        }
    }
    
    func configure(with game: GameDetailModel?) {
        guard let game = game else { return }
        
        imageUrls.removeAll()
        if let mainImage = game.backgroundImage {
            imageUrls.append(mainImage)
        }
        if let additionalImage = game.backgroundImageAdditional {
            imageUrls.append(additionalImage)
        }
        
        pageControl.numberOfPages = imageUrls.count
        pageControl.currentPage = 0
        collectionView.reloadData()
    }
}

extension ImageCarouselCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCarouselItemCell", for: indexPath) as! ImageCarouselItemCell
        cell.configure(with: imageUrls[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = page
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
        stackView.alignment = .center
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
    
    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 12
        return stack
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
        
        setupStars()
        
        contentView.addSubview(hStack)
        hStack.addArrangedSubview(ratingLabel)
        hStack.addArrangedSubview(starStackView)
        hStack.addArrangedSubview(totalRatingsLabel)
        
        ratingLabel.setContentHuggingPriority(.required, for: .horizontal)
        ratingLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        totalRatingsLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        starStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        hStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupStars() {
        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.image = UIImage(systemName: "star")
            starImageView.tintColor = .systemYellow
            starImageView.contentMode = .scaleAspectFit
            starImageView.snp.makeConstraints { make in
                make.width.height.equalTo(20)
            }
            starStackView.addArrangedSubview(starImageView)
        }
    }
    
    func configure(with game: GameDetailModel?) {
        guard let game = game else { return }
        
        if let rating = game.rating {
            let roundedRating = round(rating * 10) / 10
            if roundedRating.truncatingRemainder(dividingBy: 1) == 0 {
                ratingLabel.text = String(format: "%.1f / 5.0", roundedRating)
            } else {
                ratingLabel.text = String(format: "%.1f / 5.0", roundedRating)
            }
            updateStars(rating: roundedRating)
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

// MARK: - Info
class GameInfoCell: UITableViewCell {
    
    private var infoItems: [String] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
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
        collectionView.register(InfoPillCell.self, forCellWithReuseIdentifier: "InfoPillCell")
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
    }
    
    func configure(with game: GameDetailModel?) {
        guard let game = game else { return }
        
        infoItems.removeAll()
        if let released = game.released { infoItems.append("Released: \(released)") }
        if game.tba == true { infoItems.append("TBA") }
        if let esrbRating = game.esrbRating?.name { infoItems.append("ESRB: \(esrbRating)") }
        if let updated = game.updated { infoItems.append("Updated: \(updated)") }
        
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

// MARK: - Description
class DescriptionCell: UITableViewCell {
    
    let tapSubject = PassthroughSubject<Void, Never>()
    var tapPublisher: AnyPublisher<Void, Never> { tapSubject.eraseToAnyPublisher() }
    var cancellables = Set<AnyCancellable>()
    
    private let button: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .label
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        let button = UIButton(configuration: config, primaryAction: nil)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.titleLabel?.textAlignment = .left
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        button.setContentHuggingPriority(.required, for: .vertical)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
    }
    
    func configure(text: String) {
        let readMore = "... Read More"
        
        let limitedText = String(text.prefix(240))
        let displayText = limitedText + readMore
        
        var config = button.configuration ?? .plain()
        
        let attributedString = NSMutableAttributedString()
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: UIColor.label
        ]
        
        let readMoreAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .bold),
            .foregroundColor: UIColor.secondaryLabel
        ]
        
        attributedString.append(NSAttributedString(string: limitedText, attributes: normalAttributes))
        attributedString.append(NSAttributedString(string: readMore, attributes: readMoreAttributes))
        
        config.attributedTitle = AttributedString(attributedString)
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8)
        button.configuration = config
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
    }
    
    @objc private func tap() { tapSubject.send(()) }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Screenshots
class ScreenshotsCell: UITableViewCell {
    
    private var screenshots: [Screenshot] = []
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.pageIndicatorTintColor = .secondaryLabel
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ScreenshotItemCell.self, forCellWithReuseIdentifier: "ScreenshotItemCell")
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
        contentView.addSubview(pageControl)
        
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(collectionView.snp.width).multipliedBy(0.6)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(collectionView.snp.bottom).offset(-16)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        pageControl.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        pageControl.layer.cornerRadius = 10
        pageControl.layer.masksToBounds = true
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.5)
    }
    
    func configure(with screenshots: [Screenshot]) {
        self.screenshots = screenshots
        
        pageControl.numberOfPages = screenshots.count
        pageControl.currentPage = 0
        
        collectionView.reloadData()
    }
}

extension ScreenshotsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScreenshotItemCell", for: indexPath) as! ScreenshotItemCell
        let screenshot = screenshots[indexPath.item]
        cell.configure(with: screenshot)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = page
    }
}


// MARK: - Metacritic
class MetacriticCell: UITableViewCell {
    
    private var platforms: [MetacriticPlatform] = []
    private var viewModel: GameDetailViewModel?
    
    private let noReviewsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Metacritic Reviews Available"
        label.backgroundColor = .systemGray6
        label.font =  UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.layer.cornerRadius = 16
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()
    
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
        collectionView.register(MetacriticPlatformCell.self, forCellWithReuseIdentifier: "MetacriticPlatformCell")
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
        contentView.addSubview(noReviewsLabel)
        
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
            make.bottom.equalToSuperview()
        }
        
        noReviewsLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(80)
        }
    }
    
    func configure(with game: GameDetailModel?, viewModel: GameDetailViewModel) {
        self.viewModel = viewModel
        self.platforms = game?.metacriticPlatforms ?? []
        if platforms.isEmpty {
            showNoReviewsMessage()
        }
        collectionView.reloadData()
    }
    
    private func showNoReviewsMessage() {
        noReviewsLabel.isHidden = false
        collectionView.isHidden = true
    }
}

extension MetacriticCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return platforms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MetacriticPlatformCell", for: indexPath) as! MetacriticPlatformCell
        let platform = platforms[indexPath.item]
        cell.configure(with: platform, viewModel: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 80)
    }
}

// MARK: - Developers
class DevelopersCell: UITableViewCell {
    
    private var developers: [Company] = []
    private var publishers: [Company] = []
    private var platforms: [Platform] = []
    private var genres: [Genre] = []
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
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
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configure(with game: GameDetailModel?) {
        guard let game = game else { return }
        
        developers = game.developers ?? []
        publishers = game.publishers ?? []
        platforms = game.platforms ?? []
        genres = game.genres ?? []
        
        setupSections()
    }
    
    private func setupSections() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if !developers.isEmpty {
            let sectionView = createSectionView(title: "Developers", data: developers.map { $0.name ?? "Unknown" })
            stackView.addArrangedSubview(sectionView)
        }
        
        if !publishers.isEmpty {
            let sectionView = createSectionView(title: "Publishers", data: publishers.map { $0.name ?? "Unknown" })
            stackView.addArrangedSubview(sectionView)
        }
        
        if !platforms.isEmpty {
            let sectionView = createSectionView(title: "Platforms", data: platforms.map { $0.platform?.name ?? "Unknown" })
            stackView.addArrangedSubview(sectionView)
        }
        
        if !genres.isEmpty {
            let sectionView = createSectionView(title: "Genres", data: genres.map { $0.name ?? "Unknown" })
            stackView.addArrangedSubview(sectionView)
        }
    }
    
    private func createSectionView(title: String, data: [String]) -> UIView {
        let containerView = UIView()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = title
            label.font = .systemFont(ofSize: 20, weight: .bold)
            label.textColor = .label
            return label
        }()
        
        let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 12
            layout.minimumLineSpacing = 12
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .clear
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(DeveloperItemCell.self, forCellWithReuseIdentifier: "DeveloperItemCell")
            return collectionView
        }()
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(collectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
        
        collectionView.tag = data.hashValue
        objc_setAssociatedObject(collectionView, &AssociatedKeys.data, data, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return containerView
    }
}

private struct AssociatedKeys {
    static var data = "data"
}

extension DevelopersCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let data = objc_getAssociatedObject(collectionView, &AssociatedKeys.data) as? [String] else { return 0 }
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeveloperItemCell", for: indexPath) as! DeveloperItemCell
        
        guard let data = objc_getAssociatedObject(collectionView, &AssociatedKeys.data) as? [String] else { return cell }
        cell.configure(with: data[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let data = objc_getAssociatedObject(collectionView, &AssociatedKeys.data) as? [String] else { return CGSize.zero }
        
        let text = data[indexPath.item]
        let textWidth = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)]).width
        let maxWidth = collectionView.bounds.width - 32
        let finalWidth = min(textWidth + 24, maxWidth)
        
        let textHeight = text.boundingRect(
            with: CGSize(width: finalWidth - 16, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)],
            context: nil
        ).height
        
        let finalHeight = max(textHeight + 16, 32)
        
        return CGSize(width: finalWidth, height: finalHeight)
    }
}
