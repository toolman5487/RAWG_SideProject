//
//  SearchService.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/31.
//

import Foundation
import Combine

protocol SearchServiceProtocol {
    func searchGames(query: String) -> AnyPublisher<GameSearchResponse, Error>
}

class SearchService: SearchServiceProtocol {
    func searchGames(query: String) -> AnyPublisher<GameSearchResponse, Error> {
        let urlString = "\(APIConfig.baseURL)/games?key=\(APIConfig.apiKey)&search=\(query)&page_size=20"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GameSearchResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
