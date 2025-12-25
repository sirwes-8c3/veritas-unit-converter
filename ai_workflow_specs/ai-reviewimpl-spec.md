
# Review Response Protocol for Claude

**Context:** A Senior Engineer has provided feedback on the implementation of `specs/{{SPEC_NAME}}.md`.

## Instructions for Claude

When processing the review feedback from Gemini in file `notes/{{FEEDBACK_SPEC}}.md`, follow these steps:

### Phase 1. Categorization & Priority

* **Address [BLOCKER] items first**: Do not move to [WARN] or [INFO] until the blockers are resolved.
* **Validate against Specs**: If a review suggestion contradicts `specs/01-overview.md` or `specs/{{SPEC_NAME}}.md`, flag this contradiction immediately before making changes.

### Phase 2. Implementation Loop

1. **Apply the fix**: Modify the code as requested.
2. **Self-verify**:
* Does the fix solve the reported issue (e.g., memory leak or logic error)?
* Does the code still build?  Use the build command in CLAUDE.md

3. **If build succeeds:** Proceed to Phase 4
4. **If build fails:**
   - Read the build output carefully
   - Identify the root cause of each error
   - Plan the fix (update todo list if needed)
   - Implement the fix
   - Return to step 2


### Phase 3. **Regression Check** **IGNORE**
5. **Unit Test** Run unit tests to ensure the fix didn't break existing features.  Use the unit test command in CLAUDE.md

6. **If all tests pass:** Proceed to Phase 4
7. **If tests fail:**
    - Read the test output carefully
    - Identify which tests failed and why
    - Determine if it's a test bug or implementation bug
    - Plan the fix (update todo list if needed)
    - Implement the fix
    - Return to step 5



### Phase 4. Reporting the Resolution

For each feedback item, respond in the following format in your implementation notes:

* **Feedback**: [Summary of Gemini's point]
* **Action Taken**: [What you changed]
* **Verification**: [Build/Test status]
* **Remaining Debt**: [If the fix introduced a new minor issue]

Write the implementation notes to `notes/{{SPEC_NAME}}-CR-IMPL-YYYYMMDD-HHMM.md` where YYYY is the current year, MM is the current month in numerical format, DD is the current day in numerical format, HH is the current hour in the user's time zone and MM is current minute in the user's time zone.
