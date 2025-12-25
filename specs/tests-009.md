# Task: Write Unit Tests

**Task ID:** tests-009
**Dependencies:** cleanup-008
**Estimated Scope:** Medium

---

## Objective

Create comprehensive unit tests for the service layer (ConversionService, ConversionDataLoader, FavoritesManager).

---

## Test Files to Create

### 1. ConversionServiceTests

**Test Pattern**: Create Unit instances with specific coefficients, call `ConversionService.convert()`, assert result with 0.0001 accuracy

#### Weight Conversion Tests
| Test Method | Input | From | To | Expected |
|-------------|-------|------|----|---------|
| testGramToOunce | 100 | gram (toBase: 1.0) | ounce (toBase: 28.3495) | 3.5274 |
| testOunceToGram | 1 | ounce (toBase: 28.3495) | gram (toBase: 1.0) | 28.3495 |

#### Length Conversion Tests
| Test Method | Input | From | To | Expected |
|-------------|-------|------|----|---------|
| testCentimeterToInch | 100 | cm (toBase: 1.0) | inch (toBase: 2.54) | 39.3701 |
| testInchToCentimeter | 1 | inch (toBase: 2.54) | cm (toBase: 1.0) | 2.54 |

#### Temperature Conversion Tests (Critical)
| Test Method | Input | From | To | Expected |
|-------------|-------|------|----|---------|
| testCelsiusToFahrenheit_Freezing | 0 | celsius | fahrenheit | 32.0 |
| testCelsiusToFahrenheit_Boiling | 100 | celsius | fahrenheit | 212.0 |
| testFahrenheitToCelsius_Freezing | 32 | fahrenheit | celsius | 0.0 |
| testFahrenheitToCelsius_Boiling | 212 | fahrenheit | celsius | 100.0 |

**Note**: Use actual temperature coefficients from conversions.json

#### Volume Conversion Tests
| Test Method | Input | From | To | Expected |
|-------------|-------|------|----|---------|
| testMilliliterToFluidOunce | 100 | mL (toBase: 1.0) | fl oz (toBase: 29.5735) | 3.3814 |
| testFluidOunceToMilliliter | 1 | fl oz (toBase: 29.5735) | mL (toBase: 1.0) | 29.5735 |

#### Edge Case Tests
- **testSameUnitConversion**: Convert 100g to gram → expect 100.0
- **testFormatValue**: Format 3.527396195 → expect "3.5274"
- **testFormatWholeNumber**: Format 100.0 → expect "100"

### 2. ConversionDataLoaderTests

**Test Pattern**: Load data via ConversionDataLoader, assert counts and IDs

| Test Method | Assertion |
|-------------|-----------|
| testLoadConversions | `data.categories.count == 4` |
| testLoadWeightCategory | Count = 2, contains "gram" and "ounce" |
| testLoadLengthCategory | Count = 2, contains "centimeter" and "inch" |
| testLoadTemperatureCategory | Count = 2, contains "celsius" and "fahrenheit" |
| testLoadVolumeCategory | Count = 2, contains "milliliter" and "fluidounce" |
| testFavoritesCategoryReturnsEmpty | `units.isEmpty == true` |

### 3. FavoritesManagerTests

**Setup/Teardown**: Clear UserDefaults key "favoriteConversions" before/after each test

| Test Method | Scenario | Assertion |
|-------------|----------|-----------|
| testInitiallyEmpty | New manager | `favorites.isEmpty == true` |
| testAddFavorite | Add weight/gram→ounce | `count == 1`, `categoryId == "weight"` |
| testRemoveFavorite | Add then remove | `favorites.isEmpty == true` |
| testIsFavorite | Check existence | Returns true for added, false for others |
| testNoDuplicates | Add same favorite twice | `count == 1` |
| testPersistence | Create new manager instance | Favorites loaded from UserDefaults |

---

## Test Execution

```bash
# Run all unit tests
xcodebuild test -project VeritasUnitConverter.xcodeproj \
  -scheme VeritasUnitConverter \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

---

## Acceptance Criteria

- [ ] All conversion formulas tested with known values
- [ ] Temperature special cases covered (freezing, boiling points)
- [ ] JSON loading tested for all categories
- [ ] FavoritesManager CRUD operations tested
- [ ] Persistence tested across instances
- [ ] Edge cases covered (same unit, empty favorites)
- [ ] All tests pass

---

## Notes

- Tests use @testable import to access internal members
- FavoritesManagerTests clean UserDefaults between runs
- Accuracy of 0.0001 used for floating point comparisons
