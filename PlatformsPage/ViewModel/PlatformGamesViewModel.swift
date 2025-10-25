//
//  PlatformGamesViewModel.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/10/19.
//

import Foundation
import Combine

final class PlatformGamesViewModel: ObservableObject {
    @Published var genreTypes: [GenreType] = []
    @Published var selectedGenreType: GenreType = .all
    @Published var games: [GameListItemModel] = []
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var errorMessage: String?
    @Published var hasMoreData: Bool = true
    
    private let platformGamesService: PlatformGamesServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var platformId: Int?
    private var currentPage = 1
    private let pageSize = 20
    private var nextURL: String?
    
    init(platformGamesService: PlatformGamesServiceProtocol = PlatformGamesService()) {
        self.platformGamesService = platformGamesService
    }
    
    func configure(with platform: PlatformModel) {
        self.platformId = platform.id
        fetchGenres()
    }
    
    func fetchGenres() {
        isLoading = true
        errorMessage = nil
        
        let urlString = "\(APIConfig.baseURL)/genres?key=\(APIConfig.apiKey)"
        guard let url = URL(string: urlString) else {
            self.isLoading = false
            self.errorMessage = URLError(.badURL).localizedDescription
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GameGenreResponse.self, decoder: JSONDecoder())
            .map { $0.results.map { GameGenreModel(from: $0) } }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] genres in
                    self?.genreTypes = [.all] + genres.map { GenreType.genre($0) }
                    self?.fetchGamesForSelectedGenre()
                }
            )
            .store(in: &cancellables)
    }
    
    func selectGenreType(_ genreType: GenreType) {
        selectedGenreType = genreType
        currentPage = 1
        games = []
        hasMoreData = true
        isLoading = true
        fetchGamesForSelectedGenre()
    }
    
    func loadMoreGames() {
        guard !isLoadingMore && hasMoreData && !isLoading else { return }
        
        isLoadingMore = true
        errorMessage = nil
        
        if let nextURL = nextURL {
            platformGamesService.fetchPlatformGamesFromURL(nextURL)
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        self?.isLoadingMore = false
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            self?.errorMessage = error.localizedDescription
                        }
                    },
                    receiveValue: { [weak self] response in
                        let gameModels = response.results.map { GameListItemModel(from: $0) }
                        self?.games.append(contentsOf: gameModels)
                        self?.nextURL = response.next
                        self?.hasMoreData = response.next != nil
                    }
                )
                .store(in: &cancellables)
        } else {
            currentPage += 1
            fetchGamesForSelectedGenre()
        }
    }
    
    private func fetchGamesForSelectedGenre() {
        guard let platformId = platformId else {return}
    
        isLoading = true
        errorMessage = nil
        
        let publisher: AnyPublisher<GameListResponse, Error>
        
        switch selectedGenreType {
        case .all:
            publisher = platformGamesService.fetchPlatformGames(platformId: platformId, page: currentPage, pageSize: pageSize)
        case .genre(let genre):
            publisher = platformGamesService.fetchPlatformGamesByGenre(platformId: platformId, genreId: genre.id, page: currentPage, pageSize: pageSize)
        }
        
        publisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    self?.isLoadingMore = false
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    let gameModels = response.results.map { GameListItemModel(from: $0) }
                    if self?.currentPage == 1 {
                        self?.games = gameModels
                    } else {
                        self?.games.append(contentsOf: gameModels)
                    }
                    self?.nextURL = response.next
                    self?.hasMoreData = response.next != nil
                }
            )
            .store(in: &cancellables)
    }
    
    func getGamesCount() -> Int {
        return games.count
    }
    
    func getGame(at index: Int) -> GameListItemModel? {
        guard index >= 0 && index < games.count else { return nil }
        return games[index]
    }
}
