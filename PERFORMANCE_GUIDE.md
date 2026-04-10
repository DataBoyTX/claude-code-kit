# Claude Code Performance Optimization Guide

**Copy this into a conversation or save it as a reference to dramatically improve your Claude Code experience.**

---

## 1. Pre-approve permissions to eliminate interruptions

The single biggest speed improvement. Create `.claude/settings.json` in your project root:

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": [
      "Bash(git:*)", "Bash(gh:*)",
      "Bash(npm:*)", "Bash(npx:*)", "Bash(node:*)",
      "Bash(tsc:*)", "Bash(eslint:*)", "Bash(prettier:*)",
      "Bash(jest:*)", "Bash(vitest:*)",
      "Bash(python:*)", "Bash(pip:*)",
      "Bash(cargo:*)", "Bash(go:*)", "Bash(docker:*)",
      "Bash(curl:*)", "Bash(jq:*)", "Bash(grep:*)", "Bash(find:*)",
      "Bash(ls:*)", "Bash(cat:*)", "Bash(mkdir:*)", "Bash(cp:*)", "Bash(mv:*)",
      "Read(*)", "Write(*)"
    ],
    "deny": [
      "Bash(sudo:*)", "Bash(su:*)",
      "Bash(*rm -rf /*)", "Bash(*mkfs*)",
      "Bash(*> /dev/sd*)", "Bash(*dd if=*/dev/*)"
    ]
  }
}
```

Add any project-specific tools (`Bash(make:*)`, `Bash(pytest:*)`, `Bash(ruff:*)`, etc.). This lets Claude run common commands without stopping to ask you every time.

## 2. Auto-format on edit with hooks

Create `.claude/hooks.json` so Claude's edits are automatically formatted - no manual cleanup:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "name": "format-on-edit",
        "match": { "tool": "edit_file", "filePatterns": ["**/*.ts", "**/*.tsx", "**/*.js", "**/*.jsx", "**/*.json"] },
        "command": "npx prettier --write {{filepath}}",
        "timeout": 10000,
        "silent": true
      },
      {
        "name": "lint-fix",
        "match": { "tool": "edit_file", "filePatterns": ["**/*.ts", "**/*.tsx"] },
        "command": "npx eslint {{filepath}} --fix --quiet 2>/dev/null || true",
        "timeout": 15000,
        "silent": true
      }
    ]
  }
}
```

Swap `prettier`/`eslint` for your stack: `black`/`ruff` for Python, `rustfmt` for Rust, etc.

## 3. Use Plan Mode for non-trivial work

Press `shift+tab` twice to enter Plan Mode. Claude designs the solution first, you review, then it executes. This avoids wasted iterations where Claude goes down the wrong path. For complex tasks, this alone can save 50%+ of back-and-forth.

## 4. Run background agents for long tasks

Don't watch Claude run a full build pipeline - let it work in the background:

```bash
# Run a validation agent in the background
claude --agent subagents/build-validator.md &

# Or use --permission-mode=dontAsk for fully autonomous work
claude --permission-mode=dontAsk "run all tests and fix any failures"
```

Enable notifications in settings so you know when it finishes:
```json
{
  "notifications": { "enabled": true, "sound": true }
}
```

## 5. Run parallel sessions

Open 3-5 terminal tabs and run Claude in each. Work on multiple features simultaneously. Combined with notifications, you can context-switch between sessions as each one needs input.

## 6. Create slash commands for repeated workflows

Save reusable prompts in `.claude/commands/`. The key trick: embed live context with `$( )`:

`.claude/commands/commit-push-pr.md`:
```markdown
Review changes and create a PR.

Current branch: $( git branch --show-current )
Staged changes: $( git diff --cached --stat )
Recent commits: $( git log -5 --oneline )

Steps:
1. Review all changes
2. Create a conventional commit
3. Push and open PR with summary
```

Now just type `/commit-push-pr` instead of explaining the workflow each time.

## 7. Write a good CLAUDE.md

Check a `CLAUDE.md` into your repo root with build commands, architecture decisions, common mistakes, and conventions. This is persistent context that survives across sessions - Claude reads it automatically. Update it whenever Claude makes a mistake so it doesn't repeat it.

## 8. Match model to task complexity

- **Opus 4.6** - complex refactors, architecture, debugging
- **Sonnet 4.6** - general development, well-defined features
- **Haiku 4.5** - quick edits, simple fixes, code formatting

Use `/fast` to toggle faster output within the same model when you don't need deep reasoning.

## 9. Give Claude a way to verify its work

This is the highest-leverage quality improvement. Create verification subagents or just tell Claude: "After making changes, run the tests and fix any failures." A build-validator subagent that runs typecheck, lint, test, and build in sequence catches 90% of issues before you even look at the code.

## 10. Connect external tools via MCP

Add to `.mcp.json` for direct access to GitHub, Slack, databases, etc.:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-github"],
      "env": { "GITHUB_TOKEN": "${GITHUB_TOKEN}" }
    },
    "fetch": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-fetch"]
    }
  }
}
```

This lets Claude look up issues, check PRs, and fetch docs without you copy-pasting.

---

## Quick-start checklist

1. Create `.claude/settings.json` with pre-approved permissions
2. Create `.claude/hooks.json` with auto-formatting
3. Write a `CLAUDE.md` with your project's build/test/conventions
4. Create 2-3 slash commands for your most common workflows
5. Enable notifications for background work
6. Use Plan Mode (`shift+tab` x2) before starting complex tasks

**The goal: minimize the number of times Claude stops to ask you things, and maximize the quality of what it produces autonomously.**
