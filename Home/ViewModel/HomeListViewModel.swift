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
        
        Publishers.Zip(
            homeListService.fetchNewestGames(),
            homeListService.fetchTopGames()
        )
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
            receiveValue: { [weak self] gamesData in
                self?.games = gamesData.0
                self?.topGames = gamesData.1
                self?.preloadImages(for: gamesData.0)
                self?.preloadImages(for: gamesData.1)
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
}
