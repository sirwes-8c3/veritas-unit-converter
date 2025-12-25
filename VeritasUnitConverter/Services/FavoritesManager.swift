//
//  FavoritesManager.swift
//  VeritasUnitConverter
//

import Foundation
import Observation

@Observable
@MainActor
class FavoritesManager {
    private let storageKey = "favoriteConversions"

    var favorites: [FavoriteConversion] = [] {
        didSet {
            saveFavorites()
        }
    }

    init() {
        loadFavorites()
    }

    func addFavorite(categoryId: String, fromUnitId: String, toUnitId: String) {
        // Prevent duplicates
        guard !isFavorite(categoryId: categoryId, fromUnitId: fromUnitId, toUnitId: toUnitId) else {
            return
        }

        let favorite = FavoriteConversion(
            categoryId: categoryId,
            leftUnitId: fromUnitId,
            rightUnitId: toUnitId
        )
        favorites.append(favorite)
    }

    func removeFavorite(_ favorite: FavoriteConversion) {
        favorites.removeAll { $0.id == favorite.id }
    }

    func isFavorite(categoryId: String, fromUnitId: String, toUnitId: String) -> Bool {
        favorites.contains { favorite in
            favorite.categoryId == categoryId &&
            favorite.leftUnitId == fromUnitId &&
            favorite.rightUnitId == toUnitId
        }
    }

    // MARK: - Persistence

    private func loadFavorites() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return
        }

        do {
            let decoded = try JSONDecoder().decode([FavoriteConversion].self, from: data)
            favorites = decoded
        } catch {
            print("Failed to decode favorites: \(error)")
            favorites = []
        }
    }

    private func saveFavorites() {
        do {
            let encoded = try JSONEncoder().encode(favorites)
            UserDefaults.standard.set(encoded, forKey: storageKey)
        } catch {
            print("Failed to encode favorites: \(error)")
        }
    }
}
