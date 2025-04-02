//
//  HomeView.swift
//  FxTrackR
//
//  Created by Sviatoslav Yakymiv on 31.03.2025.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.settings) var settings
    @Environment(\.apiService) var apiService
    var body: some View {
        _HomeView(settings: settings, apiService: apiService)
    }
}

private struct _HomeView: View {
    @State private var isAddingAsset = false
    @State private var editMode = EditMode.inactive
    @StateObject private var viewModel: HomeViewModel
    init(settings: Settings, apiService: APIService) {
        _viewModel = .init(wrappedValue: .init(settings: settings, apiService: apiService))
    }
    
    var body: some View {
        ZStack {
            emptyStateView.opacity(viewModel.assets.isEmpty ? 1 : 0)
            assetsList.opacity(viewModel.assets.isEmpty ? 0 : 1)
        }
        .animation(.default, value: viewModel.assets.isEmpty)
        .onAppear {
            viewModel.fetchRatesIfNeeded()
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !viewModel.assets.isEmpty {
                    EditButton()
                        .environment(\.editMode, $editMode)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation {
                        editMode = .inactive
                    }
                    isAddingAsset = true
                }) {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
        .sheet(isPresented: $isAddingAsset) {
            NavigationView {
                AddAssetsView(excludeAssets: viewModel.assets, completion: { viewModel.assets += $0 })
            }
        }
    }
    
    @ViewBuilder private var emptyStateView: some View {
        VStack(spacing: 16) {
            Text("No assets selected")
                .font(.title3)
                .foregroundStyle(.secondary)
            Button(action: {
                isAddingAsset = true
            }) {
                Label("Add Asset", systemImage: "plus")
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Color.accentColor))
                    .foregroundStyle(.white)
            }
        }
        .padding(.bottom, 50)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder private var assetsList: some View {
        List {
            Section {
                ForEach(viewModel.assets) { asset in
                    AssetRow(asset: asset, accessory: accessory(asset))
                }
                .onDelete { indexSet in
                    viewModel.removeAssets(atOffsets: indexSet)
                }
                .onMove { indices, newOffset in
                    viewModel.moveAssets(fromOffsets: indices, toOffset: newOffset)
                }
            } footer: {
                Text(verbatim: viewModel.statusMessage)
                    .font(.subheadline).foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .opacity(viewModel.statusMessage.isEmpty ? 0 : 1)
            }
            .listSectionSeparator(.hidden)
        }
        .environment(\.editMode, $editMode)
    }
    
    @ViewBuilder private func accessory(_ asset: Asset) -> some View {
        let rate = viewModel.rates[asset.id]
        Group {
            if let rate {
                Text("\(rate)").font(.footnote).foregroundColor(.secondary)
            } else {
                ProgressView()
            }
        }.animation(.default, value: rate)
    }
}
