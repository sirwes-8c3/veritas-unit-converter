# Task: Create Conversion Service

**Task ID:** services-003
**Dependencies:** models-001
**Estimated Scope:** Medium

---

## Objective

Create the core conversion calculation service that handles all unit-to-unit conversions, including special handling for temperature.

---

## Service Interface

### ConversionService (Static Struct)

**Core Conversion Method**:
```swift
static func convert(value: Double, from fromUnit: Unit, to toUnit: Unit) -> Double
```

**Critical: Unified Affine Formula**
All conversions (including temperature) use the same two-step formula:

```swift
// Step 1: Convert to base unit
let baseValue = value * fromUnit.toBase + fromUnit.toBaseOffset

// Step 2: Convert from base to target unit
let result = (baseValue - toUnit.toBaseOffset) / toUnit.toBase
```

**Edge Cases**:
- Same unit (fromUnit.id == toUnit.id): Return original value unchanged

**Formatting Method**:
```swift
static func format(value: Double, decimals: Int = 4) -> String
```
- Uses `NumberFormatter` with decimal style
- Default 4 decimal places, minimum 0 (hides trailing zeros)
- Enables grouping separator for readability

---

## Test Cases to Verify

| Input | From | To | Expected Output |
|-------|------|----|--------------------|
| 100 | gram | ounce | 3.5274 |
| 1 | ounce | gram | 28.3495 |
| 100 | cm | inch | 39.3701 |
| 1 | inch | cm | 2.54 |
| 0 | celsius | fahrenheit | 32 |
| 100 | celsius | fahrenheit | 212 |
| 32 | fahrenheit | celsius | 0 |
| 212 | fahrenheit | celsius | 100 |
| 100 | milliliter | fluidounce | 3.3814 |
| 1 | fluidounce | milliliter | 29.5735 |

---

## Acceptance Criteria

- [ ] All conversions work via affine formula (base = value × toBase + toBaseOffset)
- [ ] Temperature conversions produce correct results using same formula as linear
- [ ] Same-unit conversions return original value
- [ ] Formatting handles large and small numbers
- [ ] All test cases pass verification

---

## Notes

- ConversionService is a static struct (no instance needed)
- All methods are pure functions with no side effects
- All conversions (including temperature) use the same affine formula
- No special cases needed - conversion logic is fully data-driven via JSON
- The `category` parameter is no longer needed in the convert() method
