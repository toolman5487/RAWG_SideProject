//
//  GameDetailService.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/10.
//

import Foundation
import Combine

protocol GameDetailServiceProtocol {
    func fetchGameDetail(gameId: Int) -> AnyPublisher<GameDetailModel, Error>
    func fetchScreenshots(gameId: Int) -> AnyPublisher<ScreenshotResponse, Error>
    func fetchMovies(gameId: Int) -> AnyPublisher<MovieResponse, Error>
}

class GameDetailService: GameDetailServiceProtocol {
    
    func fetchGameDetail(gameId: Int) -> AnyPublisher<GameDetailModel, Error> {
        let urlString = "\(APIConfig.baseURL)/games/\(gameId)?key=\(APIConfig.apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GameDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchScreenshots(gameId: Int) -> AnyPublisher<ScreenshotResponse, Error> {
        let urlString = "\(APIConfig.baseURL)/games/\(gameId)/screenshots?key=\(APIConfig.apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ScreenshotResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchMovies(gameId: Int) -> AnyPublisher<MovieResponse, Error> {
        let urlString = "\(APIConfig.baseURL)/games/\(gameId)/movies?key=\(APIConfig.apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
