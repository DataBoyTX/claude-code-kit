# Claude Code Optimization Kit - Repository Summary

A pre-built configuration kit for maximizing Claude Code performance. Based on Boris Cherny's (Claude Code creator) workflow patterns. Copy into any project and run the setup wizard - no manual configuration needed.

## What This Solves

Claude Code out of the box stops frequently to ask permission, doesn't auto-format, has no reusable workflows, and loses context between sessions. This kit fixes all of that.

## What's In The Kit

### Configuration (`.claude/`)
- **settings.json** - Pre-approves 60+ safe commands (git, npm, python, docker, etc.) so Claude stops interrupting you. Blocks dangerous commands (sudo, rm -rf /, etc.). Default model: Opus 4.6.
- **hooks.json** - Auto-formats files after every edit (Prettier for JS/TS, Black for Python, ESLint auto-fix for TypeScript). Runs type checking before commits. Silent execution - no interruptions.

### Slash Commands (`.claude/commands/`)
Five reusable workflows you invoke with `/command-name`:
- `/commit-push-pr` - stage, commit, push, and open a PR in one step
- `/plan` - create an implementation plan before coding
- `/debug` - structured debugging with hypothesis testing
- `/review` - code review checklist (bugs, security, performance, tests)
- `/test` - run tests and analyze failures

Each command embeds live context via `$( git branch --show-current )` syntax so Claude has relevant info without you pasting it.

### Subagents (`subagents/`)
Autonomous multi-step task runners:
- **build-validator** - full pipeline: clean install, typecheck, lint, test, build, bundle analysis, smoke test
- **verify-app** - end-to-end app verification with startup, feature testing, regression checks
- **code-simplifier** - simplify code without changing behavior
- **code-architect** - architecture review and recommendations
- **oncall-guide** - incident response: error analysis, root cause, fix, report

### MCP Servers (`.mcp.json`)
Pre-configured integrations for GitHub, Slack, PostgreSQL, Sentry, Brave Search, Memory (cross-session context), and Fetch (web/API access). Tokens loaded from environment variables.

### Team Knowledge (`CLAUDE.md`)
Template for project-specific context that Claude reads automatically every session. Fill in your build commands, architecture decisions, common mistakes, and conventions. Check into git so the whole team benefits.

### Setup Wizard (`setup.sh`)
Interactive 8-step installer that:
1. Detects your project type (Node, Python, Rust, Go)
2. Detects your package manager and formatter
3. Lets you pick model and thinking budget
4. Configures permissions for your stack
5. Sets up auto-formatting hooks
6. Configures MCP servers with your API tokens
7. Generates all config files

## Key Performance Patterns

| Pattern | Impact |
|---------|--------|
| Pre-approve permissions | Eliminates constant confirmation dialogs |
| Plan Mode (shift+tab x2) | Reduces back-and-forth by 50%+ on complex tasks |
| Auto-format hooks | No manual cleanup after edits |
| Verification subagents | 2-3x quality improvement (Claude checks its own work) |
| Slash commands with dynamic context | Reuse workflows, skip repetitive prompting |
| Background agents | Run long tasks without watching |
| Parallel sessions (5+ terminals) | Multiply throughput |
| CLAUDE.md | Persistent context, no re-explaining between sessions |

## Models

| Model | ID | Best For |
|-------|----|----------|
| Opus 4.6 | `claude-opus-4-6` | Complex refactors, architecture, debugging |
| Sonnet 4.6 | `claude-sonnet-4-6` | General development, well-defined features |
| Haiku 4.5 | `claude-haiku-4-5-20251001` | Quick edits, simple fixes |

## Getting Started

```bash
cd claude-kit
./setup.sh /path/to/your/project
```

Or manually copy the `claude-kit/` contents into your project and edit the configs.

## Documentation

| File | Description |
|------|-------------|
| [README.md](README.md) | Overview and quick start |
| [FEATURES.md](FEATURES.md) | Complete feature reference with all config options |
| [PERFORMANCE_GUIDE.md](PERFORMANCE_GUIDE.md) | Shareable 10-point optimization guide |
| [SETUP_EXAMPLE.md](SETUP_EXAMPLE.md) | Step-by-step setup wizard walkthrough |
| [claude-kit/QUICKSTART.md](claude-kit/QUICKSTART.md) | Quick reference for daily use |
