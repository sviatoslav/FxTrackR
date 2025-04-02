//
//  MockAPIService.swift
//  FxTrackRTests
//
//  Created by Sviatoslav Yakymiv on 01.04.2025.
//

import Foundation
@testable import FxTrackR

enum MockAPIServiceError: Error {
    case noResponse
}

actor APIServiceRequestsCounter {
    var loadAssetsCount = 0
    var loadRatesCount = 0
    
    func incrementLoadAssetsCount() {
        loadAssetsCount += 1
    }
    
    func incrementLoadRatesCount() {
        loadRatesCount += 1
    }
}

struct MockAPIService: APIService {
    let requestsCounter = APIServiceRequestsCounter()
    var loadAssetsResult: Result<[Asset], Error> = .failure(MockAPIServiceError.noResponse)
    var loadRatesResult: Result<[Asset.Code: Decimal], Error> = .failure(MockAPIServiceError.noResponse)
    
    func loadAssets() async throws -> [Asset] {
        await requestsCounter.incrementLoadAssetsCount()
        return try loadAssetsResult.get()
    }
    
    func loadRates() async throws -> [Asset.Code: Decimal] {
        await requestsCounter.incrementLoadRatesCount()
        return try loadRatesResult.get()
    }
}

