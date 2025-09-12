//
//  GameListItemModel.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/9/11.
//

import Foundation

struct GameListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [GameListItemResult]
}

struct GameListItemResult: Codable {
    let id: Int
    let name: String
    let slug: String
    let backgroundImage: String?
    let rating: Double
    let released: String?
    let genres: [GameListItemGenre]
    let platforms: [GameListItemPlatform]
    let score: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug, rating, released, genres, platforms, score
        case backgroundImage = "background_image"
    }
}

struct GameListItemGenre: Codable {
    let id: Int
    let name: String
    let slug: String
}

struct GameListItemPlatform: Codable {
    let platform: GameListItemPlatformInfo
}

struct GameListItemPlatformInfo: Codable {
    let id: Int
    let name: String
    let slug: String
}

struct GameListItemModel {
    let id: Int
    let name: String
    let backgroundImage: String?
    let rating: Double?
    let released: String?
    let platforms: [String]
}

extension GameListItemModel {
    init(from result: GameListItemResult) {
        self.id = result.id
        self.name = result.name
        self.backgroundImage = result.backgroundImage
        self.rating = result.rating
        self.released = result.released
        self.platforms = result.platforms.map { $0.platform.name }
    }
}
