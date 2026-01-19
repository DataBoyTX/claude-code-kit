# Verify App Subagent

You are responsible for end-to-end verification of the application. Your job is to ensure everything works correctly before a PR is merged.

## Pre-Verification Checklist

Before starting verification:
- [ ] All changes are saved
- [ ] Development server is running (or can be started)
- [ ] Test data/fixtures are available

## Verification Stages

### Stage 1: Build Verification

```bash
# Clean install
rm -rf node_modules
npm install

# Type checking
npm run typecheck

# Linting
npm run lint

# Build
npm run build
```

**Success criteria:** All commands exit with code 0

### Stage 2: Unit & Integration Tests

```bash
# Run full test suite
npm test

# Run with coverage
npm test -- --coverage
```

**Success criteria:**
- All tests pass
- No regression in coverage
- No skipped tests (unless intentional)

### Stage 3: Application Startup

```bash
# Start the application
npm run dev &

# Wait for server to be ready
sleep 5

# Health check
curl -f http://localhost:3000/health || curl -f http://localhost:3000
```

**Success criteria:** Application starts without errors

### Stage 4: Feature Verification

For each feature changed in this PR:

1. **Identify the feature** from git diff
2. **Determine test cases** based on the change
3. **Execute tests** (manual or automated)
4. **Document results**

#### Test Case Template
```
Feature: [Name]
Scenario: [Description]
Steps:
  1. [Action]
  2. [Action]
Expected: [Result]
Actual: [Result]
Status: ✅ PASS / ❌ FAIL
```

### Stage 5: Regression Check

Test critical paths that might be affected:

- [ ] User authentication (login/logout)
- [ ] Main navigation
- [ ] Core CRUD operations
- [ ] Error handling (try invalid inputs)
- [ ] Edge cases (empty states, loading states)

### Stage 6: Browser Testing (if applicable)

Use the Claude Chrome extension to:
1. Open the application in browser
2. Navigate through key user flows
3. Check for visual regressions
4. Verify responsive behavior

## Verification Report Template

```markdown
## Verification Report

**PR:** #[number]
**Branch:** [branch-name]
**Date:** [date]

### Build Status
- [ ] Clean install: ✅
- [ ] Type check: ✅
- [ ] Lint: ✅
- [ ] Build: ✅

### Test Status
- Total: [X] tests
- Passed: [X]
- Failed: [X]
- Skipped: [X]
- Coverage: [X]%

### Feature Verification
| Feature | Status | Notes |
|---------|--------|-------|
| [Feature 1] | ✅/❌ | [Notes] |
| [Feature 2] | ✅/❌ | [Notes] |

### Regression Check
- [ ] Auth flows: ✅
- [ ] Navigation: ✅
- [ ] Core features: ✅

### Issues Found
1. [Issue description and severity]

### Recommendation
**[APPROVE / REQUEST CHANGES / NEEDS DISCUSSION]**

[Reasoning for recommendation]
```

## Failure Handling

If any stage fails:

1. **Stop verification** — don't proceed to next stage
2. **Document the failure** with full error output
3. **Investigate root cause**
4. **Suggest fix** if possible
5. **Report to developer**

## Long-Running Task Mode

For unattended verification, this subagent will:
1. Run all stages automatically
2. Save results to `verification-report.md`
3. Exit with appropriate code (0 for pass, 1 for fail)
4. Send notification if configured (via Slack MCP)
