//
//  OpenExchangeRatesServiceTests.swift
//  FxTrackRTests
//
//  Created by Sviatoslav Yakymiv on 01.04.2025.
//

import Foundation
import Testing
@testable import FxTrackR

@Suite(.serialized)
struct OpenExchangeRatesServiceTests {
    
    let session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }()
    
    @Test("Rates URL is correct") func verifyCorrectRatesURL() async throws {
        await confirmation { confirm in
            MockURLProtocol.requestHandler = {
                #expect($0.url?.absoluteString == "https://openexchangerates.org/api/latest.json?app_id=API_KEY")
                return (HTTPURLResponse(), Data())
            }
            let service = OpenExchangeRatesService(apiKey: "API_KEY", session: self.session)
            _ = try? await service.loadRates()
            confirm()
        }
    }
    
    @Test("Assets URL is correct") func verifyCorrectAssetsURL() async throws {
        await confirmation { confirm in
            MockURLProtocol.requestHandler = {
                #expect($0.url?.absoluteString == "https://openexchangerates.org/api/currencies.json?app_id=API_KEY")
                return (HTTPURLResponse(), Data())
            }
            let service = OpenExchangeRatesService(apiKey: "API_KEY", session: self.session)
            _ = try? await service.loadAssets()
            confirm()
        }
    }
    
    @Test("Rates response handling is correct") func verifyRatesResponseHandling() async throws {
        MockURLProtocol.requestHandler = { _ in
            let json = """
            {
                "disclaimer": "Usage subject to terms: https://openexchangerates.org/terms",
                "license": "https://openexchangerates.org/license",
                "timestamp": 1743494400,
                "base": "USD",
                "rates": {
                    "AED": 3.673005,
                    "EUR": 0.925769,
                    "USD": 1
                }
            }
            """.data(using: .utf8)!
            return (HTTPURLResponse(), json)
        }
        let service = OpenExchangeRatesService(apiKey: "API_KEY", session: self.session)
        let rates = try await service.loadRates()
        #expect(rates == ["AED": Decimal(string: "3.673005"), "EUR": Decimal(string: "0.925769"), "USD": Decimal(string: "1")])
    }
    
    @Test("Assets response handling is correct") func verifyAssetsResponseHandling() async throws {
        MockURLProtocol.requestHandler = { _ in
            let json = #"{"USD":"United States Dollar","EUR":"Euro","UAH":"Ukrainian Hryvnia"}"#.data(using: .utf8)!
            return (HTTPURLResponse(), json)
        }
        let service = OpenExchangeRatesService(apiKey: "API_KEY", session: self.session)
        let assets = try await service.loadAssets()
        #expect(assets == [.init(code: "EUR", name: "Euro"),
                           .init(code: "UAH", name: "Ukrainian Hryvnia"),
                           .init(code: "USD", name: "United States Dollar")])
    }

}
