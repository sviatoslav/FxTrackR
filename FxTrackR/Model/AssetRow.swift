//
//  AssetRow.swift
//  FxTrackR
//
//  Created by Sviatoslav Yakymiv on 31.03.2025.
//

import SwiftUI

struct AssetRow<Accessory: View>: View {
    var asset: Asset
    var accessory: Accessory
    var body: some View {
        HStack {
            Text(asset.code.rawValue)
                .font(.caption)
                .padding(10)
                .background(Circle().fill(Color.gray.opacity(0.2)))

            Text(asset.name)

            Spacer()
            
            accessory
        }
        .padding(.vertical, 4)
    }
}

extension AssetRow where Accessory == EmptyView {
    init(asset: Asset) {
        self.asset = asset
        self.accessory = .init()
    }
}
