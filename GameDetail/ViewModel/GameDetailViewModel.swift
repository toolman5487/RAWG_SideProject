//
//  GameDetailViewModel.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/10.
//

import Foundation
import Combine
import UIKit

class GameDetailViewModel: ObservableObject {
    
    @Published var gameDetail: GameDetailModel?
    @Published var screenshots: [Screenshot] = []
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let gameDetailService: GameDetailServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(gameDetailService: GameDetailServiceProtocol = GameDetailService()) {
        self.gameDetailService = gameDetailService
    }

// MARK: - Fetch Detail of Game
    func fetchGameDetail(gameId: Int) {
        isLoading = true
        errorMessage = nil
        
        gameDetailService.fetchGameDetail(gameId: gameId)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] gameDetail in
                    self?.gameDetail = gameDetail
                    self?.fetchScreenshots(gameId: gameId)
                    self?.fetchMovies(gameId: gameId)
                }
            )
            .store(in: &cancellables)
    }
    
// MARK: - Fetch ScreenShot
    private func fetchScreenshots(gameId: Int) {
        gameDetailService.fetchScreenshots(gameId: gameId)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] screenshotResponse in
                    self?.screenshots = screenshotResponse.results ?? []
                }
            )
            .store(in: &cancellables)
    }
    
// MARK: - Fetch Movies
    private func fetchMovies(gameId: Int) {
        gameDetailService.fetchMovies(gameId: gameId)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] movieResponse in
                    self?.movies = movieResponse.results ?? []
                }
            )
            .store(in: &cancellables)
    }
    
// MARK: - Transform Platform Icon
    func getPlatformIcon(for platformName: String) -> String {
        switch platformName.lowercased() {
        case "pc":
            return "desktopcomputer"
        case "playstation 5", "ps5":
            return "playstation.logo"
        case "playstation 4", "ps4":
            return "playstation.logo"
        case "playstation 3", "ps3":
            return "playstation.logo"
        case "xbox series x", "xbox one", "xbox 360":
            return "xbox.logo"
        case "nintendo switch":
            return "gamecontroller"
        case "ios":
            return "iphone"
        case "android":
            return "iphone"
        case "mac":
            return "macbook"
        case "linux":
            return "desktopcomputer"
        default:
            return "gamecontroller"
        }
    }
    
    func getMetacriticColor(for score: Int) -> UIColor {
        switch score {
        case 75...100:
            return .systemGreen
        case 50..<75:
            return .systemYellow
        default:
            return .systemRed
        }
    }
}

extension GameDetailViewModel {
    
    enum CellType: CaseIterable {
        case imageCarousel
        case rating
        case gameInfo
        case movies
        case description
        case screenshots
        case metacritic
        case developers
        
        var cellIdentifier: String {
            switch self {
            case .imageCarousel: return "ImageCarouselCell"
            case .rating: return "RatingCell"
            case .gameInfo: return "GameInfoCell"
            case .movies: return "GameVideoCell"
            case .description: return "DescriptionCell"
            case .screenshots: return "ScreenshotsCell"
            case .metacritic: return "MetacriticCell"
            case .developers: return "DevelopersCell"
            }
        }
    }
    
    var visibleCells: [CellType] {
        guard let gameDetail = gameDetail else { return [] }
        
        var cells: [CellType] = [.imageCarousel, .rating, .gameInfo]
        
        if !movies.isEmpty {
            cells.append(.movies)
        }
        
        cells.append(.description)
        
        if !screenshots.isEmpty {
            cells.append(.screenshots)
        }
        
        if !gameDetail.metacriticPlatforms!.isEmpty {
            cells.append(.metacritic)
        }
        
        cells.append(.developers)
        return cells
    }
    
    var numberOfCells: Int {
        return visibleCells.count
    }
}
