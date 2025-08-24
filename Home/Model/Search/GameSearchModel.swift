//
//  GameSearchModel.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/24.
//

import Foundation

// MARK: - Game Search Response
struct GameSearchResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [GameSearchResult]
}

// MARK: - Game Search Result
struct GameSearchResult: Codable {
    let id: Int
    let name: String
    let slug: String
    let backgroundImage: String?
    let rating: Double
    let released: String?
    let genres: [GameGenre]
    let platforms: [GamePlatform]
    let score: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug, rating, released, genres, platforms, score
        case backgroundImage = "background_image"
    }
}

struct GameGenre: Codable {
    let id: Int
    let name: String
    let slug: String
}

struct GamePlatform: Codable {
    let platform: PlatformInfo
}

struct PlatformInfo: Codable {
    let id: Int
    let name: String
    let slug: String
}
