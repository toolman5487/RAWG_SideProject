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
}

class GameDetailService: GameDetailServiceProtocol {
    
    func fetchGameDetail(gameId: Int) -> AnyPublisher<GameDetailModel, Error> {
        let urlString = "\(APIConfig.baseURL)/games/\(gameId)?key=\(APIConfig.apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GameDetailModel.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
