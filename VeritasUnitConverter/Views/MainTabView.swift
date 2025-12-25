//
//  MainTabView.swift
//  VeritasUnitConverter
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: ConversionCategory = .weight

    private let standardCategories: [ConversionCategory] = [.weight, .length, .temperature, .volume]

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(standardCategories) { category in
                NavigationStack {
                    CategoryTabContent(category: category)
                }
                .tabItem {
                    Label(category.displayName, systemImage: category.iconName)
                }
                .tag(category)
                .accessibilityIdentifier("\(category.rawValue)Tab")
            }

            // Favorites tab
            NavigationStack {
                FavoritesTabContent()
            }
            .tabItem {
                Label("Favorites", systemImage: "star.fill")
            }
            .tag(ConversionCategory.favorites)
            .accessibilityIdentifier("favoritesTab")
        }
    }
}

#Preview {
    MainTabView()
}
