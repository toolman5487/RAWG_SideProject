//
//  GameListItemModel.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/9/11.
//

import Foundation

struct GameListItemModel {
    let id: Int
    let name: String
    let backgroundImage: String?
    let rating: Double?
    let released: String?
    let platforms: [String]
}

extension GameListItemModel {
    init(from result: GameSearchResult) {
        self.id = result.id
        self.name = result.name
        self.backgroundImage = result.backgroundImage
        self.rating = result.rating
        self.released = result.released
        self.platforms = result.platforms.map { $0.platform.name }
    }
}
