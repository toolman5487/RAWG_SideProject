//
//  GameGenreModel.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/9/27.
//

import Foundation

struct GameGenreResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [GameGenreResult]
}

struct GameGenreResult: Codable {
    let id: Int
    let name: String
    let slug: String
    let gamesCount: Int
    let imageBackground: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

struct GameGenreModel: Equatable {
    let id: Int
    let name: String
    let slug: String
    let gamesCount: Int
    let imageBackground: String?
    
    static func == (lhs: GameGenreModel, rhs: GameGenreModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension GameGenreModel {
    init(from result: GameGenreResult) {
        self.id = result.id
        self.name = result.name
        self.slug = result.slug
        self.gamesCount = result.gamesCount
        self.imageBackground = result.imageBackground
    }
}
