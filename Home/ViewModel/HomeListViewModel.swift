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
        fetchData()
    }
    
    private func fetchData() {
        isLoading = true
        errorMessage = nil
        
        fetchNewestGamesData()
        fetchTopGamesData()
        fetchPopularGamesData()
    }
    
    private func fetchNewestGamesData() {
        homeListService.fetchNewestGames()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
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
    
    private func fetchTopGamesData() {
        homeListService.fetchTopGames()
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
                receiveValue: { [weak self] topGames in
                    self?.topGames = topGames
                    self?.preloadImages(for: topGames)
                }
            )
            .store(in: &cancellables)
    }
    
    private func fetchPopularGamesData() {
        homeListService.fetchPopularGames()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
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
