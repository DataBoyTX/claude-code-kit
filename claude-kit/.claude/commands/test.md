# Run and Analyze Tests

Run tests and provide analysis of results.

## Pre-computed Context

Test framework detected: `$( [ -f "jest.config.js" ] && echo "Jest" || ([ -f "vitest.config.ts" ] && echo "Vitest" || ([ -f "pytest.ini" ] && echo "Pytest" || echo "Unknown")) )`
Package manager: `$( [ -f "pnpm-lock.yaml" ] && echo "pnpm" || ([ -f "yarn.lock" ] && echo "yarn" || echo "npm") )`
Test script: `$( cat package.json 2>/dev/null | grep -A5 '"scripts"' | grep test || echo "Not found" )`
Changed files: `$( git diff --name-only HEAD~1 2>/dev/null || echo "No recent changes" )`

## Instructions

1. **Run the test suite** using the appropriate command:
   - npm: `npm test`
   - yarn: `yarn test`
   - pnpm: `pnpm test`
   - Or run specific tests if a file path is provided

2. **Analyze the output**:
   - Count passing/failing tests
   - Identify which tests failed
   - Look for patterns in failures

3. **If tests fail**, investigate:
   - Read the test file to understand what it's testing
   - Check the implementation being tested
   - Identify the root cause

4. **Provide a summary**:
   - Overall test status (pass/fail)
   - Number of tests: passed, failed, skipped
   - If failures: specific failures with analysis
   - Suggested fixes for any failures

## Arguments

- No arguments: Run full test suite
- File path: Run tests for specific file
- `--coverage`: Run with coverage report
- `--watch`: Run in watch mode

## Output Format

```
## Test Results

✅ **Status:** [PASS/FAIL]
📊 **Summary:** X passed, Y failed, Z skipped

### Failures (if any)
1. `test name` in `file.test.ts`
   - **Expected:** ...
   - **Received:** ...
   - **Likely cause:** ...
   - **Suggested fix:** ...

### Coverage (if requested)
- Statements: X%
- Branches: X%
- Functions: X%
- Lines: X%
```
