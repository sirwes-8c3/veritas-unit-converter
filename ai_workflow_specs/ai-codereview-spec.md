# AI Code Review Specification

**Target Branch:** `impl/{{SPEC_NAME}}`
**Base Branch:** `main`

## Phase 1: Context Gathering

1. **Initialize Environment**:
* Ensure you have the latest code: 
```bash
git fetch origin
```
* Identify the changes by comparing the feature branch to main:
```bash
git diff main..impl/{{SPEC_NAME}}
```

2. **Review the Source Material**:
* Read the architectural overview: `specs/01-overview.md`.
* Read the specific feature requirement: `specs/{{SPEC_NAME}}.md`.


## Phase 2: Core Review Categories

### 1. Architectural Alignment

* Does the code follow the design patterns (MVVM, Composable Architecture, etc.) defined in `specs/01-overview.md`?.
* Are the SwiftData models correctly placed and following the relationships defined in `specs/models-001.md`?.

### 2. iOS Best Practices & Performance

* **Memory Management**: Check for strong reference cycles (especially in closures/escaping blocks). Use `[weak self]` where appropriate.
* **Concurrency**: Ensure UI updates are on the `@MainActor`
* **SwiftUI**: Check for unnecessary view redraws or heavy logic inside the `body` property.

### 3. Safety & Edge Cases

* Are optionals handled safely? (Avoid `!`)
* Does the error handling match the strategy defined in specs/*?.
* Are there empty states for the UI if data is missing?.

## Phase 3: Feedback Loop

1. **Categorize Issues**:
* **[BLOCKER]**: Issues that will cause crashes, data loss, or violate the core spec.
* **[WARN]**: Architectural deviations or code smell (e.g., "This function is too long").
* **[INFO]**: Minor style suggestions or "nice-to-haves."


2. **Provide Actionable Fixes**:
* For every **[BLOCKER]** or **[WARN]**, provide a specific code snippet or a clear instruction for Claude to follow in the next iteration.

3. Output Feedback
* Write feedback to `notes/{{SPEC_NAME}}-CR-YYYYMMDD-HHMM.md` where YYYY is the current year, MM is the current month in numerical format, DD is the current day in numerical format, HH is the current hour in the user's time zone and MM is current minute in the user's time zone.
