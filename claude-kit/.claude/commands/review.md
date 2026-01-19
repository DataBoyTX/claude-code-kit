# Code Review

Review the current changes and provide feedback.

## Pre-computed Context

Current branch: `$( git branch --show-current )`
Changes from main: `$( git diff main...HEAD --stat )`
Files changed: `$( git diff main...HEAD --name-only )`
Diff preview (first 200 lines): `$( git diff main...HEAD | head -200 )`

## Review Checklist

Analyze the changes above against these criteria:

### 1. Correctness
- [ ] Does the code do what it's supposed to do?
- [ ] Are there any logic errors?
- [ ] Are edge cases handled?

### 2. Security
- [ ] No hardcoded secrets or credentials?
- [ ] Input validation present?
- [ ] No SQL injection, XSS, or other vulnerabilities?

### 3. Performance
- [ ] No unnecessary loops or redundant operations?
- [ ] Database queries optimized?
- [ ] No memory leaks?

### 4. Maintainability
- [ ] Code is readable and self-documenting?
- [ ] Functions are focused and not too long?
- [ ] No code duplication?

### 5. Testing
- [ ] Tests cover the changes?
- [ ] Tests are meaningful (not just for coverage)?
- [ ] Edge cases tested?

### 6. Documentation
- [ ] Public APIs documented?
- [ ] Complex logic explained?
- [ ] README updated if needed?

## Output Format

Provide feedback in this format:

### Summary
Brief overview of what changed and overall assessment.

### Issues Found
List any problems, categorized by severity:
- 🔴 **Critical:** Must fix before merge
- 🟡 **Warning:** Should fix, but not blocking
- 🔵 **Suggestion:** Nice to have improvements

### Good Practices Observed
Highlight things done well (reinforces good patterns).

### Suggested Improvements
Specific, actionable suggestions with code examples where helpful.
