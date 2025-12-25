# Task: Create Main Tab View Structure

**Task ID:** tabs-006
**Dependencies:** views-005
**Estimated Scope:** Medium

---

## Objective

Create the main TabView container that organizes all conversion categories into separate tabs, plus the Favorites tab.

---

## Components to Create

### 1. CategoryTabContent

**Purpose**: Wrapper that loads units for a specific category and displays ConversionView

**State**:
- `let category: ConversionCategory` - The category to display
- `@State private var units: [Unit]` - Loaded units
- `@State private var loadError: String?` - Error message if loading fails

**View States**:
- Error: Show `ContentUnavailableView` with error icon and message
- Loading: Show `ProgressView` with "Loading..." text
- Success: Show `ConversionView(category:units:)`

**Data Loading**:
- Use `.task { }` modifier to load units on appear
- Load via `ConversionDataLoader.getUnits(for: category)`
- Catch errors and store in `loadError` state

**Navigation**:
- Set `.navigationTitle(category.displayName)`

### 2. MainTabView

**Purpose**: Root TabView container organizing all category tabs

**Tab Structure**:
- 4 standard conversion tabs (weight, length, temperature, volume)
- 1 favorites tab
- Each tab wrapped in `NavigationStack`

**Implementation Pattern**:
```swift
private let standardCategories: [ConversionCategory] = [.weight, .length, .temperature, .volume]

TabView(selection: $selectedTab) {
    ForEach(standardCategories) { category in
        NavigationStack {
            CategoryTabContent(category: category)
        }
        .tabItem { Label(category.displayName, systemImage: category.iconName) }
        .tag(category)
    }
    // Favorites tab separately (different content view)
}
```

**Tab Items**: Use `Label` with category's `displayName` and `iconName`

### 3. FavoritesTabContent (Placeholder)

**Initial Implementation** (replaced in favorites-007):
- Show `ContentUnavailableView` with "No Favorites" message
- Star icon and description text
- Set `.navigationTitle("Favorites")`

---

## Tab Structure

| Tab | Icon | Content |
|-----|------|---------|
| Weight | scalemass | WeightConversionView |
| Length | ruler | LengthConversionView |
| Temperature | thermometer | TemperatureConversionView |
| Volume | drop | VolumeConversionView |
| Favorites | star.fill | FavoritesTabContent |

---

## Acceptance Criteria

- [ ] All 5 tabs are visible at bottom of screen
- [ ] Each tab shows correct icon and label
- [ ] Tab selection persists during session
- [ ] Each category tab loads its units from JSON
- [ ] Navigation title matches category name
- [ ] Favorites tab shows placeholder (for now)
- [ ] Error state shown if JSON loading fails

---

## Notes

- Uses NavigationStack within each tab for proper navigation
- CategoryTabContent handles loading state
- Favorites implementation comes in next task
- Consider @AppStorage for persisting last selected tab (future enhancement)
