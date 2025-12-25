//
//  FavoritesManagerTests.swift
//  VeritasUnitConverterTests
//

import XCTest
@testable import VeritasUnitConverter

@MainActor
final class FavoritesManagerTests: XCTestCase {

    private let storageKey = "favoriteConversions"

    override func setUp() async throws {
        // Clear UserDefaults before each test
        UserDefaults.standard.removeObject(forKey: storageKey)
    }

    override func tearDown() async throws {
        // Clear UserDefaults after each test
        UserDefaults.standard.removeObject(forKey: storageKey)
    }

    // MARK: - Initial State Tests

    func testInitiallyEmpty() async throws {
        let manager = FavoritesManager()

        XCTAssertTrue(manager.favorites.isEmpty, "New manager should have no favorites")
    }

    // MARK: - Add Favorite Tests

    func testAddFavorite() async throws {
        let manager = FavoritesManager()

        manager.addFavorite(categoryId: "weight", fromUnitId: "gram", toUnitId: "ounce")

        XCTAssertEqual(manager.favorites.count, 1, "Should have 1 favorite after adding")
        XCTAssertEqual(manager.favorites.first?.categoryId, "weight", "Favorite should have correct category")
        XCTAssertEqual(manager.favorites.first?.leftUnitId, "gram", "Favorite should have correct left unit")
        XCTAssertEqual(manager.favorites.first?.rightUnitId, "ounce", "Favorite should have correct right unit")
    }

    // MARK: - Remove Favorite Tests

    func testRemoveFavorite() async throws {
        let manager = FavoritesManager()

        manager.addFavorite(categoryId: "weight", fromUnitId: "gram", toUnitId: "ounce")
        XCTAssertEqual(manager.favorites.count, 1, "Should have 1 favorite after adding")

        if let favorite = manager.favorites.first {
            manager.removeFavorite(favorite)
        }

        XCTAssertTrue(manager.favorites.isEmpty, "Should have no favorites after removing")
    }

    // MARK: - Check Favorite Tests

    func testIsFavorite() async throws {
        let manager = FavoritesManager()

        manager.addFavorite(categoryId: "weight", fromUnitId: "gram", toUnitId: "ounce")

        XCTAssertTrue(
            manager.isFavorite(categoryId: "weight", fromUnitId: "gram", toUnitId: "ounce"),
            "Should return true for added favorite"
        )

        XCTAssertFalse(
            manager.isFavorite(categoryId: "length", fromUnitId: "centimeter", toUnitId: "inch"),
            "Should return false for non-existent favorite"
        )
    }

    // MARK: - Duplicate Prevention Tests

    func testNoDuplicates() async throws {
        let manager = FavoritesManager()

        manager.addFavorite(categoryId: "weight", fromUnitId: "gram", toUnitId: "ounce")
        manager.addFavorite(categoryId: "weight", fromUnitId: "gram", toUnitId: "ounce")

        XCTAssertEqual(manager.favorites.count, 1, "Should prevent duplicate favorites")
    }

    // MARK: - Persistence Tests

    func testPersistence() async throws {
        // Create first manager and add a favorite
        let manager1 = FavoritesManager()
        manager1.addFavorite(categoryId: "weight", fromUnitId: "gram", toUnitId: "ounce")

        XCTAssertEqual(manager1.favorites.count, 1, "First manager should have 1 favorite")

        // Create second manager instance - should load from UserDefaults
        let manager2 = FavoritesManager()

        XCTAssertEqual(manager2.favorites.count, 1, "Second manager should load 1 favorite from UserDefaults")
        XCTAssertEqual(manager2.favorites.first?.categoryId, "weight", "Loaded favorite should have correct category")
        XCTAssertEqual(manager2.favorites.first?.leftUnitId, "gram", "Loaded favorite should have correct left unit")
        XCTAssertEqual(manager2.favorites.first?.rightUnitId, "ounce", "Loaded favorite should have correct right unit")
    }
}
