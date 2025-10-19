//
//  PlatformsService.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/10/19.
//

import Foundation
import Combine

protocol PlatformsServiceProtocol {
    func fetchPlatforms(page: Int, pageSize: Int) -> AnyPublisher<PlatformResponse, Error>
    func fetchPlatformsFromURL(_ urlString: String) -> AnyPublisher<PlatformResponse, Error>
}

class PlatformsService: PlatformsServiceProtocol {
    
    func fetchPlatforms(page: Int = 1, pageSize: Int = 20) -> AnyPublisher<PlatformResponse, Error> {
        let urlString = "\(APIConfig.baseURL)/platforms?key=\(APIConfig.apiKey)&page=\(page)&page_size=\(pageSize)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PlatformResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchPlatformsFromURL(_ urlString: String) -> AnyPublisher<PlatformResponse, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PlatformResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
