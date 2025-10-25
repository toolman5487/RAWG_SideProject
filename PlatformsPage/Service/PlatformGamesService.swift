//
//  PlatformGamesService.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/10/19.
//

import Foundation
import Combine

protocol PlatformGamesServiceProtocol {
    func fetchPlatformGames(platformId: Int, page: Int, pageSize: Int) -> AnyPublisher<GameListResponse, Error>
    func fetchPlatformGamesFromURL(_ urlString: String) -> AnyPublisher<GameListResponse, Error>
    func fetchPlatformGamesByGenre(platformId: Int, genreId: Int, page: Int, pageSize: Int) -> AnyPublisher<GameListResponse, Error>
}

class PlatformGamesService: PlatformGamesServiceProtocol {
    
    func fetchPlatformGames(platformId: Int, page: Int = 1, pageSize: Int = 20) -> AnyPublisher<GameListResponse, Error> {
        let urlString = "\(APIConfig.baseURL)/games?key=\(APIConfig.apiKey)&platforms=\(platformId)&page=\(page)&page_size=\(pageSize)&ordering=-released"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GameListResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchPlatformGamesFromURL(_ urlString: String) -> AnyPublisher<GameListResponse, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GameListResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchPlatformGamesByGenre(platformId: Int, genreId: Int, page: Int = 1, pageSize: Int = 20) -> AnyPublisher<GameListResponse, Error> {
        let urlString = "\(APIConfig.baseURL)/games?key=\(APIConfig.apiKey)&platforms=\(platformId)&genres=\(genreId)&page=\(page)&page_size=\(pageSize)&ordering=-released"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GameListResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
