# Task: Create Reusable ConversionView Component

**Task ID:** views-005
**Dependencies:** models-001, services-003, loader-004
**Estimated Scope:** Large

---

## Objective

Create the main conversion view component that handles bidirectional conversion with pickers and input fields. This is the core UI component reused across all category tabs.

---

## Component Architecture

### 1. InputFieldView
**Purpose**: TextField configured for decimal input with focus binding

**Interface**:
- `@Binding var value: String` - The input value
- `@FocusState.Binding var isFocused: Bool` - Focus state binding
- `let placeholder: String` - Placeholder text
- `let onSubmit: () -> Void` - Submit handler

**Key Requirements**:
- Use `.keyboardType(.decimalPad)` for numeric-only input
- Bind to `@FocusState` for focus management
- Center-aligned text with `.title2` font

### 2. UnitPickerView
**Purpose**: Menu picker for unit selection

**Interface**:
- `@Binding var selectedUnit: Unit?` - Selected unit
- `let units: [Unit]` - Available units
- `let label: String` - Picker label

**Display Format**: Show both name and symbol (e.g., "Gram (g)")

### 3. ConversionView
**Purpose**: Main bidirectional conversion interface

**State Management**:
```swift
@State private var leftValue: String = ""
@State private var rightValue: String = ""
@State private var leftUnit: Unit?
@State private var rightUnit: Unit?
@FocusState private var leftFocused: Bool
@FocusState private var rightFocused: Bool
```

**Critical Focus Behavior**:
```swift
.onChange(of: leftFocused) { _, isFocused in
    if isFocused { rightValue = "" }
}
.onChange(of: rightFocused) { _, isFocused in
    if isFocused { leftValue = "" }
}
```

**Layout Structure**:
- HStack with two sides (left and right)
- Each side: UnitPickerView above TextField
- Arrow icon between sides
- Toolbar "Convert" button above keyboard

**Conversion Methods**:
- `convertLeftToRight()`: Convert left value → right display
- `convertRightToLeft()`: Convert right value → left display
- Both use `ConversionService.convert()` and `ConversionService.format()`
- Guard against nil units and invalid Double parsing

**Initialization**:
- Auto-select first unit for left, last unit for right on appear

---

## Behavior Specification

### Focus Management
| Action | Result |
|--------|--------|
| Tap left field | Left gets focus, right value clears |
| Tap right field | Right gets focus, left value clears |
| Press keyboard "Convert" | Perform conversion, dismiss keyboard |

### Conversion Flow
| Input Side | Action | Result |
|------------|--------|--------|
| Left | Enter value + Convert | Right field shows converted result |
| Right | Enter value + Convert | Left field shows converted result |

---

## Acceptance Criteria

- [ ] Pickers display all available units for category
- [ ] Left input clears right value when focused
- [ ] Right input clears left value when focused
- [ ] Convert button appears above keyboard
- [ ] Conversion calculates correctly in both directions
- [ ] Results formatted with appropriate decimal places
- [ ] Initial units are auto-selected (first and last)

---

## Notes

- Uses @FocusState for keyboard/focus management
- Toolbar button provides "Convert" action since decimalPad has no return key
- View is fully reusable - just pass different category and units
