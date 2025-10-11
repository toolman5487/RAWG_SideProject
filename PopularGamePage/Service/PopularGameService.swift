//
//  PopularGameService.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/10/11.
//

import Foundation
import Combine

protocol PopularGameServiceProtocol {
    func fetchAllGenres() -> AnyPublisher<[GameGenreModel], Error>
    func fetchPopularGamesForGenre(_ genre: GameGenreModel, pageSize: Int) -> AnyPublisher<[GameListItemModel], Error>
    func fetchAllPopularGames(pageSize: Int) -> AnyPublisher<[GameListItemModel], Error>
}

final class PopularGameService: PopularGameServiceProtocol {
    
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
    
    func fetchPopularGamesForGenre(_ genre: GameGenreModel, pageSize: Int = 20) -> AnyPublisher<[GameListItemModel], Error> {
        let urlString = "\(APIConfig.baseURL)/games?key=\(APIConfig.apiKey)&genres=\(genre.id)&ordering=-added&page_size=\(pageSize)"
        
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
    
    func fetchAllPopularGames(pageSize: Int = 20) -> AnyPublisher<[GameListItemModel], Error> {
        let urlString = "\(APIConfig.baseURL)/games?key=\(APIConfig.apiKey)&ordering=-added&page_size=\(pageSize)"
        
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

