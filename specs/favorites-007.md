# Task: Implement Favorites with @AppStorage

**Task ID:** favorites-007
**Dependencies:** tabs-006
**Estimated Scope:** Medium

---

## Objective

Implement the favorites functionality allowing users to save and manage their favorite conversions, persisted via @AppStorage.

---

## Components to Create/Modify

### 1. FavoritesManager (New Service)

**Purpose**: Manage favorite conversions with UserDefaults persistence

**Key Properties**:
- `@Observable` class (Swift 5.9+)
- `var favorites: [FavoriteConversion]` with `didSet` auto-save
- `private let storageKey = "favoriteConversions"`

**Public Interface**:
- `func addFavorite(categoryId: String, fromUnitId: String, toUnitId: String)`
  - Prevents duplicates before adding
- `func removeFavorite(_ favorite: FavoriteConversion)`
- `func isFavorite(categoryId: String, fromUnitId: String, toUnitId: String) -> Bool`

**Persistence Pattern**:
- Load: Decode `[FavoriteConversion]` from UserDefaults data
- Save: Encode to JSON and store in UserDefaults
- Auto-save on `favorites` array changes via `didSet`

**Why UserDefaults**: @AppStorage doesn't cleanly support custom Codable arrays

### 2. ConversionView Updates

**Add Environment**:
```swift
@Environment(FavoritesManager.self) private var favoritesManager
```

**Add Computed Property**:
```swift
private var isFavorite: Bool {
    guard let left = leftUnit, let right = rightUnit else { return false }
    return favoritesManager.isFavorite(
        categoryId: category.rawValue,
        fromUnitId: left.id,
        toUnitId: right.id
    )
}
```

**Add Toolbar Star Button**:
- Placement: `.primaryAction`
- Icon: `"star"` vs `"star.fill"` based on `isFavorite`
- Action: Toggle favorite (add if not favorited, remove if favorited)

### 3. FavoritesTabContent Updates

**State**:
- `@Environment(FavoritesManager.self)` to access favorites
- `@State private var allCategories: [CategoryData]` for resolving unit names

**View Logic**:
- If `favorites.isEmpty`: Show `ContentUnavailableView` with "No Favorites" message
- Else: Show `List` with `FavoriteRow` for each favorite
- Support swipe-to-delete with `.onDelete`

**FavoriteRow Component**:
- Display format: Category name (caption) + "FromUnit → ToUnit" (body)
- NavigationLink to `ConversionView` with resolved category and units
- Resolve unit names from loaded category data

### 4. App Entry Point Update

**Inject FavoritesManager**:
```swift
@State private var favoritesManager = FavoritesManager()

var body: some Scene {
    WindowGroup {
        MainTabView()
            .environment(favoritesManager)
    }
}
```

---

## Acceptance Criteria

- [ ] Star button visible on all conversion views
- [ ] Tapping star toggles favorite state
- [ ] Star fills when conversion is favorited
- [ ] Favorites persist across app launches
- [ ] Favorites tab shows list of saved conversions
- [ ] Can delete favorites via swipe
- [ ] Tapping favorite navigates to that conversion
- [ ] Duplicate favorites prevented

---

## Notes

- Uses @Observable (Swift 5.9+) instead of ObservableObject
- UserDefaults used directly since @AppStorage doesn't support custom Codable arrays well
- FavoriteConversion stores IDs, resolved to display names at runtime
