# Claude Code Optimization Kit - Quick Reference

## Installation

```bash
# Option 1: Run installer
./install.sh /path/to/your/project

# Option 2: Copy manually
cp -r claude-kit/.claude /path/to/project/
cp -r claude-kit/subagents /path/to/project/
cp claude-kit/.mcp.json /path/to/project/
cp claude-kit/CLAUDE.md /path/to/project/  # if no existing CLAUDE.md
```

## What Gets Installed

```
your-project/
├── CLAUDE.md                      # Team knowledge (customize this)
├── .mcp.json                      # External tools (add API tokens)
├── .claude/
│   ├── settings.json              # Pre-allowed permissions
│   ├── hooks.json                 # Auto-format on save
│   └── commands/
│       ├── commit-push-pr.md      # /commit-push-pr
│       ├── debug.md               # /debug
│       ├── plan.md                # /plan
│       ├── review.md              # /review
│       └── test.md                # /test
└── subagents/
    ├── build-validator.md         # Full build validation
    ├── code-architect.md          # Architecture review
    ├── code-simplifier.md         # Simplify without changing behavior
    ├── oncall-guide.md            # Incident response
    └── verify-app.md              # End-to-end verification
```

## Key Workflows

### Start Every Session in Plan Mode
```
shift+tab (twice) → describe goal → iterate → switch to auto-accept → execute
```

### Slash Commands
| Command | What It Does |
|---------|--------------|
| `/commit-push-pr` | Stage, commit, push, create PR |
| `/review` | Run code review checklist |
| `/test` | Run tests with analysis |
| `/debug` | Structured debugging |
| `/plan` | Create implementation plan |

### Background Execution
```bash
# Skip all permission prompts (use in sandboxed environments)
claude --permission-mode=dontAsk

# Or for fully unattended
claude --dangerously-skip-permissions
```

## Customization Checklist

- [ ] Edit `CLAUDE.md` with your project specifics
- [ ] Add API tokens to `.mcp.json` (Slack, GitHub, Sentry, etc.)
- [ ] Review `.claude/settings.json` - add/remove allowed commands
- [ ] Add project-specific slash commands to `.claude/commands/`
- [ ] Customize subagents for your verification needs
