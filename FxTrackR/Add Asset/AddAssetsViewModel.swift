//
//  AddAssetViewModel.swift
//  FxTrackR
//
//  Created by Sviatoslav Yakymiv on 31.03.2025.
//

import Foundation

@MainActor class AddAssetsViewModel: ObservableObject {
    enum LoadingState: Equatable {
        case idle
        case loading
        case loaded
        case failed
    }
    
    let apiService: APIService
    private let assetsToBeExcluded: Set<Asset.Code>
    private var allAssets: [Asset] = [] {
        didSet {
            updateDisplayedAssets()
        }
    }
    var searchText: String = "" {
        didSet {
            updateDisplayedAssets()
        }
    }
    @Published var selectedAssets: Set<Asset> = []
    @Published var displayedAssets: [Asset] = []
    @Published var loadingState = LoadingState.idle
    
    
    init(apiService: APIService, excludeAssets: [Asset]) {
        self.apiService = apiService
        assetsToBeExcluded = Set(excludeAssets.map(\.code))
    }
    
    func toggleSelection(for asset: Asset) {
        selectedAssets.formSymmetricDifference([asset])
    }
    
    func loadAssets() {
        Task {
            guard loadingState != .loading else { return }
            loadingState = .loading
            do {
                try await reloadData()
            } catch {
                loadingState = .failed
            }
        }
    }
    
    func reloadData() async throws {
        let result: Result<[Asset], Error>
        let start = Date()
        do {
            result = .success(try await apiService.loadAssets())
        } catch {
            result = .failure(error)
        }
        //Make sure loading duration is at least 0.3s, so the UI does not flash
        let minAnimationDuration: UInt64 = 300_000_000
        let elapsedNanoseconds = UInt64(Date().timeIntervalSince(start) * TimeInterval(minAnimationDuration))
        if elapsedNanoseconds < minAnimationDuration {
            try await Task.sleep(nanoseconds: minAnimationDuration - elapsedNanoseconds)
        }
        allAssets = try result.get()
        loadingState = .loaded
    }
    
    private func updateDisplayedAssets() {
        displayedAssets = allAssets.filter {
            !assetsToBeExcluded.contains($0.id) && $0.matches(searchText)
        }
    }
}
