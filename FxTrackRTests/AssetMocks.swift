//
//  AssetMocks.swift
//  FxTrackRTests
//
//  Created by Sviatoslav Yakymiv on 01.04.2025.
//

@testable import FxTrackR

extension Asset {
    static let usd = Asset(code: "USD", name: "United States Dollar")
    static let eur = Asset(code: "EUR", name: "Euro")
    static let uah = Asset(code: "UAH", name: "Ukrainian Hryvnia")
    static let aed = Asset(code: "AED", name: "United Arab Emirates Dirham")
    static let btc = Asset(code: "BTC", name: "Bitcoin")
}
