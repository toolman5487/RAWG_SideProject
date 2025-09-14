//
//  GameDetailViewController.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/10.
//

import Foundation
import UIKit
import SnapKit
import Combine

class GameDetailViewController: UIViewController {
    
    var gameId: Int
    private let gameDetailVM = GameDetailViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    init(gameId: Int) {
        self.gameId = gameId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    private lazy var tableView: GameDetailTableView = {
        let tableView = GameDetailTableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindingVM()
        fetchGameDetail()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.register(ImageCarouselCell.self, forCellReuseIdentifier: "ImageCarouselCell")
        tableView.register(RatingCell.self, forCellReuseIdentifier: "RatingCell")
        tableView.register(GameInfoCell.self, forCellReuseIdentifier: "GameInfoCell")
        tableView.register(DescriptionCell.self, forCellReuseIdentifier: "DescriptionCell")
        tableView.register(MetacriticCell.self, forCellReuseIdentifier: "MetacriticCell")
        tableView.register(ScreenshotsCell.self, forCellReuseIdentifier: "ScreenshotsCell")
        tableView.register(DevelopersCell.self, forCellReuseIdentifier: "DevelopersCell")
    }
    
    private func bindingVM() {
        gameDetailVM.$gameDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] gameDetail in
                self?.title = gameDetail?.nameOriginal ?? "Unknown Game"
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        gameDetailVM.$screenshots
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        gameDetailVM.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] errorMessage in
                guard let self = self else { return }
                AlertHelper.showErrorAlert(from: self, message: errorMessage)
            }
            .store(in: &cancellables)
    }
    
    private func fetchGameDetail() {
        gameDetailVM.fetchGameDetail(gameId: gameId)
    }
    
    private func presentDescriptionSheet() {
        let raw = gameDetailVM.gameDetail?.description ?? "No description available."
        let clean = raw.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        let gameTitle = gameDetailVM.gameDetail?.nameOriginal ?? "Unknown Game"
        let vc = DescriptionViewController(text: clean, gameTitle: gameTitle)
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .pageSheet
        if let sheet = navController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(navController, animated: true)
    }
}

extension GameDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameDetailVM.gameDetail != nil ? 7 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCarouselCell", for: indexPath) as! ImageCarouselCell
            cell.configure(with: gameDetailVM.gameDetail)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! RatingCell
            cell.configure(with: gameDetailVM.gameDetail)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GameInfoCell", for: indexPath) as! GameInfoCell
            cell.configure(with: gameDetailVM.gameDetail)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as! DescriptionCell
            let raw = gameDetailVM.gameDetail?.description ?? "No Description Available."
            let clean = raw.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            cell.configure(text: clean)
            cell.tapPublisher
                .sink { [weak self] in self?.presentDescriptionSheet() }
                .store(in: &cell.cancellables)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScreenshotsCell", for: indexPath) as! ScreenshotsCell
            cell.configure(with: gameDetailVM.screenshots)
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MetacriticCell", for: indexPath) as! MetacriticCell
            cell.configure(with: gameDetailVM.gameDetail, viewModel: gameDetailVM)
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DevelopersCell", for: indexPath) as! DevelopersCell
            cell.configure(with: gameDetailVM.gameDetail)
            return cell
        default:
            return UITableViewCell()
        }
    }
}




