//
//  HomeViewModel.swift
//  FxTrackR
//
//  Created by Sviatoslav Yakymiv on 31.03.2025.
//

import Foundation

@MainActor class HomeViewModel: ObservableObject {
    enum LoadingState {
        case idle
        case loading
    }
    let settings: Settings
    let apiService: APIService
    
    @Published var statusMessage: String = ""
    
    @Published var assets: [Asset] {
        didSet {
            settings.selectedAssets = assets
            fetchRatesIfNeeded()
        }
    }
    @Published var rates: [Asset.Code: Decimal] = [:]
    private var loadingState: LoadingState = .idle
    
    init(settings: Settings, apiService: APIService) {
        self.settings = settings
        self.apiService = apiService
        _assets = .init(initialValue: settings.selectedAssets)
    }
    
    func fetchRatesIfNeeded() {
        guard loadingState == .idle, !assets.isEmpty else { return }
        loadingState = .loading
        Task {
            do {
                rates = try await apiService.loadRates()
                statusMessage = ""
            } catch {
                if rates.isEmpty {
                    statusMessage = "Failed to load. Retrying..."
                }
            }
            try await Task.sleep(nanoseconds: 3_000_000_000)
            loadingState = .idle
            fetchRatesIfNeeded()
        }
    }
    
    func removeAssets(atOffsets offsets: IndexSet) {
        assets.remove(atOffsets: offsets)
    }
    
    func moveAssets(fromOffsets source: IndexSet, toOffset destination: Int) {
        assets.move(fromOffsets: source, toOffset: destination)
    }
}
