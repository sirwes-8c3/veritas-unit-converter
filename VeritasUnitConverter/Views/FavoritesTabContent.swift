//
//  FavoritesTabContent.swift
//  VeritasUnitConverter
//

import SwiftUI

struct FavoritesTabContent: View {
    var body: some View {
        ContentUnavailableView {
            Label("No Favorites", systemImage: "star")
        } description: {
            Text("Tap the star icon in any conversion to add it to your favorites.")
        }
        .navigationTitle("Favorites")
    }
}

#Preview {
    NavigationStack {
        FavoritesTabContent()
    }
}
