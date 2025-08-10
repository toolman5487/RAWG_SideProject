//
//  APIConfig.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/10.
//

import Foundation

struct APIConfig {
    
    static let baseURL = "https://api.rawg.io/api"
    static let apiKey: String = {
        return Bundle.main.object(forInfoDictionaryKey: "RAWG_API_KEY") as? String ?? ""
    }()
}
