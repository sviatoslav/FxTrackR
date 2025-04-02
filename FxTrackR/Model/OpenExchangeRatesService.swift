//
//  OpenExchangeRatesService.swift
//  FxTrackR
//
//  Created by Sviatoslav Yakymiv on 31.03.2025.
//

import Foundation

struct OpenExchangeRatesService: APIService {
    enum Error: Swift.Error {
        case failedToBuildURL
    }
    private let baseURL = URL(string: "https://openexchangerates.org/api/")!
    private let apiKey: String
    private let session: URLSession
    
    init(apiKey: String, session: URLSession) {
        self.apiKey = apiKey
        self.session = session
    }
    
    func loadAssets() async throws -> [Asset] {
        try await load([String: String].self, from: url(for: "currencies.json"))
            .sorted(by: { $0.value.localizedStandardCompare($1.value) == .orderedAscending })
            .map({ .init(code: .init(rawValue: $0.key), name: $0.value) })
    }
    
    func loadRates() async throws -> [Asset.Code : Decimal] {
        try await load(RatesResponse.self, from: url(for: "latest.json")).rates.reduce(into: [:]) {
            $0[Asset.Code.init(rawValue: $1.key)] = $1.value
        }
    }
    
    private func load<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        do {
            return try await load(type, for: .init(url: url, cachePolicy: .reloadRevalidatingCacheData))
        } catch let error as URLError where error.code == .notConnectedToInternet {
            return try await load(type, for: .init(url: url, cachePolicy: .returnCacheDataDontLoad))
        } catch {
            throw error
        }
    }
    
    private func load<T: Decodable>(_ type: T.Type, for request: URLRequest) async throws -> T {
        let data = try await session.data(for: request).0
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    private func url(for path: String, with parameters: [String: String] = [:]) throws -> URL {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            throw Error.failedToBuildURL
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "app_id", value: apiKey),
        ] + parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        guard let url = components.url else {
            throw Error.failedToBuildURL
        }
        return url
    }
}
