//
//  NewGameViewModel.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/10/7.
//

import Foundation
import Combine

final class NewGameViewModel: ObservableObject {
    @Published var genreTypes: [GenreType] = []
    @Published var selectedGenreType: GenreType = .all
    @Published var games: [GameListItemModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

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
        isLoading = true
        fetchGamesForSelectedGenre()
    }

    private func fetchGamesForSelectedGenre() {
        let today = Date()
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: today)?.start ?? today
        let endOfMonth = calendar.dateInterval(of: .month, for: today)?.end ?? today

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let startDate = formatter.string(from: startOfMonth)
        let endDate = formatter.string(from: endOfMonth)

        var urlString = "\(APIConfig.baseURL)/games?key=\(APIConfig.apiKey)&dates=\(startDate),\(endDate)&ordering=-released&page_size=30"
        switch selectedGenreType {
        case .all:
            break
        case .genre(let genre):
            urlString += "&genres=\(genre.id)"
        }

        guard let url = URL(string: urlString) else {
            self.errorMessage = URLError(.badURL).localizedDescription
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GameListResponse.self, decoder: JSONDecoder())
            .map { $0.results.map { GameListItemModel(from: $0) } }
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
