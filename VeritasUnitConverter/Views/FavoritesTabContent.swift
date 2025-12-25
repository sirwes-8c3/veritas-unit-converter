//
//  FavoritesTabContent.swift
//  VeritasUnitConverter
//

import SwiftUI

struct FavoritesTabContent: View {
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var allCategories: [CategoryData] = []

    var body: some View {
        Group {
            if favoritesManager.favorites.isEmpty {
                ContentUnavailableView {
                    Label("No Favorites", systemImage: "star")
                } description: {
                    Text("Tap the star icon in any conversion to add it to your favorites.")
                }
            } else {
                List {
                    ForEach(favoritesManager.favorites) { favorite in
                        FavoriteRow(favorite: favorite, allCategories: allCategories)
                    }
                    .onDelete(perform: deleteFavorites)
                }
            }
        }
        .navigationTitle("Favorites")
        .onAppear {
            loadCategories()
        }
    }

    private func loadCategories() {
        do {
            let conversionsData = try ConversionDataLoader.loadConversions()
            allCategories = conversionsData.categories
        } catch {
            print("Failed to load categories: \(error)")
            allCategories = []
        }
    }

    private func deleteFavorites(at offsets: IndexSet) {
        for index in offsets {
            let favorite = favoritesManager.favorites[index]
            favoritesManager.removeFavorite(favorite)
        }
    }
}

// MARK: - FavoriteRow

struct FavoriteRow: View {
    let favorite: FavoriteConversion
    let allCategories: [CategoryData]

    private var categoryData: CategoryData? {
        allCategories.first { $0.id == favorite.categoryId }
    }

    private var leftUnit: Unit? {
        categoryData?.units.first { $0.id == favorite.leftUnitId }
    }

    private var rightUnit: Unit? {
        categoryData?.units.first { $0.id == favorite.rightUnitId }
    }

    private var category: ConversionCategory? {
        ConversionCategory(rawValue: favorite.categoryId)
    }

    var body: some View {
        if let categoryData = categoryData,
           let leftUnit = leftUnit,
           let rightUnit = rightUnit,
           let category = category {
            NavigationLink {
                ConversionView(
                    category: category,
                    units: categoryData.units
                )
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(categoryData.name)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(leftUnit.name) → \(rightUnit.name)")
                        .font(.body)
                }
            }
        } else {
            Text("Unknown Conversion")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesTabContent()
    }
}
