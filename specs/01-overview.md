# Veritas Converter v0.1 - Implementation Overview

## Executive Summary

Build a modular iOS unit converter app with 4 conversion categories (Weight, Length, Temperature, Volume) plus a user-managed Favorites category. The app uses a tabbed interface with bidirectional conversion capability.

---

## Current State Analysis

**Existing Infrastructure:**
- Xcode project with SwiftUI + SwiftData template
- Basic ContentView (NavigationSplitView - needs replacement)
- Item.swift model (placeholder - will be replaced)
- Empty test templates
- AI workflow specs in place

**Gap to v0.1:**
- No conversion logic or models
- No tabbed UI structure
- No picker-based input views
- No JSON configuration
- No @AppStorage integration (currently using SwiftData)

---

## Architecture Decisions

### 1. Data Architecture

**Decision: Hybrid Approach**
- **Conversion Definitions**: JSON file bundled with app (static reference data)
- **User Preferences**: @AppStorage (favorites, last-used settings)
- **Remove SwiftData**: Not needed for v0.1 (simplifies architecture)

**Rationale**: JSON provides easy modification of conversion definitions without code changes. @AppStorage is lightweight for simple user preferences. SwiftData adds complexity we don't need yet.

### 2. Model Structure

```
Models/
├── ConversionCategory.swift    # Enum: weight, length, temperature, volume, favorites
├── Unit.swift                  # Represents a unit (name, symbol, baseMultiplier)
├── Conversion.swift            # Defines a unit-to-unit conversion relationship
├── ConversionResult.swift      # Result of a conversion calculation
└── FavoriteConversion.swift    # User's favorite conversion reference
```

**Key Design:**
- Units store `toBase` multiplier and `toBaseOffset` for affine conversions
- All conversions use the same affine formula:
  - To base: `base = value × toBase + toBaseOffset`
  - From base: `result = (base - toBaseOffset) / toBase`
- Temperature uses Kelvin as base with proper affine coefficients (no special code needed)

### 3. View Architecture

```
Views/
├── MainTabView.swift           # Root TabView container
├── ConversionView.swift        # Reusable conversion interface (left/right pickers + inputs)
├── CategoryTabContent.swift    # Wrapper that loads category-specific conversions
├── UnitPickerView.swift        # Picker component for unit selection
└── InputFieldView.swift        # Decimal input field with focus handling
```

**Key Design:**
- `ConversionView` is fully reusable across all categories
- Category tabs inject different conversion sets into the same view
- Favorites tab shows user-selected conversions from any category

### 4. Business Logic Layer

```
Services/
├── ConversionService.swift     # Core conversion calculations
├── ConversionDataLoader.swift  # JSON parsing and data loading
└── FavoritesManager.swift      # @AppStorage wrapper for favorites
```

### 5. Data Storage

**JSON Schema (conversions.json):**
```json
{
  "categories": [
    {
      "id": "weight",
      "name": "Weight",
      "units": [
        { "id": "gram", "name": "Gram", "symbol": "g", "toBase": 1.0, "toBaseOffset": 0 },
        { "id": "ounce", "name": "Ounce", "symbol": "oz", "toBase": 28.3495, "toBaseOffset": 0 }
      ]
    },
    {
      "id": "temperature",
      "name": "Temperature",
      "units": [
        { "id": "celsius", "name": "Celsius", "symbol": "°C", "toBase": 1.0, "toBaseOffset": 273.15 },
        { "id": "fahrenheit", "name": "Fahrenheit", "symbol": "°F", "toBase": 0.5556, "toBaseOffset": 255.37 }
      ]
    }
  ]
}
```

**@AppStorage Keys:**
- `favoriteConversions`: Array of conversion IDs
- `lastCategory`: Last viewed category tab
- `[category]_leftUnit`: Last selected left unit per category
- `[category]_rightUnit`: Last selected right unit per category

---

## Conversion Formulas

All conversions use a unified **affine formula**:
- To base: `base = value × toBase + toBaseOffset`
- From base: `result = (base - toBaseOffset) / toBase`

### Linear Conversions (toBaseOffset = 0)
| Category | From | To | Formula |
|----------|------|----|---------|
| Weight | Gram | Ounce | g / 28.3495 |
| Weight | Ounce | Gram | oz * 28.3495 |
| Length | Centimeter | Inch | cm / 2.54 |
| Length | Inch | Centimeter | in * 2.54 |
| Volume | Milliliter | Fluid Ounce | mL / 29.5735 |
| Volume | Fluid Ounce | Milliliter | fl oz * 29.5735 |

### Affine Conversions (using Kelvin as base)
| Category | From | To | Via Base (Kelvin) |
|----------|------|----|-------------------|
| Temperature | Celsius | Fahrenheit | C → K (C + 273.15) → F ((K - 255.37) / 0.5556) |
| Temperature | Fahrenheit | Celsius | F → K (F × 0.5556 + 255.37) → C (K - 273.15) |

---

## Testing Strategy

### Unit Tests (VeritasUnitConverterTests)
1. **ConversionServiceTests**: Test all conversion calculations with known values
2. **ConversionDataLoaderTests**: Test JSON parsing, error handling
3. **FavoritesManagerTests**: Test add/remove/persistence of favorites

### UI Tests (VeritasUnitConverterUITests)
1. **TabNavigationTests**: Verify all tabs accessible
2. **ConversionFlowTests**: Input value, verify output updates
3. **FocusBehaviorTests**: Verify field clearing on focus change
4. **FavoritesTests**: Add/remove favorites, verify persistence

---

## File Structure (Final)

```
VeritasUnitConverter/
├── VeritasUnitConverterApp.swift     (modified - remove SwiftData)
├── Resources/
│   └── conversions.json              (new)
├── Models/
│   ├── ConversionCategory.swift      (new)
│   ├── Unit.swift                    (new)
│   ├── Conversion.swift              (new)
│   └── FavoriteConversion.swift      (new)
├── Services/
│   ├── ConversionService.swift       (new)
│   ├── ConversionDataLoader.swift    (new)
│   └── FavoritesManager.swift        (new)
├── Views/
│   ├── MainTabView.swift             (new)
│   ├── ConversionView.swift          (new)
│   ├── CategoryTabContent.swift      (new)
│   ├── UnitPickerView.swift          (new)
│   └── InputFieldView.swift          (new)
├── ContentView.swift                 (replaced - redirects to MainTabView)
└── Item.swift                        (deleted)
```

---

## Implementation Order

Tasks are designed to be completed in sequence, with each building on the previous:

1. **models-001**: Create data models (Unit, Conversion, Category)
2. **json-002**: Create conversions.json with all category data
3. **services-003**: Build ConversionService with calculation logic
4. **loader-004**: Build JSON loader service
5. **views-005**: Create reusable ConversionView component
6. **tabs-006**: Create MainTabView with category tabs
7. **favorites-007**: Implement favorites with @AppStorage
8. **cleanup-008**: Remove SwiftData, update app entry point
9. **tests-009**: Write unit tests for services
10. **uitests-010**: Write UI tests for user flows

---

## Risk Mitigation

| Risk | Mitigation |
|------|------------|
| Temperature conversion is non-linear | Handled via affine formula with toBaseOffset (no special code) |
| Focus management complexity | Use @FocusState with clear state machine |
| JSON parsing errors | Comprehensive error handling + default fallback |
| @AppStorage array limitations | Store as JSON string, decode on read |

---

## Dependencies

- **None external**: All functionality uses native SwiftUI and Foundation
- iOS 17.0+ (per README requirement)
- Swift 6+ strict concurrency (use @MainActor where needed)

---

## Success Criteria

- [ ] All 4 conversion categories functional
- [ ] Bidirectional conversion works (left-to-right and right-to-left)
- [ ] Pickers show available units dynamically
- [ ] Favorites can be added/removed and persist across launches
- [ ] All unit tests pass
- [ ] All UI tests pass
- [ ] Clean build with no warnings
