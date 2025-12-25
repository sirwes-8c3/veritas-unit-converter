//
//  VeritasUnitConverterUITests.swift
//  VeritasUnitConverterUITests
//
//  Created by Wesley Yu on 12/24/25.
//

import XCTest

final class VeritasUnitConverterUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Tab Navigation Tests

    @MainActor
    func testAllTabsExist() throws {
        // Verify all 5 tab buttons exist
        XCTAssertTrue(app.buttons["weightTab"].exists, "Weight tab should exist")
        XCTAssertTrue(app.buttons["lengthTab"].exists, "Length tab should exist")
        XCTAssertTrue(app.buttons["temperatureTab"].exists, "Temperature tab should exist")
        XCTAssertTrue(app.buttons["volumeTab"].exists, "Volume tab should exist")
        XCTAssertTrue(app.buttons["favoritesTab"].exists, "Favorites tab should exist")
    }

    @MainActor
    func testTabNavigation() throws {
        // Step 1: Launch app - navigation bar shows "Weight"
        XCTAssertTrue(app.navigationBars["Weight"].exists, "Navigation bar should show 'Weight' on launch")

        // Step 2: Tap "Length" tab
        app.buttons["lengthTab"].tap()
        XCTAssertTrue(app.navigationBars["Length"].exists, "Navigation bar should show 'Length'")

        // Step 3: Tap "Temperature" tab
        app.buttons["temperatureTab"].tap()
        XCTAssertTrue(app.navigationBars["Temperature"].exists, "Navigation bar should show 'Temperature'")

        // Step 4: Tap "Volume" tab
        app.buttons["volumeTab"].tap()
        XCTAssertTrue(app.navigationBars["Volume"].exists, "Navigation bar should show 'Volume'")

        // Step 5: Tap "Favorites" tab
        app.buttons["favoritesTab"].tap()
        XCTAssertTrue(app.navigationBars["Favorites"].exists, "Navigation bar should show 'Favorites'")
    }

    // MARK: - Conversion Flow Tests

    @MainActor
    func testWeightConversion() throws {
        // Navigate to Weight tab (should be default)
        app.buttons["weightTab"].tap()

        // Find text fields
        let leftField = app.textFields["leftTextField"]
        let rightField = app.textFields["rightTextField"]

        XCTAssertTrue(leftField.exists, "Left text field should exist")
        XCTAssertTrue(rightField.exists, "Right text field should exist")

        // Tap left field, type "100"
        leftField.tap()
        leftField.typeText("100")

        // Tap "Convert" button in keyboard toolbar
        app.buttons["convertButton"].tap()

        // Assert right field has non-empty, non-zero value
        let rightValue = rightField.value as? String ?? ""
        XCTAssertFalse(rightValue.isEmpty, "Right field should have a value")
        XCTAssertNotEqual(rightValue, "0", "Right field should not be zero")
    }

    @MainActor
    func testTemperatureConversion() throws {
        // Navigate to Temperature tab
        app.buttons["temperatureTab"].tap()

        let leftField = app.textFields["leftTextField"]
        let rightField = app.textFields["rightTextField"]

        // Enter "100" in left field (Celsius)
        leftField.tap()
        leftField.typeText("100")

        // Tap Convert
        app.buttons["convertButton"].tap()

        // Wait a moment for conversion to complete
        sleep(1)

        // Assert right field contains "212" (Fahrenheit)
        let rightValue = rightField.value as? String ?? ""
        XCTAssertTrue(rightValue.contains("212"), "100°C should convert to 212°F, got: \(rightValue)")
    }

    @MainActor
    func testBidirectionalConversion() throws {
        // Step 1: Navigate to Weight, enter 28.3495 in left
        app.buttons["weightTab"].tap()

        let leftField = app.textFields["leftTextField"]
        let rightField = app.textFields["rightTextField"]

        leftField.tap()
        leftField.typeText("28.3495")

        // Step 2: Tap Convert - right field should contain "1"
        app.buttons["convertButton"].tap()
        sleep(1)

        let rightValue = rightField.value as? String ?? ""
        XCTAssertTrue(rightValue.contains("1"), "28.3495 grams should convert to ~1 ounce, got: \(rightValue)")

        // Step 3: Tap right field - left field should clear
        rightField.tap()
        sleep(1)

        let leftValueAfterFocus = leftField.value as? String ?? ""
        XCTAssertTrue(leftValueAfterFocus.isEmpty || leftValueAfterFocus == "0", "Left field should clear when right field is focused")

        // Step 4: Enter "1" in right field
        rightField.typeText("1")

        // Step 5: Tap Convert - left field should contain "28"
        app.buttons["convertButton"].tap()
        sleep(1)

        let leftValue = leftField.value as? String ?? ""
        XCTAssertTrue(leftValue.contains("28"), "1 ounce should convert to ~28.35 grams, got: \(leftValue)")
    }

    // MARK: - Focus Behavior Tests

    @MainActor
    func testFocusClearsOppositeField() throws {
        // Navigate to Length tab
        app.buttons["lengthTab"].tap()

        let leftField = app.textFields["leftTextField"]
        let rightField = app.textFields["rightTextField"]

        // Enter "100" in left, convert → right has value
        leftField.tap()
        leftField.typeText("100")
        app.buttons["convertButton"].tap()
        sleep(1)

        let rightValueBeforeFocus = rightField.value as? String ?? ""
        XCTAssertFalse(rightValueBeforeFocus.isEmpty, "Right field should have a value after conversion")

        // Tap right field
        rightField.tap()

        // Type in right → left should be cleared (tests onChange behavior)
        rightField.typeText("50")

        let leftValueAfterRightFocus = leftField.value as? String ?? ""
        XCTAssertTrue(leftValueAfterRightFocus.isEmpty || leftValueAfterRightFocus == "0", "Left field should be cleared when right field receives focus")
    }

    // MARK: - Favorites Tests

    @MainActor
    func testAddAndRemoveFavorite() throws {
        // Step 1: Navigate to Weight
        app.buttons["weightTab"].tap()

        // Step 2: Tap star button
        let starButton = app.buttons["starButton"]
        if starButton.exists {
            starButton.tap()
        } else {
            // If already favorited, tap star.fill
            app.buttons["starFillButton"].tap()
            // Tap again to re-add
            sleep(1)
            app.buttons["starButton"].tap()
        }

        sleep(1)

        // Star icon should change to filled
        XCTAssertTrue(app.buttons["starFillButton"].exists, "Star should be filled after tapping")

        // Step 3: Navigate to Favorites tab
        app.buttons["favoritesTab"].tap()

        // List should have at least 1 cell
        let cells = app.cells
        XCTAssertGreaterThan(cells.count, 0, "Favorites list should have at least 1 cell")

        // Step 4: Swipe left on first cell
        let firstCell = cells.firstMatch
        firstCell.swipeLeft()

        // Step 5: Tap Delete
        app.buttons["Delete"].tap()
        sleep(1)

        // "No Favorites" should appear
        XCTAssertTrue(app.otherElements["noFavoritesView"].exists, "Should show 'No Favorites' after deleting last favorite")
    }

    @MainActor
    func testFavoritePersistsAcrossRelaunch() throws {
        // Step 1: Add favorite (tap star on any conversion)
        app.buttons["weightTab"].tap()

        // Ensure we start without a favorite
        let starFillButton = app.buttons["starFillButton"]
        if starFillButton.exists {
            starFillButton.tap()
            sleep(1)
        }

        // Now add the favorite
        app.buttons["starButton"].tap()
        sleep(1)

        // Step 2: Terminate app
        app.terminate()

        // Step 3: Launch app again
        app.launch()

        // Step 4: Navigate to Favorites → verify cells.count > 0
        app.buttons["favoritesTab"].tap()

        let cells = app.cells
        XCTAssertGreaterThan(cells.count, 0, "Favorites should persist across app relaunch")

        // Step 5: Cleanup - Delete the favorite
        let firstCell = cells.firstMatch
        firstCell.swipeLeft()
        app.buttons["Delete"].tap()
        sleep(1)

        // Verify cleanup succeeded
        XCTAssertTrue(app.otherElements["noFavoritesView"].exists, "Should show 'No Favorites' after cleanup")
    }
}
