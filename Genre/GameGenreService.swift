//
//  GameGenreService.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/9/27.
//

import Foundation
import Combine

protocol GameGenreServiceProtocol {
    func fetchAllGenres() -> AnyPublisher<[GameGenreModel], Error>
    func fetchGamesForGenre(_ genre: GameGenreModel, pageSize: Int) -> AnyPublisher<[GameListItemModel], Error>
    func fetchAllGames(pageSize: Int) -> AnyPublisher<[GameListItemModel], Error>
}

final class GameGenreService: GameGenreServiceProtocol {
    
    func fetchAllGenres() -> AnyPublisher<[GameGenreModel], Error> {
        let urlString = "\(APIConfig.baseURL)/genres?key=\(APIConfig.apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GameGenreResponse.self, decoder: JSONDecoder())
            .map { response in
                response.results.map { GameGenreModel(from: $0) }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchGamesForGenre(_ genre: GameGenreModel, pageSize: Int = 20) -> AnyPublisher<[GameListItemModel], Error> {
        let urlString = "\(APIConfig.baseURL)/games?key=\(APIConfig.apiKey)&genres=\(genre.id)&ordering=-released&page_size=\(pageSize)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GameListResponse.self, decoder: JSONDecoder())
            .map { response in
                response.results.map { GameListItemModel(from: $0) }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchAllGames(pageSize: Int = 30) -> AnyPublisher<[GameListItemModel], Error> {
        let today = Date()
        let calendar = Calendar.current
        
        let startOfMonth = calendar.dateInterval(of: .month, for: today)?.start ?? today
        let endOfMonth = calendar.dateInterval(of: .month, for: today)?.end ?? today
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let startDate = formatter.string(from: startOfMonth)
        let endDate = formatter.string(from: endOfMonth)
        
        let urlString = "\(APIConfig.baseURL)/games?key=\(APIConfig.apiKey)&dates=\(startDate),\(endDate)&ordering=-released&page_size=\(pageSize)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GameListResponse.self, decoder: JSONDecoder())
            .map { response in
                response.results.map { GameListItemModel(from: $0) }
            }
            .eraseToAnyPublisher()
    }
}
