//
//  FlexibleTypes.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/10.
//

import Foundation

enum FlexibleInt: Codable {
    case int(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
            return
        }
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
            return
        }
        throw DecodingError.typeMismatch(FlexibleInt.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected Int or String for FlexibleInt"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }

    var intValue: Int? {
        switch self {
        case .int(let value):
            return value
        case .string(let string):
            return Int(string)
        }
    }

    var stringValue: String? {
        switch self {
        case .int(let value):
            return String(value)
        case .string(let string):
            return string
        }
    }
}
