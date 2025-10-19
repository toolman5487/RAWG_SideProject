//
//  GameDetailModel.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/10.
//

import Foundation

// MARK: - GameDetailModel
struct GameDetailModel: Codable {
    let id: Int
    let slug: String?
    let name: String?
    let nameOriginal: String?
    let description: String?

    let metacritic: Int?
    let metacriticPlatforms: [MetacriticPlatform]?

    let released: String?
    let tba: Bool?
    let updated: String?

    let backgroundImage: String?
    let backgroundImageAdditional: String?
    let website: String?

    let rating: Double?
    let ratingTop: Int?
    let ratings: [Rating]?
    let reactions: [String: Int]?

    let added: Int?
    let addedByStatus: AddedByStatus?

    let playtime: Int?
    let screenshotsCount: Int?
    let moviesCount: Int?
    let creatorsCount: Int?
    let achievementsCount: Int?
    let parentAchievementsCount: FlexibleInt?

    let redditURL: String?
    let redditName: String?
    let redditDescription: String?
    let redditLogo: String?
    let redditCount: Int?

    let twitchCount: FlexibleInt?
    let youtubeCount: FlexibleInt?
    let reviewsTextCount: FlexibleInt?
    let ratingsCount: Int?
    let suggestionsCount: Int?

    let alternativeNames: [String]?
    let metacriticURL: String?

    let parentsCount: Int?
    let additionsCount: Int?
    let gameSeriesCount: Int?

    let esrbRating: EsrbRating?

    let parentPlatforms: [ParentPlatform]?
    let platforms: [Platform]?

    let stores: [StoreLink]?
    let developers: [Company]?
    let publishers: [Company]?

    let genres: [Genre]?
    let tags: [Tag]?

    enum CodingKeys: String, CodingKey {
        case id, slug, name
        case nameOriginal = "name_original"
        case description, metacritic
        case metacriticPlatforms = "metacritic_platforms"
        case released, tba, updated
        case backgroundImage = "background_image"
        case backgroundImageAdditional = "background_image_additional"
        case website, rating
        case ratingTop = "rating_top"
        case ratings, reactions, added
        case addedByStatus = "added_by_status"
        case playtime
        case screenshotsCount = "screenshots_count"
        case moviesCount = "movies_count"
        case creatorsCount = "creators_count"
        case achievementsCount = "achievements_count"
        case parentAchievementsCount = "parent_achievements_count"
        case redditURL = "reddit_url"
        case redditName = "reddit_name"
        case redditDescription = "reddit_description"
        case redditLogo = "reddit_logo"
        case redditCount = "reddit_count"
        case twitchCount = "twitch_count"
        case youtubeCount = "youtube_count"
        case reviewsTextCount = "reviews_text_count"
        case ratingsCount = "ratings_count"
        case suggestionsCount = "suggestions_count"
        case alternativeNames = "alternative_names"
        case metacriticURL = "metacritic_url"
        case parentsCount = "parents_count"
        case additionsCount = "additions_count"
        case gameSeriesCount = "game_series_count"
        case esrbRating = "esrb_rating"
        case parentPlatforms = "parent_platforms"
        case platforms
        case stores
        case developers, publishers
        case genres, tags
    }
}

// MARK: - Rating distribution item
struct Rating: Codable {
    let id: Int?
    let title: String?
    let count: Int?
    let percent: Double?
}

// MARK: - AddedByStatus block
struct AddedByStatus: Codable {
    let yet: Int?
    let owned: Int?
    let beaten: Int?
    let toplay: Int?
    let dropped: Int?
    let playing: Int?
}

// MARK: - ESRB rating
struct EsrbRating: Codable {
    let id: Int?
    let slug: String?
    let name: String?
}

// MARK: - Metacritic platform mapping
struct MetacriticPlatform: Codable {
    let metascore: Int?
    let url: String?
    let platform: MetacriticPlatformPlatform?
}

struct MetacriticPlatformPlatform: Codable {
    let platform: Int?
    let name: String?
    let slug: String?
}

// MARK: - Parent platform (PC/PlayStation/Xbox)
struct ParentPlatform: Codable {
    let platform: SimplePlatform?
}

struct SimplePlatform: Codable {
    let id: Int?
    let name: String?
    let slug: String?
}

// MARK: - Platform (detailed per platform + requirements)
struct Platform: Codable {
    let platform: PlatformPlatform?
    let releasedAt: String?
    let requirements: Requirements?

    enum CodingKeys: String, CodingKey {
        case platform
        case releasedAt = "released_at"
        case requirements
    }
}

struct PlatformPlatform: Codable {
    let id: Int?
    let name: String?
    let slug: String?
    let image: String?
    let yearEnd: Int?
    let yearStart: Int?
    let gamesCount: Int?
    let imageBackground: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug, image
        case yearEnd = "year_end"
        case yearStart = "year_start"
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

struct Requirements: Codable {
    let minimum: String?
    let recommended: String?
}

// MARK: - Stores
struct StoreLink: Codable {
    let id: Int?
    let url: String?
    let store: Store?
}

struct Store: Codable {
    let id: Int?
    let name: String?
    let slug: String?
    let domain: String?
    let gamesCount: Int?
    let imageBackground: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug, domain
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

// MARK: - Companies
struct Company: Codable {
    let id: Int?
    let name: String?
    let slug: String?
    let gamesCount: Int?
    let imageBackground: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

// MARK: - Genres & Tags
struct Genre: Codable {
    let id: Int?
    let name: String?
    let slug: String?
    let gamesCount: Int?
    let imageBackground: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

struct Tag: Codable {
    let id: Int?
    let name: String?
    let slug: String?
    let language: String?
    let gamesCount: Int?
    let imageBackground: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug, language
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

// MARK: - Screenshot Response
struct ScreenshotResponse: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [Screenshot]?
}

struct Screenshot: Codable {
    let image: String?
    let hidden: Bool?
}

// MARK: - Movie Response
struct MovieResponse: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [Movie]?
}

struct Movie: Codable {
    let id: Int?
    let name: String?
    let preview: String?
    let data: MovieData?
}

struct MovieData: Codable {
    let max: String?
    let four80: String?
    let one20: String?
    
    enum CodingKeys: String, CodingKey {
        case max
        case four80 = "480"
        case one20 = "120"
    }
}


