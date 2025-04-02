//
//  Asset.swift
//  FxTrackR
//
//  Created by Sviatoslav Yakymiv on 31.03.2025.
//

import Foundation

struct Asset: Identifiable, Codable, Equatable, Hashable {
    let code: Code
    var id: Code { code }
    let name: String
    
    func matches(_ query: String) -> Bool {
        guard !query.isEmpty else { return true }
        return name.localizedStandardContains(query) || code.rawValue.localizedStandardContains(query)
    }
}
