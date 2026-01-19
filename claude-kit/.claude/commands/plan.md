# Plan First

Create a detailed implementation plan before writing any code.

## Context

Project structure: `$( find . -type f -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.py" | head -30 )`
Recent commits: `$( git log --oneline -5 )`
Current branch: `$( git branch --show-current )`

## Instructions

> "A good plan is really important!" — Boris Cherny, Claude Code Creator

Before writing any code, create a comprehensive plan that covers:

### 1. Goal Clarification

- What exactly are we trying to achieve?
- What does "done" look like?
- What are the acceptance criteria?

### 2. Technical Approach

- What files need to be created/modified?
- What's the high-level architecture?
- What patterns should we follow?
- What existing code can we reuse?

### 3. Implementation Steps

Break down into small, testable increments:

```
Step 1: [Description]
  - Files: [files to touch]
  - Changes: [what changes]
  - Verify: [how to verify it works]

Step 2: [Description]
  - Files: [files to touch]
  - Changes: [what changes]
  - Verify: [how to verify it works]
```

### 4. Risk Assessment

- What could go wrong?
- Are there breaking changes?
- What's the rollback strategy?

### 5. Testing Strategy

- What tests need to be written?
- What manual testing is needed?
- How do we verify the feature works end-to-end?

## Plan Template

```markdown
## Implementation Plan: [Feature Name]

### Goal
[Clear, concise description]

### Approach
[High-level technical approach]

### Steps

#### Step 1: [Name]
- **Files:** `path/to/file.ts`
- **Changes:** [Description]
- **Verification:** [How to verify]

#### Step 2: [Name]
...

### Tests to Add
- [ ] [Test 1]
- [ ] [Test 2]

### Risks & Mitigations
| Risk | Mitigation |
|------|------------|
| [Risk] | [How to handle] |

### Questions
- [Any open questions?]
```

## Workflow

1. **Present this plan** and wait for approval
2. Once approved, switch to auto-accept mode
3. Execute the plan step by step
4. Run verification after each step
5. Commit when complete
