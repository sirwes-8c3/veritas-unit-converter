//
//  ConversionDataLoaderTests.swift
//  VeritasUnitConverterTests
//

import XCTest
@testable import VeritasUnitConverter

@MainActor
final class ConversionDataLoaderTests: XCTestCase {

    // MARK: - Load Conversions Tests

    func testLoadConversions() throws {
        let data = try ConversionDataLoader.loadConversions()

        XCTAssertEqual(data.categories.count, 4, "Should load 4 categories from conversions.json")
    }

    // MARK: - Category Loading Tests

    func testLoadWeightCategory() throws {
        let units = try ConversionDataLoader.getUnits(for: .weight)

        XCTAssertEqual(units.count, 2, "Weight category should have 2 units")

        let unitIds = units.map { $0.id }
        XCTAssertTrue(unitIds.contains("gram"), "Weight category should contain gram")
        XCTAssertTrue(unitIds.contains("ounce"), "Weight category should contain ounce")
    }

    func testLoadLengthCategory() throws {
        let units = try ConversionDataLoader.getUnits(for: .length)

        XCTAssertEqual(units.count, 2, "Length category should have 2 units")

        let unitIds = units.map { $0.id }
        XCTAssertTrue(unitIds.contains("centimeter"), "Length category should contain centimeter")
        XCTAssertTrue(unitIds.contains("inch"), "Length category should contain inch")
    }

    func testLoadTemperatureCategory() throws {
        let units = try ConversionDataLoader.getUnits(for: .temperature)

        XCTAssertEqual(units.count, 2, "Temperature category should have 2 units")

        let unitIds = units.map { $0.id }
        XCTAssertTrue(unitIds.contains("celsius"), "Temperature category should contain celsius")
        XCTAssertTrue(unitIds.contains("fahrenheit"), "Temperature category should contain fahrenheit")
    }

    func testLoadVolumeCategory() throws {
        let units = try ConversionDataLoader.getUnits(for: .volume)

        XCTAssertEqual(units.count, 2, "Volume category should have 2 units")

        let unitIds = units.map { $0.id }
        XCTAssertTrue(unitIds.contains("milliliter"), "Volume category should contain milliliter")
        XCTAssertTrue(unitIds.contains("fluidounce"), "Volume category should contain fluidounce")
    }

    func testFavoritesCategoryReturnsEmpty() throws {
        let units = try ConversionDataLoader.getUnits(for: .favorites)

        XCTAssertTrue(units.isEmpty, "Favorites category should return empty array")
    }
}
