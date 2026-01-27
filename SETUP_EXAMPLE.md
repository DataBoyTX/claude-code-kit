# Setup Wizard - Example Walkthrough

This document shows what the interactive setup wizard looks like and what questions it asks.

## Running the Setup

```bash
cd claude-kit
./setup.sh /path/to/your/project
```

## Example Session

```
═══════════════════════════════════════════════════════
  Claude Code Optimization Kit - Setup Wizard
═══════════════════════════════════════════════════════

This wizard will help you configure Claude Code for maximum performance.
You can press Enter to accept defaults shown in parentheses.

═══════════════════════════════════════════════════════
  Step 1: Installation Target
═══════════════════════════════════════════════════════

? Install to current directory (/home/user/my-project)? [Y/n]: y
ℹ Installing to: /home/user/my-project

═══════════════════════════════════════════════════════
  Step 2: Project Configuration
═══════════════════════════════════════════════════════

ℹ Detected Node.js project
ℹ Detected package manager: npm
ℹ Detected formatter: prettier

? Confirm project type:
  1. Node.js/TypeScript
  2. Python
  3. Go
  4. Rust
  5. Java/Kotlin
  6. Other/Mixed
? Enter choice [1-6]: 1

═══════════════════════════════════════════════════════
  Step 3: Claude Model Selection
═══════════════════════════════════════════════════════

Opus 4.5: Larger, slower, but requires less steering (recommended for complex work)
Sonnet 4.5: Faster, cheaper, good for simpler tasks

? Select Claude model:
  1. Opus 4.5 (recommended)
  2. Sonnet 4.5
? Enter choice [1-2]: 1

? Extended thinking budget:
  1. High (most thorough)
  2. Medium (balanced)
  3. Low (faster)
  4. Disabled
? Enter choice [1-4]: 1

═══════════════════════════════════════════════════════
  Step 4: Permission Configuration
═══════════════════════════════════════════════════════

Pre-allowing safe commands reduces interruptions.
You can customize this later in .claude/settings.json

? Auto-accept file edits? (risky but faster) [y/N]: n

? Add project-specific commands to allow list? [y/N]: y
ℹ Enter commands one per line (e.g., 'make', 'cargo', 'go'). Empty line to finish.
? Command to allow (or press Enter to finish): make
? Command to allow (or press Enter to finish): docker
? Command to allow (or press Enter to finish):

═══════════════════════════════════════════════════════
  Step 5: Hooks Configuration
═══════════════════════════════════════════════════════

Hooks run automatically after Claude makes changes.
Common use: auto-format files after editing

? Enable auto-formatting hooks? [Y/n]: y
? Use detected formatter (prettier)? [Y/n]: y

═══════════════════════════════════════════════════════
  Step 6: MCP Server Configuration
═══════════════════════════════════════════════════════

MCP servers connect Claude to external tools and services.
You can configure API tokens now or add them later to .mcp.json

? Enable MCP servers? [Y/n]: y
? Enable GitHub integration? [Y/n]: y
  ? Configure GitHub token now? [y/N]: n
  ℹ Add GITHUB_TOKEN to .mcp.json later
? Enable Slack integration? [y/N]: n
? Enable PostgreSQL integration? [y/N]: n
? Enable Brave Search? [y/N]: n
? Enable Sentry integration? [y/N]: y
  ? Configure Sentry now? [y/N]: y
  ? Sentry auth token: sntrys_xxxxxxxxxxxxx
  ? Sentry organization: my-company

═══════════════════════════════════════════════════════
  Step 7: Notification Settings
═══════════════════════════════════════════════════════

? Enable desktop notifications? [Y/n]: y
? Enable notification sounds? [Y/n]: y

═══════════════════════════════════════════════════════
  Step 8: Installing Files
═══════════════════════════════════════════════════════

➜ Creating directories...
➜ Copying slash commands...
✓ Installed slash commands: /commit-push-pr, /debug, /plan, /review, /test
➜ Copying subagents...
✓ Installed subagents: build-validator, code-architect, code-simplifier, oncall-guide, verify-app
➜ Generating .claude/settings.json...
✓ Generated settings.json with claude-opus-4-5-20250514 and high thinking
➜ Generating .claude/hooks.json...
✓ Configured auto-formatting with prettier
➜ Generating .mcp.json...
✓ Generated .mcp.json with 4 enabled servers
➜ Setting up CLAUDE.md...
✓ Created CLAUDE.md template
⚠ Customize CLAUDE.md with your project specifics
➜ Updating .gitignore...
✓ Added .claude/settings.local.json to .gitignore

═══════════════════════════════════════════════════════
  Installation Complete!
═══════════════════════════════════════════════════════

✓ Installed to: /home/user/my-project

Configuration Summary:
  • Model: claude-opus-4-5-20250514
  • Thinking: high
  • Auto-accept edits: false
  • Auto-formatting: prettier
  • MCP servers: memory, fetch, github, sentry
  • Notifications: true

Installed Files:
  • .claude/settings.json    - Pre-allowed permissions & model config
  • .claude/hooks.json       - Auto-formatting hooks
  • .claude/commands/        - 5 slash commands (/commit-push-pr, /debug, /plan, /review, /test)
  • subagents/               - 5 autonomous task runners
  • .mcp.json                - External tool integrations
  • CLAUDE.md                - Team knowledge base template

Next Steps:
  1. Edit CLAUDE.md with your project details
  2. Review .claude/settings.json permissions
  3. Add GITHUB_TOKEN to .mcp.json or environment

Getting Started:
  cd /home/user/my-project
  claude          # Start in interactive mode
  # or press shift+tab twice to start in Plan Mode

Quick Tips:
  • Start every session with Plan Mode (shift+tab twice)
  • Use /commit-push-pr for quick PR workflows
  • Run subagents with: claude --agent subagents/build-validator.md
  • Check QUICKSTART.md for more workflows

✓ Happy coding with Claude!
```

## What Gets Created

After setup, your project will have:

```
your-project/
├── CLAUDE.md                    # ← Customize this for your project
├── .mcp.json                    # ← Contains your MCP server config
├── .claude/
│   ├── settings.json            # ← Your permission & model config
│   ├── hooks.json               # ← Auto-formatting configuration
│   └── commands/
│       ├── commit-push-pr.md
│       ├── debug.md
│       ├── plan.md
│       ├── review.md
│       └── test.md
└── subagents/
    ├── build-validator.md
    ├── code-architect.md
    ├── code-simplifier.md
    ├── oncall-guide.md
    └── verify-app.md
```

## Configuration Files Explained

### `.claude/settings.json`

Based on your choices, contains:
- Model selection (Opus or Sonnet)
- Thinking budget
- Pre-allowed permissions
- Auto-accept edits setting
- Notification preferences

**Example:**
```json
{
  "model": "claude-opus-4-5-20250514",
  "thinking": {
    "enabled": true,
    "budget": "high"
  },
  "permissions": {
    "allow": [
      "Bash(git:*)",
      "Bash(npm:*)",
      "Bash(make:*)",
      "Bash(docker:*)",
      "Read(*)",
      "Write(*)"
    ],
    "deny": ["Bash(sudo:*)"]
  },
  "autoAcceptEdits": false,
  "notifications": {
    "enabled": true,
    "sound": true
  }
}
```

### `.claude/hooks.json`

Auto-formatting configuration:

```json
{
  "PostToolUse": [
    {
      "name": "format-on-edit",
      "match": {
        "tool": "edit_file",
        "filePatterns": ["**/*.{ts,tsx,js,jsx,json,md}"]
      },
      "command": "npx prettier --write {{filepath}}",
      "silent": true
    }
  ]
}
```

### `.mcp.json`

External tool integrations:

```json
{
  "mcpServers": {
    "memory": { ... },
    "fetch": { ... },
    "github": {
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"  // ← Add your token here or to env
      }
    },
    "sentry": {
      "env": {
        "SENTRY_AUTH_TOKEN": "sntrys_xxxxx",  // ← Your configured token
        "SENTRY_ORG": "my-company"
      }
    }
  }
}
```

## Adding API Tokens Later

If you skipped API token configuration during setup:

### Option 1: Environment Variables (Recommended)

Create `.env` file:
```bash
export GITHUB_TOKEN=ghp_xxxxxxxxxxxxx
export SLACK_BOT_TOKEN=xoxb-xxxxxxxxxxxxx
export DATABASE_URL=postgresql://...
```

Load before running Claude:
```bash
source .env
claude
```

### Option 2: Direct in .mcp.json (Not recommended for shared repos)

Edit `.mcp.json`:
```json
{
  "github": {
    "env": {
      "GITHUB_TOKEN": "ghp_your_actual_token_here"
    }
  }
}
```

Add `.mcp.json` to `.gitignore` if storing tokens directly.

## Customizing After Setup

### Add More Commands to Allow List

Edit `.claude/settings.json`:
```json
{
  "permissions": {
    "allow": [
      // ... existing commands ...
      "Bash(kubectl:*)",
      "Bash(terraform:*)"
    ]
  }
}
```

### Change Model or Thinking Budget

Edit `.claude/settings.json`:
```json
{
  "model": "claude-sonnet-4-5-20250929",  // Switch to Sonnet
  "thinking": {
    "enabled": true,
    "budget": "medium"  // Lower thinking budget
  }
}
```

### Add More Formatters

Edit `.claude/hooks.json`:
```json
{
  "PostToolUse": [
    {
      "name": "format-ts",
      "match": {
        "tool": "edit_file",
        "filePatterns": ["**/*.ts"]
      },
      "command": "prettier --write {{filepath}}"
    },
    {
      "name": "format-py",
      "match": {
        "tool": "edit_file",
        "filePatterns": ["**/*.py"]
      },
      "command": "black {{filepath}}"
    }
  ]
}
```

## Getting Help

- **Quick reference:** See `QUICKSTART.md`
- **Complete guide:** See `FEATURES.md`
- **Issues:** Check `.claude/` configuration files
- **Logs:** Check `~/.claude/logs/`

## Re-running Setup

Setup is safe to re-run. It will:
- ✓ Regenerate all config files
- ✓ Skip existing `CLAUDE.md` (won't overwrite your customizations)
- ⚠ Overwrite `.claude/settings.json`, `.claude/hooks.json`, and `.mcp.json`

To preserve customizations:
```bash
# Backup first
cp .claude/settings.json .claude/settings.backup.json
cp .mcp.json .mcp.backup.json

# Re-run setup
./setup.sh .

# Merge any custom changes back
```
