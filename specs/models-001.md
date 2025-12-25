# Task: Create Data Models

**Task ID:** models-001
**Dependencies:** None
**Estimated Scope:** Small

---

## Objective

Create the core data models that represent units, conversions, and categories throughout the app.

---

## Data Models to Create

### 1. ConversionCategory

**Type**: `enum` with `String` raw values

**Conformances**: `Codable, CaseIterable, Identifiable`

**Cases**:
- weight, length, temperature, volume, favorites

**Computed Properties**:
- `var id: String` → Returns `rawValue`
- `var displayName: String` → Display names ("Weight", "Length", etc.)
- `var iconName: String` → SF Symbol names

**Icon Mapping**:
| Category | Icon |
|----------|------|
| weight | scalemass |
| length | ruler |
| temperature | thermometer |
| volume | drop |
| favorites | star.fill |

### 2. Unit

**Type**: `struct`

**Conformances**: `Codable, Identifiable, Hashable`

**Properties**:
```swift
let id: String
let name: String
let symbol: String
let toBase: Double       // Multiplier for affine conversion
let toBaseOffset: Double // Offset for affine conversion (0 for linear)
```

**Critical Decoder Behavior**:
```swift
toBaseOffset = try container.decodeIfPresent(Double.self, forKey: .toBaseOffset) ?? 0
```
Must default `toBaseOffset` to 0 if not present in JSON (backward compatibility with linear-only conversions)

**Initializer**: Provide memberwise init with `toBaseOffset: Double = 0` default parameter

### 3. CategoryData & ConversionsData

**CategoryData** (JSON container for category):
```swift
struct CategoryData: Codable, Identifiable {
    let id: String
    let name: String
    let units: [Unit]
    var category: ConversionCategory? { ConversionCategory(rawValue: id) }
}
```

**ConversionsData** (Root JSON structure):
```swift
struct ConversionsData: Codable {
    let categories: [CategoryData]
}
```

### 4. FavoriteConversion

**Type**: `struct`

**Conformances**: `Codable, Identifiable, Hashable`

**Properties**:
```swift
let id: UUID
let categoryId: String
let fromUnitId: String
let toUnitId: String
```

**Initializer**: Generate UUID automatically, accept categoryId, fromUnitId, toUnitId as parameters

---

## Acceptance Criteria

- [ ] All model files compile without errors
- [ ] ConversionCategory enum has all 5 cases
- [ ] Unit struct is Codable for JSON parsing
- [ ] CategoryData can hold array of units
- [ ] FavoriteConversion can store a reference to any conversion

---

## Notes

- Models should be pure data structures with no business logic
- All conversions (including temperature) use the same affine formula in ConversionService
- `toBaseOffset` defaults to 0 for backward compatibility with linear-only JSON
- All models implement Codable for JSON serialization
