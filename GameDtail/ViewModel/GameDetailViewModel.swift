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
    
// MARK: - Transform Platform Icon
    func getPlatformIcon(for platformName: String) -> String {
        switch platformName.lowercased() {
        case "pc":
            return "desktopcomputer"
        case "playstation 5", "ps5":
            return "playstation.logo"
        case "playstation 4", "ps4":
            return "playstation.logo"
        case "xbox series x", "xbox one":
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
