//
//  Settings.swift
//  FxTrackR
//
//  Created by Sviatoslav Yakymiv on 31.03.2025.
//

import SwiftUI
import Foundation
import Combine

struct Settings {
    private let selectedCurrenciesKey: String = "selected-currencies"
    let defaults: UserDefaults
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    var selectedAssets: [Asset] {
        get {
            defaults.data(forKey: selectedCurrenciesKey)
                .flatMap({ try? JSONDecoder().decode([Asset].self, from: $0) }) ?? []
        }
        
        nonmutating set {
            defaults.set(try? JSONEncoder().encode(newValue), forKey: selectedCurrenciesKey)
        }
    }
}

extension EnvironmentValues {
    @Entry var settings = Settings(defaults: .init())
}
