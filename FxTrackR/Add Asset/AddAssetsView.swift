//
//  AddAssetsView.swift
//  FxTrackR
//
//  Created by Sviatoslav Yakymiv on 31.03.2025.
//

import SwiftUI

struct AddAssetsView: View {
    typealias Completion = @MainActor @Sendable ([Asset]) -> Void
    @Environment(\.apiService) var apiService
    let excludeAssets: [Asset]
    let completion: Completion
    var body: some View {
        _AddAssetsView(apiService: apiService, excludeAssets: excludeAssets, completion: completion)
    }
}

struct _AddAssetsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: AddAssetsViewModel
    let completion: AddAssetsView.Completion
    @State var placeholderAssets: [Asset] = [
            .init(code: "USD", name: "United States Dollar"),
            .init(code: "EUR", name: "Euro"),
            .init(code: "JPY", name: "Japanese Yen"),
            .init(code: "GBP", name: "British Pound Sterling"),
            .init(code: "UAH", name: "Ukrainian Hryvnia"),
            .init(code: "AED", name: "United Arab Emirates Dirham")
    ].shuffled()
    init(apiService: APIService, excludeAssets: [Asset], completion: @escaping AddAssetsView.Completion) {
        _viewModel = .init(wrappedValue: .init(apiService: apiService, excludeAssets: excludeAssets))
        self.completion = completion
    }
    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle:
                Color.clear.onAppear(perform: viewModel.loadAssets)
            case .loading:
                List(placeholderAssets) { asset in
                    ListRowButton {
                        viewModel.toggleSelection(for: asset)
                    } label: {
                        AssetRow(asset: asset, accessory: accessory(for: asset))
                    }
                    
                }
                .listStyle(.plain)
                .allowsHitTesting(false)
                .redacted(reason: .placeholder)
            case .loaded:
                let assets = viewModel.displayedAssets
                List(assets) { asset in
                    ListRowButton {
                        viewModel.toggleSelection(for: asset)
                    } label: {
                        AssetRow(asset: asset, accessory: accessory(for: asset))
                    }
                    
                }
                .overlay(Group {
                    if assets.isEmpty {
                        Text("No assets found.").foregroundStyle(.secondary)
                    }
                })
                .listStyle(.plain)
                .searchable(text: $viewModel.searchText)
            case .failed:
                VStack {
                    Text("Failed to load.").foregroundStyle(.secondary)
                    Button("Retry", action: viewModel.loadAssets)
                        .buttonStyle(.borderedProminent)
                        .padding(.top)
                }
            }
        }
        .toolbar {
            Button("Done") {
                let assets = viewModel.selectedAssets.sorted(by: { $0.name.localizedStandardCompare($1.name) == .orderedAscending })
                completion(assets)
                dismiss()
            }
        }
        .navigationTitle(Text("Add Asset"))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder private func accessory(for asset: Asset) -> some View {
        Group {
            if viewModel.selectedAssets.contains(asset) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.tint)
            } else {
                Image(systemName: "circle")
                    .foregroundStyle(.gray)
            }
        }.font(.title2)
    }
}
