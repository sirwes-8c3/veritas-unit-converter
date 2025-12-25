# Task: Cleanup and App Entry Point Update

**Task ID:** cleanup-008
**Dependencies:** favorites-007
**Estimated Scope:** Small

---

## Objective

Remove SwiftData scaffolding, update the app entry point, and ensure clean project structure.

---

## Files to Delete

### 1. `VeritasUnitConverter/Item.swift`
- SwiftData model placeholder - no longer needed

---

## Files to Modify

### 1. `VeritasUnitConverter/VeritasUnitConverterApp.swift`

* Remove template code for entrypoint and replace with appropriate entry point as defined in the other sepcs in specs/*

### 2. `VeritasUnitConverter/ContentView.swift`

* Delete ContentView.swift

---

## Xcode Project Changes

1. Remove `Item.swift` from project navigator
2. Remove `ContentView.swift` from project navigator 
3. Verify build succeeds without SwiftData references
4. Remove `import SwiftData` from any remaining files

---

## Verification Steps

```bash
# Build project
xcodebuild -project VeritasUnitConverter.xcodeproj -scheme VeritasUnitConverter -configuration Debug build

# Check for SwiftData references (should return empty)
grep -r "SwiftData" VeritasUnitConverter/
grep -r "ModelContainer" VeritasUnitConverter/
grep -r "@Model" VeritasUnitConverter/
```

---

## Acceptance Criteria

- [ ] Item.swift deleted
- [ ] ContentView.swift deleted or updated
- [ ] No SwiftData imports remain
- [ ] App launches with MainTabView as root
- [ ] FavoritesManager injected into environment
- [ ] Project builds without warnings
- [ ] No orphaned file references in Xcode

---

## Notes

- SwiftData was from Xcode template but not needed for v0.1
- @AppStorage / UserDefaults is sufficient for favorites
- Future versions could reintroduce SwiftData if needed
