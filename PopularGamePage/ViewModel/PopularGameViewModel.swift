//
//  PopularGameViewModel.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/10/11.
//

import Foundation
import Combine

class PopularGameViewModel: ObservableObject {
    
    @Published var genres: [GameGenreModel] = []
    @Published var genreTypes: [GenreType] = []
    @Published var selectedGenreType: GenreType = .all
    @Published var games: [GameListItemModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let service: PopularGameServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(service: PopularGameServiceProtocol = PopularGameService()) {
        self.service = service
    }
    
    func fetchGenres() {
        isLoading = true
        errorMessage = nil
        
        service.fetchAllGenres()
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
        isLoading = true
        fetchGamesForSelectedGenre()
    }
    
    private func fetchGamesForSelectedGenre() {
        switch selectedGenreType {
        case .all:
            fetchAllPopularGames()
        case .genre(let genre):
            fetchPopularGamesForGenre(genre)
        }
    }
    
    private func fetchPopularGamesForGenre(_ genre: GameGenreModel) {
        service.fetchPopularGamesForGenre(genre, pageSize: 20)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
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
    
    private func fetchAllPopularGames() {
        service.fetchAllPopularGames(pageSize: 20)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
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

