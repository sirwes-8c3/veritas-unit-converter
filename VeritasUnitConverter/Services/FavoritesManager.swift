//
//  FavoritesManager.swift
//  VeritasUnitConverter
//

import Foundation
import Observation

@Observable
@MainActor
class FavoritesManager {
    var favorites: [FavoriteConversion] = []

    init() {
        // TODO: Load from UserDefaults
    }

    func addFavorite(_ favorite: FavoriteConversion) {
        // TODO: Implement
    }

    func removeFavorite(_ favorite: FavoriteConversion) {
        // TODO: Implement
    }

    func isFavorite(categoryId: String, leftUnitId: String, rightUnitId: String) -> Bool {
        // TODO: Implement
        return false
    }
}
