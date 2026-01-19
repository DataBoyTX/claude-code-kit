# CLAUDE.md — Project Intelligence

> Update this file when Claude makes mistakes. Check into git.

## Project Overview

**Project:** [Your Project Name]
**Language:** [Primary language(s)]
**Framework:** [Framework(s)]

## Build & Test

```bash
# Dev
npm run dev

# Test
npm test

# Build
npm run build

# Lint & Type Check
npm run lint && npm run typecheck
```

## Architecture Decisions

### [Decision Name]
**Choice:** [What you chose]
**Why:** [Rationale]
**Implication:** [What Claude should do/avoid]

## Common Mistakes

### Don't: [Mistake]
**Why:** [Reason]
**Instead:** [Correct approach]

## Code Conventions

- Components: `src/components/` (PascalCase)
- Utils: `src/utils/` (camelCase)
- Tests: colocated as `*.test.ts`
- Imports: externals → internals → relatives → types

## Claude Instructions

- Read files before modifying
- Run tests after changes
- Keep functions under 50 lines
- Prefer composition over inheritance
- Use early returns to reduce nesting
