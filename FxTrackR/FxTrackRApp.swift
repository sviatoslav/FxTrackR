//
//  FxTrackRApp.swift
//  FxTrackR
//
//  Created by Sviatoslav Yakymiv on 31.03.2025.
//

import SwiftUI

@main
struct FxTrackRApp: App {
    private let openExchangeRatesAPIKey: String = {
        guard let key = Bundle.main.infoDictionary?["OPEN_EXCHANGE_RATES_API_KEY"] as? String, !key.isEmpty else {
            fatalError("OPEN_EXCHANGE_RATES_API_KEY is not set")
        }
        return key
    }()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
        }
        .environment(\.settings, .init())
        .environment(\.apiService, OpenExchangeRatesService(apiKey: openExchangeRatesAPIKey, session: .shared))
    }
}
