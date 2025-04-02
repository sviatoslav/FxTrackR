//
//  AddAssetViewModelTests.swift
//  FxTrackRTests
//
//  Created by Sviatoslav Yakymiv on 01.04.2025.
//

import Foundation
import Testing
import Combine
@testable import FxTrackR

struct AddAssetsViewModelTests {
    
    let apiService: APIService = {
        var service = MockAPIService()
        service.loadAssetsResult = .success([.usd, .eur, .uah, .aed, .btc])
        return service
    }()
    
    @Test("Test assets loading")
    func verifyAssetsLoaded() async throws {
        let vm = await AddAssetsViewModel(apiService: apiService, excludeAssets: [])
        var bag: Set<AnyCancellable> = []
        await withCheckedContinuation { continuation in
            Task { @MainActor in
                vm.$loadingState.sink {
                    if $0 == .loaded {
                        continuation.resume()
                    }
                }.store(in: &bag)
                vm.loadAssets()
            }
            
        }
        #expect(await vm.displayedAssets == [.usd, .eur, .uah, .aed, .btc])
    }
    
    @Test("Test select single asset")
    func verifyAssetSelection() async throws {
        let vm = await AddAssetsViewModel(apiService: apiService, excludeAssets: [])
        await vm.toggleSelection(for: .usd)
        #expect(await vm.selectedAssets == [.usd])
    }
    
    @Test("Test asset deselection")
    func verifyAssetDeselection() async throws {
        let vm = await AddAssetsViewModel(apiService: apiService, excludeAssets: [])
        await vm.toggleSelection(for: .usd)
        await vm.toggleSelection(for: .usd)
        #expect(await vm.selectedAssets == [])
    }
    
    @Test("Test assed exclusion")
    func verifyAssetExclusion() async throws {
        let vm = await AddAssetsViewModel(apiService: apiService, excludeAssets: [.usd, .eur])
        try await vm.reloadData()
        #expect(await vm.displayedAssets == [.uah, .aed, .btc])
    }
    
    @Test("Test filtering using search text")
    func verifyAssetsFilteringBySearchQuery() async throws {
        let vm = await AddAssetsViewModel(apiService: apiService, excludeAssets: [])
        try await vm.reloadData()
        await MainActor.run {
            vm.searchText = "u"
        }
        #expect(await vm.displayedAssets == [.usd, .eur, .uah, .aed])
    }
}
