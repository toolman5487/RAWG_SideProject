//
//  PlatformGameModel.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/10/19.
//

import Foundation

// MARK: - Platform Game Response
struct PlatformGameResponse: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [PlatformGameItem]?
}

// MARK: - Platform Game Item
struct PlatformGameItem: Codable {
    let id: Int
    let slug: String
    let name: String
    let released: String?
    let tba: Bool
    let backgroundImage: String?
    let rating: Double?
    let ratingTop: Int?
    let ratings: [PlatformGameRating]?
    let ratingsCount: Int?
    let reviewsTextCount: Int?
    let added: Int?
    let addedByStatus: PlatformAddedByStatus?
    let metacritic: Int?
    let playtime: Int?
    let suggestionsCount: Int?
    let updated: String?
    let userGame: String?
    let reviewsCount: Int?
    let saturatedColor: String?
    let dominantColor: String?
    let platforms: [PlatformGamePlatform]?
    let parentPlatforms: [PlatformGamePlatform]?
    let genres: [PlatformGameGenre]?
    let stores: [PlatformGameStore]?
    let clip: String?
    let tags: [PlatformGameTag]?
    let esrbRating: PlatformEsrbRating?
    let shortScreenshots: [PlatformGameScreenshot]?
    
    enum CodingKeys: String, CodingKey {
        case id, slug, name, released, tba, rating, metacritic, playtime, updated, userGame, reviewsCount, saturatedColor, dominantColor, platforms, parentPlatforms, genres, stores, clip, tags, esrbRating, shortScreenshots
        case backgroundImage = "background_image"
        case ratingTop = "rating_top"
        case ratings
        case ratingsCount = "ratings_count"
        case reviewsTextCount = "reviews_text_count"
        case added
        case addedByStatus = "added_by_status"
        case suggestionsCount = "suggestions_count"
    }
}

// MARK: - Platform Game Rating
struct PlatformGameRating: Codable {
    let id: Int
    let title: String
    let count: Int
    let percent: Double
}

// MARK: - Platform Added By Status
struct PlatformAddedByStatus: Codable {
    let yet: Int?
    let owned: Int?
    let beaten: Int?
    let toplay: Int?
    let dropped: Int?
    let playing: Int?
}

// MARK: - Platform Game Platform
struct PlatformGamePlatform: Codable {
    let platform: PlatformGamePlatformDetail
}

struct PlatformGamePlatformDetail: Codable {
    let id: Int
    let name: String
    let slug: String
    let image: String?
    let yearEnd: Int?
    let yearStart: Int?
    let gamesCount: Int?
    let imageBackground: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug, image, gamesCount
        case yearEnd = "year_end"
        case yearStart = "year_start"
        case imageBackground = "image_background"
    }
}

// MARK: - Platform Game Genre
struct PlatformGameGenre: Codable {
    let id: Int
    let name: String
    let slug: String
    let gamesCount: Int?
    let imageBackground: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

// MARK: - Platform Game Store
struct PlatformGameStore: Codable {
    let id: Int
    let store: PlatformGameStoreDetail
    let url: String
}

struct PlatformGameStoreDetail: Codable {
    let id: Int
    let name: String
    let slug: String
    let domain: String?
    let gamesCount: Int?
    let imageBackground: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug, domain
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

// MARK: - Platform Game Tag
struct PlatformGameTag: Codable {
    let id: Int
    let name: String
    let slug: String
    let language: String
    let gamesCount: Int?
    let imageBackground: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug, language
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

// MARK: - Platform ESRB Rating
struct PlatformEsrbRating: Codable {
    let id: Int
    let name: String
    let slug: String
}

// MARK: - Platform Game Screenshot
struct PlatformGameScreenshot: Codable {
    let id: Int
    let image: String
}
