//
//  APIService.swift
//  FxTrackR
//
//  Created by Sviatoslav Yakymiv on 31.03.2025.
//

import SwiftUI
import Foundation

protocol APIService: Sendable {
    func loadAssets() async throws -> [Asset]
    func loadRates() async throws -> [Asset.Code: Decimal]
}

private struct AlwaysFailingAPIService: APIService {
    enum Error: Swift.Error {
        case fail
    }
    func loadAssets() async throws -> [Asset] {
        throw Error.fail
    }
    
    func loadRates() async throws -> [Asset.Code: Decimal] {
        throw Error.fail
    }
}

extension EnvironmentValues {
    @Entry var apiService: APIService = AlwaysFailingAPIService()
}

