# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Veritas Converter is an iOS unit converter app built with SwiftUI and Swift 6+, targeting iOS 17.0+. The app provides bidirectional conversions across 4 categories (Weight, Length, Temperature, Volume) plus a user-managed Favorites category.

## Build and Test Commands

```bash
# Build the project
xcodebuild -project VeritasUnitConverter.xcodeproj \
  -scheme VeritasUnitConverter \
  -configuration Debug build

# Run all tests
xcodebuild test -project VeritasUnitConverter.xcodeproj \
  -scheme VeritasUnitConverter \
  -destination 'platform=iOS Simulator,name=iPhone 12,OS=17.0'

# Run only unit tests
xcodebuild test -project VeritasUnitConverter.xcodeproj \
  -scheme VeritasUnitConverter \
  -destination 'platform=iOS Simulator,name=iPhone 12,OS=17.0' \
  -only-testing:VeritasUnitConverterTests

# Run only UI tests
xcodebuild test -project VeritasUnitConverter.xcodeproj \
  -scheme VeritasUnitConverter \
  -destination 'platform=iOS Simulator,name=iPhone 12,OS=17.0' \
  -only-testing:VeritasUnitConverterUITests

# Run a single test class
xcodebuild test -project VeritasUnitConverter.xcodeproj \
  -scheme VeritasUnitConverter \
  -destination 'platform=iOS Simulator,name=iPhone 12,OS=17.0' \
  -only-testing:VeritasUnitConverterTests/ConversionServiceTests

# Run a specific test method
xcodebuild test -project VeritasUnitConverter.xcodeproj \
  -scheme VeritasUnitConverter \
  -destination 'platform=iOS Simulator,name=iPhone 12,OS=17.0' \
  -only-testing:VeritasUnitConverterTests/ConversionServiceTests/testCelsiusToFahrenheit_Freezing
```

## Architecture

### Data Flow
1. **Conversion Definitions**: Stored in `Resources/conversions.json` (bundled with app)
2. **User Preferences**: Stored via @AppStorage/UserDefaults (favorites, last-used settings)
3. **Current State**: SwiftData template scaffolding (Item.swift, ContentView.swift) will be removed in cleanup-008

### Unified Conversion Formula

**Critical**: All conversions use a single affine formula—there is NO special-case code for temperature:

```
To base:   base = value × toBase + toBaseOffset
From base: result = (base - toBaseOffset) / toBase
```

- **Linear conversions** (weight, length, volume): `toBaseOffset = 0`
- **Affine conversions** (temperature): Uses Kelvin as base with both `toBase` and `toBaseOffset`

Example temperature coefficients:
- Celsius: `toBase = 1.0, toBaseOffset = 273.15` (K = C + 273.15)
- Fahrenheit: `toBase = 0.5555555556, toBaseOffset = 255.3722222222` (K = F × 5/9 + 255.37)

This design eliminates the need for category-specific conversion logic.

### Planned Architecture (per specs/)

```
Models/
├── ConversionCategory.swift    # Enum: weight, length, temperature, volume, favorites
├── Unit.swift                  # Represents a unit (id, name, symbol, toBase, toBaseOffset)
├── CategoryData.swift          # Container for JSON category data
└── FavoriteConversion.swift    # User's favorite conversion reference

Services/
├── ConversionService.swift       # Core affine conversion calculations (static methods)
├── ConversionDataLoader.swift    # JSON parsing and data loading
└── FavoritesManager.swift        # @Observable class wrapping UserDefaults

Views/
├── MainTabView.swift             # Root TabView container
├── ConversionView.swift          # Reusable conversion interface (both directions)
├── CategoryTabContent.swift      # Wrapper that loads category-specific data
├── UnitPickerView.swift          # Picker component for unit selection
├── InputFieldView.swift          # Decimal input field with focus handling
└── FavoritesTabContent.swift    # Favorites list view

Resources/
└── conversions.json              # All conversion definitions
```

### View Hierarchy

```
MainTabView (root)
├── NavigationStack (per tab)
│   └── CategoryTabContent
│       └── ConversionView (reusable for all categories)
│           ├── Left side: UnitPickerView + TextField
│           └── Right side: UnitPickerView + TextField
└── NavigationStack (favorites tab)
    └── FavoritesTabContent
        └── List of FavoriteRow (NavigationLink to ConversionView)
```

### State Management

- **@FocusState**: Manages keyboard focus and field clearing behavior
  - When left field gets focus → right value clears
  - When right field gets focus → left value clears
- **@Observable FavoritesManager**: Persists to UserDefaults as JSON-encoded array
- **@State**: Local component state (selected units, input values)

## Implementation Order

The `specs/` directory contains 10 sequential tasks (models-001 through uitests-010). Each builds on the previous:

1. **models-001**: Data models (Unit, ConversionCategory, CategoryData, FavoriteConversion)
2. **json-002**: conversions.json with affine coefficients
3. **services-003**: ConversionService with unified affine formula
4. **loader-004**: ConversionDataLoader for JSON parsing
5. **views-005**: ConversionView, UnitPickerView, InputFieldView
6. **tabs-006**: MainTabView, CategoryTabContent, FavoritesTabContent (placeholder)
7. **favorites-007**: FavoritesManager + star toggle + full FavoritesTabContent
8. **cleanup-008**: Remove SwiftData (Item.swift, update App.swift)
9. **tests-009**: Unit tests (ConversionServiceTests, ConversionDataLoaderTests, FavoritesManagerTests)
10. **uitests-010**: UI tests (navigation, conversions, focus behavior, favorites persistence)

**See `specs/01-overview.md` for full architecture documentation.**

## Key Design Patterns

### Reusable Views
`ConversionView` is category-agnostic—tabs inject different unit arrays but the view logic is identical.

### Focus Behavior
The bidirectional conversion requires careful focus management:
- Decimal pad keyboard lacks return key → use toolbar "Convert" button
- `onChange(of: leftFocused)` and `onChange(of: rightFocused)` clear opposite field
- Toolbar button triggers conversion based on which field has focus

### Favorites Storage
`FavoritesManager` stores `[FavoriteConversion]` as JSON in UserDefaults because @AppStorage doesn't handle custom Codable arrays cleanly. The manager uses Swift's `@Observable` macro (Swift 5.9+).

### No External Dependencies
All functionality uses native SwiftUI and Foundation. No third-party packages.

## Temperature Conversion Verification

Test these values to verify the affine formula is correct:
- 0°C → 32°F
- 100°C → 212°F
- 32°F → 0°C
- 212°F → 100°C

If these fail, check the `toBase` and `toBaseOffset` values in conversions.json.

## Current Project State

**As of initial commit**: Xcode SwiftUI + SwiftData template with placeholder Item model and ContentView. These will be replaced during implementation.
