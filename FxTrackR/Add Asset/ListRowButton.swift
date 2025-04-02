//
//  ListRowButton.swift
//  FxTrackR
//
//  Created by Sviatoslav Yakymiv on 31.03.2025.
//

import SwiftUI

struct ListRowButton<Label: View>: View {
    let action: @MainActor @Sendable () -> Void
    let label: @MainActor @Sendable () -> Label
    
    var body: some View {
        Button(action: action) {
            label()
            //Restore default insets
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .contentShape(.rect)
        }
        .buttonStyle(HighlightButtonStyle())
        .listRowInsets(EdgeInsets())
    }
}

private struct HighlightButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color(uiColor: .tertiarySystemFill) : Color.clear)
    }
}
