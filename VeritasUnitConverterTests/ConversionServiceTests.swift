//
//  ConversionServiceTests.swift
//  VeritasUnitConverterTests
//

import XCTest
@testable import VeritasUnitConverter

@MainActor
final class ConversionServiceTests: XCTestCase {

    // MARK: - Weight Conversion Tests

    func testGramToOunce() throws {
        let gram = Unit(id: "gram", name: "Gram", symbol: "g", toBase: 1.0, toBaseOffset: 0)
        let ounce = Unit(id: "ounce", name: "Ounce", symbol: "oz", toBase: 28.3495, toBaseOffset: 0)

        let result = ConversionService.convert(value: 100, from: gram, to: ounce)

        XCTAssertEqual(result, 3.5274, accuracy: 0.0001, "100g should convert to approximately 3.5274oz")
    }

    func testOunceToGram() throws {
        let gram = Unit(id: "gram", name: "Gram", symbol: "g", toBase: 1.0, toBaseOffset: 0)
        let ounce = Unit(id: "ounce", name: "Ounce", symbol: "oz", toBase: 28.3495, toBaseOffset: 0)

        let result = ConversionService.convert(value: 1, from: ounce, to: gram)

        XCTAssertEqual(result, 28.3495, accuracy: 0.0001, "1oz should convert to 28.3495g")
    }

    // MARK: - Length Conversion Tests

    func testCentimeterToInch() throws {
        let cm = Unit(id: "centimeter", name: "Centimeter", symbol: "cm", toBase: 1.0, toBaseOffset: 0)
        let inch = Unit(id: "inch", name: "Inch", symbol: "in", toBase: 2.54, toBaseOffset: 0)

        let result = ConversionService.convert(value: 100, from: cm, to: inch)

        XCTAssertEqual(result, 39.3701, accuracy: 0.0001, "100cm should convert to approximately 39.3701in")
    }

    func testInchToCentimeter() throws {
        let cm = Unit(id: "centimeter", name: "Centimeter", symbol: "cm", toBase: 1.0, toBaseOffset: 0)
        let inch = Unit(id: "inch", name: "Inch", symbol: "in", toBase: 2.54, toBaseOffset: 0)

        let result = ConversionService.convert(value: 1, from: inch, to: cm)

        XCTAssertEqual(result, 2.54, accuracy: 0.0001, "1in should convert to 2.54cm")
    }

    // MARK: - Temperature Conversion Tests (Critical)

    func testCelsiusToFahrenheit_Freezing() throws {
        let celsius = Unit(id: "celsius", name: "Celsius", symbol: "°C", toBase: 1.0, toBaseOffset: 273.15)
        let fahrenheit = Unit(id: "fahrenheit", name: "Fahrenheit", symbol: "°F", toBase: 0.5555555556, toBaseOffset: 255.3722222222)

        let result = ConversionService.convert(value: 0, from: celsius, to: fahrenheit)

        XCTAssertEqual(result, 32.0, accuracy: 0.0001, "0°C should convert to 32°F (freezing point)")
    }

    func testCelsiusToFahrenheit_Boiling() throws {
        let celsius = Unit(id: "celsius", name: "Celsius", symbol: "°C", toBase: 1.0, toBaseOffset: 273.15)
        let fahrenheit = Unit(id: "fahrenheit", name: "Fahrenheit", symbol: "°F", toBase: 0.5555555556, toBaseOffset: 255.3722222222)

        let result = ConversionService.convert(value: 100, from: celsius, to: fahrenheit)

        XCTAssertEqual(result, 212.0, accuracy: 0.0001, "100°C should convert to 212°F (boiling point)")
    }

    func testFahrenheitToCelsius_Freezing() throws {
        let celsius = Unit(id: "celsius", name: "Celsius", symbol: "°C", toBase: 1.0, toBaseOffset: 273.15)
        let fahrenheit = Unit(id: "fahrenheit", name: "Fahrenheit", symbol: "°F", toBase: 0.5555555556, toBaseOffset: 255.3722222222)

        let result = ConversionService.convert(value: 32, from: fahrenheit, to: celsius)

        XCTAssertEqual(result, 0.0, accuracy: 0.0001, "32°F should convert to 0°C (freezing point)")
    }

    func testFahrenheitToCelsius_Boiling() throws {
        let celsius = Unit(id: "celsius", name: "Celsius", symbol: "°C", toBase: 1.0, toBaseOffset: 273.15)
        let fahrenheit = Unit(id: "fahrenheit", name: "Fahrenheit", symbol: "°F", toBase: 0.5555555556, toBaseOffset: 255.3722222222)

        let result = ConversionService.convert(value: 212, from: fahrenheit, to: celsius)

        XCTAssertEqual(result, 100.0, accuracy: 0.0001, "212°F should convert to 100°C (boiling point)")
    }

    // MARK: - Volume Conversion Tests

    func testMilliliterToFluidOunce() throws {
        let mL = Unit(id: "milliliter", name: "Milliliter", symbol: "mL", toBase: 1.0, toBaseOffset: 0)
        let flOz = Unit(id: "fluidounce", name: "Fluid Ounce", symbol: "fl oz", toBase: 29.5735, toBaseOffset: 0)

        let result = ConversionService.convert(value: 100, from: mL, to: flOz)

        XCTAssertEqual(result, 3.3814, accuracy: 0.0001, "100mL should convert to approximately 3.3814 fl oz")
    }

    func testFluidOunceToMilliliter() throws {
        let mL = Unit(id: "milliliter", name: "Milliliter", symbol: "mL", toBase: 1.0, toBaseOffset: 0)
        let flOz = Unit(id: "fluidounce", name: "Fluid Ounce", symbol: "fl oz", toBase: 29.5735, toBaseOffset: 0)

        let result = ConversionService.convert(value: 1, from: flOz, to: mL)

        XCTAssertEqual(result, 29.5735, accuracy: 0.0001, "1 fl oz should convert to 29.5735mL")
    }

    // MARK: - Edge Case Tests

    func testSameUnitConversion() throws {
        let gram = Unit(id: "gram", name: "Gram", symbol: "g", toBase: 1.0, toBaseOffset: 0)

        let result = ConversionService.convert(value: 100, from: gram, to: gram)

        XCTAssertEqual(result, 100.0, accuracy: 0.0001, "Converting to same unit should return same value")
    }

    func testFormatValue() throws {
        let formatted = ConversionService.format(value: 3.527396195, decimals: 4)

        XCTAssertEqual(formatted, "3.5274", "Should format to 4 decimal places")
    }

    func testFormatWholeNumber() throws {
        let formatted = ConversionService.format(value: 100.0, decimals: 4)

        XCTAssertEqual(formatted, "100", "Should format whole number without decimal places")
    }
}
