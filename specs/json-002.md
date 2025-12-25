# Task: Create Conversions JSON Data File

**Task ID:** json-002
**Dependencies:** models-001
**Estimated Scope:** Small

---

## Objective

Create the JSON configuration file containing all conversion categories and their units.

---

## Conversion Formula

All units are converted using an **affine formula**:

```
base = value × toBase + toBaseOffset
```

- **Linear conversions** (weight, length, volume): `toBaseOffset = 0` (can be omitted)
- **Affine conversions** (temperature): Uses both `toBase` and `toBaseOffset`

To convert between any two units:
1. Convert source value to base unit: `base = value × fromUnit.toBase + fromUnit.toBaseOffset`
2. Convert base to target unit: `result = (base - toUnit.toBaseOffset) / toUnit.toBase`

---

## Files to Create

### 1. `VeritasUnitConverter/Resources/conversions.json`

```json
{
  "categories": [
    {
      "id": "weight",
      "name": "Weight",
      "units": [
        {
          "id": "gram",
          "name": "Gram",
          "symbol": "g",
          "toBase": 1.0,
          "toBaseOffset": 0
        },
        {
          "id": "ounce",
          "name": "Ounce",
          "symbol": "oz",
          "toBase": 28.3495,
          "toBaseOffset": 0
        }
      ]
    },
    {
      "id": "length",
      "name": "Length",
      "units": [
        {
          "id": "centimeter",
          "name": "Centimeter",
          "symbol": "cm",
          "toBase": 1.0,
          "toBaseOffset": 0
        },
        {
          "id": "inch",
          "name": "Inch",
          "symbol": "in",
          "toBase": 2.54,
          "toBaseOffset": 0
        }
      ]
    },
    {
      "id": "temperature",
      "name": "Temperature",
      "units": [
        {
          "id": "celsius",
          "name": "Celsius",
          "symbol": "°C",
          "toBase": 1.0,
          "toBaseOffset": 273.15
        },
        {
          "id": "fahrenheit",
          "name": "Fahrenheit",
          "symbol": "°F",
          "toBase": 0.5555555556,
          "toBaseOffset": 255.3722222222
        }
      ]
    },
    {
      "id": "volume",
      "name": "Volume",
      "units": [
        {
          "id": "milliliter",
          "name": "Milliliter",
          "symbol": "mL",
          "toBase": 1.0,
          "toBaseOffset": 0
        },
        {
          "id": "fluidounce",
          "name": "Fluid Ounce",
          "symbol": "fl oz",
          "toBase": 29.5735,
          "toBaseOffset": 0
        }
      ]
    }
  ]
}
```

---

## Integration Steps

1. Create `Resources` folder in Xcode project
2. Add `conversions.json` to the folder
3. Ensure file is included in app target (Copy Bundle Resources)

---

## Conversion Reference

| Category | Base Unit | Other Units | Conversion Type |
|----------|-----------|-------------|-----------------|
| Weight | Gram | Ounce (28.3495g per oz) | Linear |
| Length | Centimeter | Inch (2.54cm per in) | Linear |
| Temperature | Kelvin | Celsius (K = C + 273.15), Fahrenheit (K = F × 5/9 + 255.37) | Affine |
| Volume | Milliliter | Fluid Ounce (29.5735mL per fl oz) | Linear |

### Temperature Conversion Verification

| From | To | Input | Expected Output |
|------|-----|-------|-----------------|
| Celsius | Fahrenheit | 0°C | 32°F |
| Celsius | Fahrenheit | 100°C | 212°F |
| Fahrenheit | Celsius | 32°F | 0°C |
| Fahrenheit | Celsius | 212°F | 100°C |

---

## Acceptance Criteria

- [ ] JSON file is valid and parseable
- [ ] All 4 categories are defined
- [ ] Each category has exactly 2 units (for v0.1)
- [ ] File is included in Xcode project bundle
- [ ] Can be loaded at runtime via Bundle.main

---

## Notes

- All conversions use the affine formula: `base = value × toBase + toBaseOffset`
- For linear conversions, `toBaseOffset` is 0 (can be omitted in Swift with default value)
- Temperature uses Kelvin as the base unit with proper affine coefficients
- `toBase` represents how many of the base unit equal 1 of this unit (for linear conversions)
- Example: 1 oz = 28.3495 g, so ounce.toBase = 28.3495, toBaseOffset = 0
