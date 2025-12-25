# Task: Create JSON Data Loader

**Task ID:** loader-004
**Dependencies:** models-001, json-002
**Estimated Scope:** Small

---

## Objective

Create a service to load and parse the conversions.json file from the app bundle.

---

## Components to Create

### ConversionDataError (Error Type)

**Type**: `enum` conforming to `Error, LocalizedError`

**Cases**:
- `fileNotFound` → "conversions.json not found in app bundle"
- `decodingFailed(Error)` → "Failed to decode conversions.json: {error}"

### ConversionDataLoader (Static Struct)

**Public Interface**:

**loadConversions()**
```swift
static func loadConversions() throws -> ConversionsData
```
- Load "conversions.json" from `Bundle.main`
- Parse with `JSONDecoder`
- Throws: `ConversionDataError.fileNotFound` or `.decodingFailed(Error)`

**getCategoryData(for:)**
```swift
static func getCategoryData(for category: ConversionCategory) throws -> CategoryData?
```
- Load all conversions
- Find first category where `id == category.rawValue`
- Returns: CategoryData or nil if not found

**getUnits(for:)**
```swift
static func getUnits(for category: ConversionCategory) throws -> [Unit]
```
- Get category data
- Return its units array
- Returns: Empty array if category not found

---

## Usage Example

```swift
// Load all categories
let data = try ConversionDataLoader.loadConversions()

// Get units for weight category
let weightUnits = try ConversionDataLoader.getUnits(for: .weight)
// Returns: [Unit(id: "gram", ...), Unit(id: "ounce", ...)]
```

---

## Acceptance Criteria

- [ ] Successfully loads conversions.json from bundle
- [ ] Properly decodes into ConversionsData struct
- [ ] Throws descriptive errors on failure
- [ ] Can retrieve specific category data
- [ ] Can retrieve units for a category

---

## Error Handling

| Error Case | Behavior |
|------------|----------|
| File not found | Throw ConversionDataError.fileNotFound |
| Invalid JSON | Throw ConversionDataError.decodingFailed |
| Category not found | Return nil / empty array |

---

## Notes

- This service is synchronous (JSON file is small, bundled)
- Consider caching if called frequently (optimization for later)
- Static struct pattern matches ConversionService
