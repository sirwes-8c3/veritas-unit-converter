# Spec Implementation Workflow

You are implementing a feature from a specification. Follow this exact workflow, completing each step before moving to the next.

## Phase 1: Understanding
1. **Read the spec** at `specs/{{SPEC_NAME}}.md` thoroughly
2. Create a todo list breaking down the implementation spec into discrete tasks
3. Note any ambiguities or questions - ask before proceeding if critical

## Phase 1.5: Git Setup
4. **Create an implementation branch**:
   - Ensure you are on the main branch first
   - Ensure working directory is clean before branching (`git status`)
   - If uncommitted changes exist, notify the user and exit; ignore the rest of the instructions
   - Pull latest changes from remote
   ```bash
   git checkout main
   git pull origin main
   git checkout -b impl/{{SPEC_NAME}}
   ```

## Phase 2: Implementation
5. Implement the spec according to the todo list
6. Mark tasks complete as you finish each one

## Phase 3: Build Loop
7. Build the project: Use the build command in @CLAUDE.md
8. **If build succeeds:** Proceed to Phase 4. 
9. **If build fails:**
   - Read the build output carefully
   - Identify the root cause of each error
   - Plan the fix (update todo list if needed)
   - Implement the fix
   - Return to step 7

## Phase 4: Test Loop. 
10. Run unit tests: Use the unit test build command @CLAUDE.md
11. **If all tests pass:** Proceed to Phase 5
12. **If tests fail:**
    - Read the test output carefully
    - Identify which tests failed and why
    - Determine if it's a test bug or implementation bug
    - Plan the fix (update todo list if needed)
    - Implement the fix
    - Return to step 10

## Phase 5: Completion
13. Summarize what was implemented
14. Note any deviations from the spec and why
15. List any follow-up items or technical debt
16. Write to file into `notes/{{SPEC_NAME}}_implementation.md`
17. **Commit and push changes**:
    ```bash
    git add .
    git commit -m "Implement {{SPEC_NAME}}: <brief summary>"
    git push -u origin impl/{{SPEC_NAME}}
    ```
    - Commit message should summarize what was implemented
    - Reference any related issues if applicable

---

**IMPORTANT RULES:**
- Never skip the build step after making changes
- Never assume a fix worked without re-running build/tests
- Maximum 5 iterations per loop before asking for help
- Keep the todo list updated throughout
