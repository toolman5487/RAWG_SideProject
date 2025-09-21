//
//  HomeListService.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/9/11.
//

import Foundation
import Combine

protocol HomeListServiceProtocol {
    func fetchNewestGames(daysBack: Int, pageSize: Int) -> AnyPublisher<[GameListItemModel], Error>
    func fetchTopGames() -> AnyPublisher<[GameListItemModel], Error>
    func fetchPopularGames(pageSize: Int) -> AnyPublisher<[GameListItemModel], Error>
}

final class HomeListService: HomeListServiceProtocol {
    
    func fetchTopGames() -> AnyPublisher<[GameListItemModel], Error> {
        let currentYear = Calendar.current.component(.year, from: Date())
        let lastYear = currentYear - 1
        let urlString = "\(APIConfig.baseURL)/games?key=\(APIConfig.apiKey)&ordering=-added&page_size=5&dates=\(lastYear)-01-01,\(currentYear)-12-31"
        
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
    
    func fetchNewestGames(daysBack: Int = 30, pageSize: Int = 20) -> AnyPublisher<[GameListItemModel], Error> {
        let to = Date()
        let from = Calendar.current.date(byAdding: .day, value: -daysBack, to: to) ?? to
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        let fromStr = formatter.string(from: from)
        let toStr = formatter.string(from: to)
        
        let urlString = "\(APIConfig.baseURL)/games?key=\(APIConfig.apiKey)&dates=\(fromStr),\(toStr)&ordering=-released&page_size=\(pageSize)"
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
    
    func fetchPopularGames(pageSize: Int = 20) -> AnyPublisher<[GameListItemModel], Error> {
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
