//
//  AssetCode.swift
//  FxTrackR
//
//  Created by Sviatoslav Yakymiv on 31.03.2025.
//

import Foundation

extension Asset {
    struct Code: RawRepresentable, Codable, Hashable, Identifiable, CodingKey, ExpressibleByStringLiteral {
        let stringValue: String
        let intValue: Int? = nil
        var rawValue: String { stringValue }
        var id: String { rawValue }
        
        init(stringLiteral value: String) {
            stringValue = value
        }
        
        init(rawValue: String) {
            self.init(stringLiteral: rawValue)
        }
        
        init?(intValue: Int) {
            return nil
        }
        
        init?(stringValue: String) {
            self.init(stringLiteral: stringValue)
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            try self.init(stringLiteral: container.decode(String.self))
        }
        
        func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(rawValue)
        }
    }
}
