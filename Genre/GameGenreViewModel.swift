//
//  GameGenreViewModel.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/9/27.
//

import Foundation
import Combine

enum GenreType {
    case all
    case genre(GameGenreModel)
    
    var displayName: String {
        switch self {
        case .all:
            return "All"
        case .genre(let genre):
            return genre.name
        }
    }
    
    var id: Int {
        switch self {
        case .all:
            return -1
        case .genre(let genre):
            return genre.id
        }
    }
    
    var genreModel: GameGenreModel? {
        switch self {
        case .all:
            return nil
        case .genre(let genre):
            return genre
        }
    }
}

class GameGenreViewModel: ObservableObject {
    
    @Published var genres: [GameGenreModel] = []
    @Published var genreTypes: [GenreType] = []
    @Published var selectedGenreType: GenreType = .all
    @Published var games: [GameListItemModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let gameGenreService: GameGenreServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(gameGenreService: GameGenreServiceProtocol = GameGenreService()) {
        self.gameGenreService = gameGenreService
    }
    
    func fetchGenres() {
        isLoading = true
        errorMessage = nil
        
        gameGenreService.fetchAllGenres()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] genres in
                    self?.genres = genres
                    self?.updateGenreTypes()
                    self?.fetchGamesForSelectedGenre()
                }
            )
            .store(in: &cancellables)
    }
    
    private func updateGenreTypes() {
        genreTypes = [.all] + genres.map { GenreType.genre($0) }
    }
    
    func selectGenreType(_ genreType: GenreType) {
        selectedGenreType = genreType
        fetchGamesForSelectedGenre()
    }
    
    private func fetchGamesForSelectedGenre() {
        switch selectedGenreType {
        case .all:
            fetchAllGames()
        case .genre(let genre):
            fetchGamesForGenre(genre)
        }
    }
    
    private func fetchGamesForGenre(_ genre: GameGenreModel) {
        gameGenreService.fetchGamesForGenre(genre, pageSize: 20)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] games in
                    self?.games = games
                }
            )
            .store(in: &cancellables)
    }
    
    private func fetchAllGames() {
        gameGenreService.fetchAllGames(pageSize: 20)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] games in
                    self?.games = games
                }
            )
            .store(in: &cancellables)
    }
}
