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
}
