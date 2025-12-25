# Task: Write UI Tests

**Task ID:** uitests-010
**Dependencies:** tests-009
**Estimated Scope:** Medium

---

## Objective

Create UI tests that verify user-facing functionality including tab navigation, conversion flows, and favorites management.

---

## UI Test Scenarios

### Test Setup
```swift
var app: XCUIApplication!
continueAfterFailure = false
app.launch()
```

### Tab Navigation Tests

#### testAllTabsExist
**Verify**: All 5 tab buttons exist in tab bar
- Weight, Length, Temperature, Volume, Favorites

#### testTabNavigation
**Flow**: Tap each tab and verify navigation bar title changes
| Step | Action | Expected |
|------|--------|----------|
| 1 | Launch app | Navigation bar shows "Weight" |
| 2 | Tap "Length" tab | Navigation bar shows "Length" |
| 3 | Tap "Temperature" tab | Navigation bar shows "Temperature" |
| 4 | Tap "Volume" tab | Navigation bar shows "Volume" |
| 5 | Tap "Favorites" tab | Navigation bar shows "Favorites" |

### Conversion Flow Tests

#### testWeightConversion
**Flow**: Enter value, convert, verify output
1. Navigate to Weight tab
2. Find text fields (expect at least 2)
3. Tap left field, type "100"
4. Tap "Convert" button in keyboard toolbar
5. Assert right field has non-empty, non-zero value

#### testTemperatureConversion
**Critical Test**: Verify affine formula works
1. Navigate to Temperature tab
2. Enter "100" in left field (Celsius)
3. Tap Convert
4. Assert right field contains "212" (Fahrenheit)

#### testBidirectionalConversion
**Flow**: Test conversion in both directions
| Step | Action | Expected |
|------|--------|----------|
| 1 | Navigate to Weight, enter 28.3495 in left | - |
| 2 | Tap Convert | Right field contains "1" |
| 3 | Tap right field | Left field clears |
| 4 | Enter "1" in right field | - |
| 5 | Tap Convert | Left field contains "28" |

### Focus Behavior Tests

#### testFocusClearsOppositeField
**Verify**: Focus changes clear opposite field
1. Navigate to Length tab
2. Enter "100" in left, convert → right has value
3. Tap right field
4. Type in right → left should be cleared (tests `onChange` behavior)

### Favorites Tests

#### testAddAndRemoveFavorite
**Flow**: Complete favorites lifecycle
| Step | Action | Expected |
|------|--------|----------|
| 1 | Navigate to Weight | - |
| 2 | Tap star button | Star icon changes to filled |
| 3 | Navigate to Favorites tab | List has at least 1 cell |
| 4 | Swipe left on first cell | Delete button appears |
| 5 | Tap Delete | "No Favorites" text appears |

**Element Queries**:
- Star button: `app.buttons["star"]` or `app.buttons["star.fill"]`
- Empty state: `app.staticTexts["No Favorites"]`
- List cells: `app.cells`

#### testFavoritePersistsAcrossRelaunch
**Verify**: UserDefaults persistence
1. Add favorite (tap star on any conversion)
2. `app.terminate()`
3. `app.launch()`
4. Navigate to Favorites → verify cells.count > 0
5. Cleanup: Delete the favorite

**Note**: This test must clean up after itself

---

## Test Execution

```bash
# Run UI tests on simulator
xcodebuild test -project VeritasUnitConverter.xcodeproj \
  -scheme VeritasUnitConverter \
  -destination 'platform=iOS Simulator,name=iPhone 12,OS=17.0' \
  -only-testing:VeritasUnitConverterUITests
```

---

## Acceptance Criteria

- [ ] All 5 tabs exist and navigable
- [ ] Navigation title updates per tab
- [ ] Conversion produces valid results
- [ ] Bidirectional conversion works
- [ ] Temperature shows correct values (100°C = 212°F)
- [ ] Focus changes clear opposite field
- [ ] Favorites can be added via star button
- [ ] Favorites appear in Favorites tab
- [ ] Favorites can be deleted via swipe
- [ ] Favorites persist across app relaunch

---

## Notes

- UI tests may need adjustment based on actual UI element identifiers
- Use `accessibilityIdentifier` if default identifiers don't work
- Consider adding accessibility identifiers to views for reliable testing
- Some tests may be flaky on slow simulators - add waits if needed
