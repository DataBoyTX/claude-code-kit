# Claude Code Optimization Kit

Based on Boris Cherny's (Claude Code Creator) workflow. Configurations and patterns for maximizing Claude Code performance, reducing user interactions, and enabling autonomous/background execution.

## Quick Start

### Interactive Setup (Recommended)

```bash
cd claude-kit
./setup.sh /path/to/your/project
```

The setup wizard will guide you through:
- ✓ Project type detection (Node, Python, Go, Rust, etc.)
- ✓ Model selection (Opus 4.5 vs Sonnet 4.5)
- ✓ Permission configuration
- ✓ Auto-formatting setup
- ✓ MCP server configuration (GitHub, Slack, etc.)
- ✓ API token setup

### Manual Installation

```bash
# Copy the kit to any project
cp -r claude-kit/.claude /path/to/project/
cp -r claude-kit/subagents /path/to/project/
cp claude-kit/.mcp.json /path/to/project/
cp claude-kit/CLAUDE.md /path/to/project/

# Then customize settings manually
```

## Repository Structure

```
claude-code-kit/
├── README.md                      # This file
├── FEATURES.md                    # Complete feature reference (NEW!)
├── SETUP_EXAMPLE.md               # Setup wizard walkthrough (NEW!)
└── claude-kit/                    # Portable kit (copy this to your project)
    ├── setup.sh                   # Interactive setup wizard (NEW!)
    ├── install.sh                 # Simple installer
    ├── QUICKSTART.md              # Quick reference
    ├── CLAUDE.md                  # Team knowledge template
    ├── .claude/
    │   ├── settings.json          # Pre-allowed permissions
    │   ├── hooks.json             # Auto-format on edit
    │   └── commands/
    │       ├── commit-push-pr.md  # /commit-push-pr
    │       ├── debug.md           # /debug
    │       ├── plan.md            # /plan
    │       ├── review.md          # /review
    │       └── test.md            # /test
    ├── .mcp.json                  # External tools (Slack, GitHub, etc.)
    └── subagents/
        ├── build-validator.md     # Build validation pipeline
        ├── code-architect.md      # Architecture review
        ├── code-simplifier.md     # Simplify code
        ├── oncall-guide.md        # Incident response
        └── verify-app.md          # E2E verification
```

---

## Documentation

| File | Purpose |
|------|---------|
| **[FEATURES.md](FEATURES.md)** | **Complete feature reference with examples** |
| **[SETUP_EXAMPLE.md](SETUP_EXAMPLE.md)** | **Setup wizard walkthrough and examples** |
| `QUICKSTART.md` | Quick reference for common tasks |
| `CLAUDE.md` | Team knowledge base template (customize for your project) |

---

## What's Included

### 1. Interactive Setup Wizard (`setup.sh`)

Walks you through configuration with:
- Project type detection
- Model and thinking budget selection
- Permission pre-approval
- Auto-formatting configuration
- MCP server setup with API tokens
- Notification preferences

**No manual configuration needed** - the wizard handles everything!

### 2. Complete Feature Documentation (`FEATURES.md`)

Comprehensive reference covering:
- All configuration options with examples
- Slash command reference
- Subagent usage guide
- Hooks and MCP server setup
- Workflows and best practices
- Troubleshooting guide

### 3. Model Configuration

**Opus 4.5 (Recommended for complex work):**
> "Even though it's bigger & slower than Sonnet, since you have to steer it less and it's better at tool use, it is almost always faster in the end."

```json
{
  "model": "claude-opus-4-5-20250514",
  "thinking": { "enabled": true, "budget": "high" }
}
```

**Sonnet 4.5 (For simpler tasks):**
```json
{
  "model": "claude-sonnet-4-5-20250929",
  "thinking": { "enabled": true, "budget": "medium" }
}
```

### 4. Plan First, Execute Unattended

Start every significant task in **Plan Mode** (`shift+tab` twice):
1. Describe your goal
2. Iterate on the plan until it's right
3. Switch to **auto-accept mode**
4. Claude executes autonomously

This reduces back-and-forth interactions dramatically.

### 5. Pre-Allow Safe Permissions

Instead of confirming every command, pre-allow known-safe operations in `.claude/settings.json`:

```json
{
  "permissions": {
    "allow": [
      "Bash(npm:*)", "Bash(git:*)", "Bash(node:*)",
      "Bash(curl:*)", "Bash(docker:*)", "Read(*)", "Write(*)"
    ],
    "deny": ["Bash(sudo:*)", "Bash(rm -rf /)"]
  }
}
```

### 6. Slash Commands for Repeating Tasks

Any workflow you do multiple times becomes a slash command in `.claude/commands/`:

| Command | Purpose |
|---------|---------|
| `/commit-push-pr` | Stage, commit, push, create PR |
| `/review` | Code review checklist |
| `/test` | Run and analyze tests |
| `/debug` | Structured debugging framework |
| `/plan` | Create implementation plan |

Commands include **pre-computed context** via inline bash:
```markdown
Current branch: `$( git branch --show-current )`
Staged changes: `$( git diff --cached --stat )`
```

### 7. Subagents for Complex Workflows

Subagents automate multi-step verification and refactoring:

| Subagent | Purpose |
|----------|---------|
| `build-validator` | Full build validation pipeline |
| `verify-app` | End-to-end app verification |
| `code-simplifier` | Simplify code without changing behavior |
| `code-architect` | Architecture review |
| `oncall-guide` | Incident response assistant |

### 8. Hooks for Automatic Quality

Hooks run automatically after Claude actions:

```json
{
  "PostToolUse": [{
    "name": "format-on-edit",
    "match": { "tool": "edit_file", "filePatterns": ["**/*.ts"] },
    "command": "npx prettier --write {{filepath}}",
    "silent": true
  }]
}
```

### 9. MCP Servers for External Tools

Connect Claude to external systems:
- **Slack** - Search/post to channels
- **GitHub** - Issues, PRs, repos
- **PostgreSQL** - Query databases
- **Sentry** - Error logs
- **Memory** - Persistent context across sessions

---

## Background/Unattended Execution

Three approaches for long-running autonomous tasks:

### Option 1: Background Agent Verification
Prompt Claude to spawn a verification subagent when done.

### Option 2: AgentStop Hook
```json
{
  "AgentStop": [{
    "name": "verification-reminder",
    "command": "echo 'Task complete. Consider /verify-app'"
  }]
}
```

### Option 3: Skip Permissions (Sandboxed)
```bash
claude --permission-mode=dontAsk
# or for fully sandboxed environments:
claude --dangerously-skip-permissions
```

---

## Parallel Execution

Boris runs **5 terminal + 5-10 web sessions** simultaneously:

### Terminal Setup
- Number tabs 1-5 for easy reference
- Enable iTerm2/tmux notifications for when Claude needs input
- Use terminal multiplexers (tmux, screen) for session management
- Set notification preferences in `.claude/settings.json`

### Web Sessions
- Run at claude.ai/code in parallel with terminal
- Use `--teleport` to move sessions between terminal and web
- Start from mobile (Claude iOS app), check in later

---

## Verification: The Force Multiplier

> "Probably the most important thing to get great results — give Claude a way to verify its work. This will 2-3x the quality."

| Domain | Verification |
|--------|--------------|
| CLI tools | Run command, check output |
| Web apps | Chrome extension UI testing |
| Libraries | Run test suite |
| APIs | Make test requests |

---

## Team Knowledge: CLAUDE.md

The `CLAUDE.md` file is your project's institutional memory:
- Check into git
- Whole team maintains it
- Add entries when Claude makes mistakes
- Update during code review via `@.claude` tagging

---

## File Structure After Setup

```
your-repo/
├── CLAUDE.md                    # Team knowledge base
├── .claude/
│   ├── settings.json            # Permissions
│   ├── hooks.json               # Auto-formatting
│   └── commands/
│       ├── commit-push-pr.md
│       ├── review.md
│       ├── test.md
│       ├── debug.md
│       └── plan.md
├── .mcp.json                    # External tools
└── subagents/
    ├── build-validator.md
    ├── verify-app.md
    ├── code-simplifier.md
    ├── code-architect.md
    └── oncall-guide.md
```

---

## Summary: Reducing Interactions

| Problem | Solution |
|---------|----------|
| Confirming every command | Pre-allow permissions in settings.json |
| Repeating prompts | Slash commands with pre-computed context |
| Steering Claude | Use Opus 4.5 with extended thinking |
| Back-and-forth on approach | Plan mode first, then auto-accept |
| Manual verification | Subagents + hooks |
| Waiting for completion | Parallel sessions + notifications |
| Context loss between sessions | CLAUDE.md + MCP memory server |

---

## Next Steps

1. **Run the setup wizard:**
   ```bash
   cd claude-kit
   ./setup.sh /path/to/your/project
   ```

2. **Read the comprehensive guide:**
   - [FEATURES.md](FEATURES.md) - Complete feature reference with examples
   - [QUICKSTART.md](claude-kit/QUICKSTART.md) - Quick reference for common workflows

3. **Customize for your project:**
   - Edit `CLAUDE.md` with project-specific knowledge
   - Add custom slash commands in `.claude/commands/`
   - Customize subagents for your verification needs

4. **Start using Claude:**
   ```bash
   cd /path/to/your/project
   claude  # Interactive mode
   # or press shift+tab twice for Plan Mode
   ```

---

## Sources

- Boris Cherny's Claude Code workflow insights
- Official Claude Code documentation: https://code.claude.com/docs
