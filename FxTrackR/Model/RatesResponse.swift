//
//  RatesResponse.swift
//  FxTrackR
//
//  Created by Sviatoslav Yakymiv on 31.03.2025.
//

import Foundation

struct RatesResponse: Decodable {
    let rates: [String: Decimal]
}
