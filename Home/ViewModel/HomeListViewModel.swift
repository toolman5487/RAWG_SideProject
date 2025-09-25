//
//  HomeListViewModel.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/9/13.
//

import Foundation
import Combine
import SDWebImage

class HomeListViewModel: ObservableObject {
    
    @Published var games: [GameListItemModel] = []
    @Published var topGames: [GameListItemModel] = []
    @Published var popularGames: [GameListItemModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let homeListService = HomeListService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        refreshAll()
    }
    
    private func preloadImages(for games: [GameListItemModel]) {
        let imageURLs = games.compactMap { game in
            game.backgroundImage.flatMap { URL(string: $0) }
        }
        SDWebImagePrefetcher.shared.prefetchURLs(imageURLs)
    }
    
    func fetchNewestGames() {
        isLoading = true
        errorMessage = nil
        
        homeListService.fetchNewestGames()
            .receive(on: DispatchQueue.main)
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
                receiveValue: { [weak self] games in
                    self?.games = games
                    self?.preloadImages(for: games)
                }
            )
            .store(in: &cancellables)
    }
    
    func fetchPopularGames() {
        isLoading = true
        errorMessage = nil
        
        homeListService.fetchPopularGames()
            .receive(on: DispatchQueue.main)
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
                receiveValue: { [weak self] popularGames in
                    self?.popularGames = popularGames
                    self?.preloadImages(for: popularGames)
                }
            )
            .store(in: &cancellables)
    }
}

extension HomeListViewModel {
    func refreshAll() {
        if isLoading { return }
        isLoading = true
        errorMessage = nil
        
        homeListService.fetchAllHomeData()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] newestGames, topGames, popularGames in
                    self?.games = newestGames
                    self?.topGames = topGames
                    self?.popularGames = popularGames
                    self?.preloadImages(for: newestGames + topGames + popularGames)
                }
            )
            .store(in: &cancellables)
    }
}
