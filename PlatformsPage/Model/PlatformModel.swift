//
//  PlatformModel.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/10/19.
//

import Foundation

// MARK: - Platform Response
struct PlatformResponse: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [PlatformModel]?
}

// MARK: - Platform Model
struct PlatformModel: Codable {
    let id: Int
    let name: String
    let slug: String
    let gamesCount: Int
    let imageBackground: String?
    let image: String?
    let yearStart: Int?
    let yearEnd: Int?
    let games: [PlatformGame]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
        case image
        case yearStart = "year_start"
        case yearEnd = "year_end"
        case games
    }
}

// MARK: - Platform Game
struct PlatformGame: Codable {
    let id: Int
    let slug: String
    let name: String
    let added: Int
    let backgroundImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id, slug, name, added
        case backgroundImage = "background_image"
    }
}
