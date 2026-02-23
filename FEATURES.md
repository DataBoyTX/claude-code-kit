# Claude Code Optimization Kit - Complete Feature Reference

## Table of Contents

1. [Core Features](#core-features)
2. [Settings Configuration](#settings-configuration)
3. [Slash Commands](#slash-commands)
4. [Subagents](#subagents)
5. [Hooks](#hooks)
6. [MCP Servers](#mcp-servers)
7. [Workflows](#workflows)
8. [Advanced Usage](#advanced-usage)

---

## Core Features

### 1. Model Configuration

**What it does:** Controls which Claude model handles your requests

**Options:**
- **Opus 4.6** (`claude-opus-4-6`)
  - Most capable model
  - Better at complex reasoning and tool use
  - Requires less steering/intervention
  - **Recommended for:** Complex refactoring,
    architecture decisions, debugging

- **Sonnet 4.6** (`claude-sonnet-4-6`)
  - Fast and capable
  - Good balance of speed and quality
  - **Recommended for:** General development,
    bug fixes, well-defined tasks

- **Haiku 4.5** (`claude-haiku-4-5-20251001`)
  - Fastest and cheapest
  - Good for simple, straightforward tasks
  - **Recommended for:** Quick edits, simple fixes

**Configuration:** `.claude/settings.json`
```json
{
  "model": "claude-opus-4-6"
}
```

**When to switch:**
- Use Opus for greenfield development and complex tasks
- Use Sonnet for general development
- Use Haiku for quick, simple changes

---

### 2. Extended Thinking

**What it does:** Allows Claude to "think" longer before responding, improving response quality

**Options:**
- **High** - Maximum thinking time, best for complex problems
- **Medium** - Balanced thinking time
- **Low** - Minimal thinking, faster responses
- **Disabled** - No extended thinking

**Configuration:** `.claude/settings.json`
```json
{
  "thinking": {
    "enabled": true,
    "budget": "high"
  }
}
```

**Impact:**
- Higher budgets = better reasoning but slower responses
- Recommended: `high` for Opus, `medium` for Sonnet

---

### 3. Permission Pre-Approval

**What it does:** Reduces interruptions by pre-approving safe commands

**How it works:**
- Commands in `allow` list execute without confirmation
- Commands in `deny` list are blocked
- Everything else requires approval

**Configuration:** `.claude/settings.json`
```json
{
  "permissions": {
    "allow": [
      "Bash(git:*)",      // All git commands
      "Bash(npm:*)",      // All npm commands
      "Read(*)",          // Read any file
      "Write(*)"          // Write any file
    ],
    "deny": [
      "Bash(sudo:*)",     // Block sudo
      "Bash(rm -rf /)"    // Block dangerous deletions
    ]
  }
}
```

**Customization:**
- Add project-specific commands: `"Bash(make:*)"`, `"Bash(cargo:*)"`, etc.
- Be cautious with `Write(*)` - consider specific paths if concerned
- Always deny destructive commands

**Pattern syntax:**
- `Bash(cmd:*)` - All invocations of `cmd`
- `Bash(git:push)` - Only `git push`
- `Read(/path/*)` - Files under `/path/`

---

### 4. Auto-Accept Edits

**What it does:** Automatically applies file edits without user confirmation

**Configuration:** `.claude/settings.json`
```json
{
  "autoAcceptEdits": true
}
```

**⚠️ Warning:**
- Risky for production codebases
- Recommended only for:
  - Sandboxed environments
  - Trusted projects
  - When using version control
- Always review changes before committing

**Best practice:** Keep `false` and use Plan Mode with manual approval

---

### 5. Notifications

**What it does:** Desktop notifications when Claude needs attention

**Configuration:** `.claude/settings.json`
```json
{
  "notifications": {
    "enabled": true,
    "sound": true
  }
}
```

**Use cases:**
- Running parallel sessions (5+ terminals)
- Long-running tasks
- Background/unattended execution

---

## Settings Configuration

### Complete settings.json Reference

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",

  // Model and thinking
  "model": "claude-opus-4-6",
  "thinking": {
    "enabled": true,
    "budget": "high"  // "high" | "medium" | "low"
  },

  // Permissions
  "permissions": {
    "allow": [
      "Bash(git:*)",
      "Bash(npm:*)",
      "Read(*)",
      "Write(*)"
    ],
    "deny": [
      "Bash(sudo:*)"
    ]
  },

  // Automation
  "autoAcceptEdits": false,

  // Notifications
  "notifications": {
    "enabled": true,
    "sound": true
  }
}
```

### Local Overrides

Create `.claude/settings.local.json` for machine-specific settings:
```json
{
  "model": "claude-sonnet-4-6",
  "autoAcceptEdits": true
}
```

**Note:** Add to `.gitignore` to keep local settings private

---

## Slash Commands

Slash commands are reusable prompts stored in `.claude/commands/`

### Available Commands

#### `/commit-push-pr`

**Purpose:** Complete PR workflow in one command

**What it does:**
1. Shows current git status
2. Reviews unstaged/staged changes
3. Creates commit with conventional format
4. Pushes to remote
5. Creates pull request with template

**When to use:** Quick PR creation for small features

**Customization:** Edit `.claude/commands/commit-push-pr.md` to match your team's PR template

---

#### `/debug`

**Purpose:** Structured debugging workflow

**What it does:**
1. Reproduces the issue
2. Forms hypotheses
3. Adds logging/breakpoints
4. Tests fixes
5. Verifies solution

**When to use:** Investigating bugs with unclear causes

---

#### `/plan`

**Purpose:** Create implementation plan before coding

**What it does:**
1. Analyzes requirements
2. Breaks down into subtasks
3. Identifies risks
4. Creates step-by-step plan

**When to use:** Before starting any non-trivial feature

**Tip:** Combine with Plan Mode (shift+tab twice)

---

#### `/review`

**Purpose:** Code review checklist

**What it does:**
1. Checks for bugs and edge cases
2. Reviews error handling
3. Validates security
4. Checks performance
5. Reviews tests

**When to use:** Before submitting PRs, after major changes

---

#### `/test`

**Purpose:** Run and analyze test suite

**What it does:**
1. Runs project tests
2. Analyzes failures
3. Suggests fixes
4. Validates test coverage

**When to use:** After making changes, debugging test failures

---

### Creating Custom Commands

Create `.claude/commands/your-command.md`:

```markdown
# Your Command

Instructions for Claude...

## Pre-computed Context

Current branch: `$( git branch --show-current )`
Recent commits: `$( git log -5 --oneline )`

## Steps

1. Do this
2. Then that
3. Finally this
```

**Tips:**
- Use inline bash with `$( command )` for dynamic context
- Include specific examples
- Reference team conventions

---

## Subagents

Subagents are autonomous task runners that operate independently.

### Available Subagents

#### `build-validator`

**Purpose:** Full build validation pipeline

**What it does:**
1. Runs type checking
2. Runs linter
3. Runs tests
4. Runs build
5. Reports all issues

**Usage:**
```bash
claude --agent subagents/build-validator.md
```

**When to use:** Before pushing, in CI pipeline, after major refactors

---

#### `code-architect`

**Purpose:** Architecture review and recommendations

**What it does:**
1. Analyzes codebase structure
2. Identifies patterns and anti-patterns
3. Suggests improvements
4. Creates architecture diagrams

**Usage:**
```bash
claude --agent subagents/code-architect.md
```

**When to use:** Starting new projects, refactoring planning

---

#### `code-simplifier`

**Purpose:** Simplify code without changing behavior

**What it does:**
1. Identifies complex functions
2. Suggests simplifications
3. Removes dead code
4. Improves readability

**Usage:**
```bash
claude --agent subagents/code-simplifier.md
```

**When to use:** After rapid prototyping, before code review

**Note:** Always review changes - maintains behavior but may change implementation details

---

#### `oncall-guide`

**Purpose:** Incident response assistant

**What it does:**
1. Analyzes error logs
2. Identifies root cause
3. Suggests immediate fixes
4. Creates incident report

**Usage:**
```bash
claude --agent subagents/oncall-guide.md
```

**When to use:** Production incidents, debugging critical issues

---

#### `verify-app`

**Purpose:** End-to-end application verification

**What it does:**
1. Starts application
2. Tests critical paths
3. Validates UI/API responses
4. Reports issues

**Usage:**
```bash
claude --agent subagents/verify-app.md
```

**When to use:** After deployments, before releases, integration testing

**Customization:** Edit to match your app's critical paths

---

### Creating Custom Subagents

Create `subagents/your-agent.md`:

```markdown
# Your Subagent

## Objective
Clear goal statement

## Steps
1. Detailed step
2. Another step
3. Verification step

## Success Criteria
- Criterion 1
- Criterion 2

## Error Handling
What to do if things fail
```

**Run with:**
```bash
claude --agent subagents/your-agent.md
```

---

## Hooks

Hooks execute shell commands automatically after Claude actions.

### Available Hook Types

- **PostToolUse** - After any tool is used
- **AgentStop** - When an agent finishes
- **PrePromptSubmit** - Before sending prompts

### Auto-Formatting Hook

**Configuration:** `.claude/hooks.json`

```json
{
  "PostToolUse": [
    {
      "name": "format-on-edit",
      "match": {
        "tool": "edit_file",
        "filePatterns": ["**/*.ts", "**/*.tsx"]
      },
      "command": "npx prettier --write {{filepath}}",
      "silent": true,
      "description": "Auto-format TypeScript files"
    }
  ]
}
```

### Hook Configuration Options

- **name** - Identifier for the hook
- **match** - When to trigger
  - `tool` - Which tool (e.g., `edit_file`, `write_file`)
  - `filePatterns` - Glob patterns
- **command** - Shell command to run
  - `{{filepath}}` - Replaced with actual file path
- **silent** - Hide output (true/false)
- **description** - What the hook does

### Common Hooks

#### Lint on Edit
```json
{
  "name": "lint-on-edit",
  "match": {
    "tool": "edit_file",
    "filePatterns": ["**/*.ts"]
  },
  "command": "eslint --fix {{filepath}}",
  "silent": true
}
```

#### Run Tests After Changes
```json
{
  "name": "test-on-edit",
  "match": {
    "tool": "edit_file",
    "filePatterns": ["src/**/*.ts"]
  },
  "command": "npm test -- --findRelatedTests {{filepath}}",
  "silent": false
}
```

#### Verification Reminder
```json
{
  "AgentStop": [
    {
      "name": "verify-reminder",
      "command": "echo 'Task complete. Run /verify-app to test changes'"
    }
  ]
}
```

---

## MCP Servers

Model Context Protocol servers connect Claude to external tools and services.

### Available MCP Servers

#### Memory Server

**Purpose:** Persistent context across sessions

**Configuration:**
```json
{
  "memory": {
    "command": "npx",
    "args": ["-y", "@anthropic/mcp-server-memory"]
  }
}
```

**What it does:**
- Remembers facts between sessions
- Stores user preferences
- Maintains project context

**No setup required** - works out of the box

---

#### GitHub Server

**Purpose:** Interact with GitHub repositories, issues, PRs

**Configuration:**
```json
{
  "github": {
    "command": "npx",
    "args": ["-y", "@anthropic/mcp-server-github"],
    "env": {
      "GITHUB_TOKEN": "${GITHUB_TOKEN}"
    }
  }
}
```

**Setup:**
1. Create GitHub Personal Access Token (PAT)
2. Add to environment: `export GITHUB_TOKEN=your_token`
3. Or add directly to `.mcp.json` (not recommended for shared repos)

**Capabilities:**
- Search issues and PRs
- Create/update issues
- Comment on PRs
- Query repository data

---

#### Slack Server

**Purpose:** Search and post to Slack channels

**Configuration:**
```json
{
  "slack": {
    "command": "npx",
    "args": ["-y", "@anthropic/mcp-server-slack"],
    "env": {
      "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}",
      "SLACK_TEAM_ID": "${SLACK_TEAM_ID}"
    }
  }
}
```

**Setup:**
1. Create Slack app at api.slack.com
2. Add bot token scopes: `channels:read`, `chat:write`, `channels:history`
3. Install to workspace
4. Get bot token and team ID

**Use cases:**
- Post deployment notifications
- Search historical messages
- Notify team of PR creation

---

#### PostgreSQL Server

**Purpose:** Query databases

**Configuration:**
```json
{
  "postgres": {
    "command": "npx",
    "args": ["-y", "@anthropic/mcp-server-postgres"],
    "env": {
      "DATABASE_URL": "${DATABASE_URL}"
    }
  }
}
```

**Setup:**
```bash
export DATABASE_URL="postgresql://user:pass@localhost:5432/dbname"
```

**Use cases:**
- Debug data issues
- Write migrations
- Analyze query performance

---

#### Sentry Server

**Purpose:** Query error logs and issues

**Configuration:**
```json
{
  "sentry": {
    "command": "npx",
    "args": ["-y", "@anthropic/mcp-server-sentry"],
    "env": {
      "SENTRY_AUTH_TOKEN": "${SENTRY_AUTH_TOKEN}",
      "SENTRY_ORG": "${SENTRY_ORG}"
    }
  }
}
```

**Setup:**
1. Generate auth token in Sentry settings
2. Set environment variables

**Use cases:**
- Investigate production errors
- Analyze error patterns
- Create fixes for reported issues

---

#### Brave Search Server

**Purpose:** Web search for current information

**Configuration:**
```json
{
  "brave-search": {
    "command": "npx",
    "args": ["-y", "@anthropic/mcp-server-brave-search"],
    "env": {
      "BRAVE_API_KEY": "${BRAVE_API_KEY}"
    }
  }
}
```

**Setup:**
1. Get API key from brave.com/search/api
2. Set environment variable

**Use cases:**
- Research new libraries
- Find documentation
- Check latest API changes

---

#### Fetch Server

**Purpose:** Fetch web content and APIs

**Configuration:**
```json
{
  "fetch": {
    "command": "npx",
    "args": ["-y", "@anthropic/mcp-server-fetch"]
  }
}
```

**No setup required**

**Use cases:**
- Test API endpoints
- Fetch documentation
- Download resources

---

### Environment Variables

**Best practice:** Store tokens in environment, not in `.mcp.json`

Create `.env` file:
```bash
export GITHUB_TOKEN=ghp_xxxxx
export SLACK_BOT_TOKEN=xoxb-xxxxx
export DATABASE_URL=postgresql://...
```

Load before running Claude:
```bash
source .env
claude
```

---

## Workflows

### Plan Mode Workflow

**Purpose:** Design before implementing

**Steps:**
1. Start Claude with `shift+tab` (twice)
2. Describe your goal
3. Claude creates plan
4. Review and iterate on plan
5. Approve plan
6. Switch to auto-accept mode
7. Claude executes autonomously

**When to use:** Any non-trivial feature or refactor

**Benefits:**
- Reduces back-and-forth
- Catches issues early
- Clear roadmap
- Can review before execution

---

### PR Creation Workflow

**Option 1: Slash Command**
```bash
claude
> /commit-push-pr
```

**Option 2: Manual**
```bash
claude
> "Review my changes, create a commit, and open a PR"
```

**What happens:**
1. Reviews staged and unstaged changes
2. Suggests commit message
3. Creates commit
4. Pushes to remote
5. Opens PR with description

---

### Background Execution

**Purpose:** Let Claude work while you do other things

**Option 1: Background Agent**
```bash
claude --agent subagents/build-validator.md &
```

**Option 2: Skip Permissions**
```bash
claude --permission-mode=dontAsk
# or for fully unattended
claude --dangerously-skip-permissions
```

**⚠️ Safety:**
- Only in sandboxed environments
- Always use version control
- Review changes after

**Monitoring:**
- Enable notifications
- Check terminal occasionally
- Use `jobs` to see running processes

---

### Parallel Sessions

**Setup:**
1. Open 5+ terminal tabs/windows
2. Number them (1-5)
3. Run Claude in each
4. Enable notifications

**Benefits:**
- Work on multiple features simultaneously
- Background agents run independently
- Notifications alert when input needed

**Tip:** Use iTerm2 or tmux for session management

---

### Verification Workflow

**After making changes:**

**Option 1: Manual**
```bash
claude
> "Run the build validator to check everything"
```

**Option 2: Subagent**
```bash
claude --agent subagents/build-validator.md
```

**What it checks:**
- Type errors
- Lint issues
- Test failures
- Build errors

**Why important:**
> "Giving Claude a way to verify its work will 2-3x the quality"

---

## Advanced Usage

### Custom Permissions by Project Type

**Node.js:**
```json
{
  "allow": [
    "Bash(npm:*)",
    "Bash(npx:*)",
    "Bash(node:*)",
    "Bash(tsc:*)",
    "Bash(jest:*)"
  ]
}
```

**Python:**
```json
{
  "allow": [
    "Bash(python:*)",
    "Bash(pip:*)",
    "Bash(pytest:*)",
    "Bash(black:*)",
    "Bash(ruff:*)"
  ]
}
```

**Rust:**
```json
{
  "allow": [
    "Bash(cargo:*)",
    "Bash(rustc:*)",
    "Bash(rustfmt:*)"
  ]
}
```

---

### Multi-Formatter Setup

**Configuration:** `.claude/hooks.json`

```json
{
  "PostToolUse": [
    {
      "name": "format-ts",
      "match": {
        "tool": "edit_file",
        "filePatterns": ["**/*.ts", "**/*.tsx"]
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

---

### Team Knowledge (CLAUDE.md)

**Purpose:** Shared context across team and sessions

**What to include:**
- Build commands
- Test commands
- Architecture decisions
- Common mistakes
- Code conventions
- Deployment process

**Example:**

```markdown
# Project Intelligence

## Don't: Use `any` types
**Why:** Breaks type safety
**Instead:** Use proper types or `unknown`

## Architecture: Feature-based folders
**Structure:**
```
src/
  features/
    auth/
      components/
      hooks/
      utils/
    dashboard/
      ...
```

## Testing: Always test edge cases
**Requirements:**
- Empty states
- Error states
- Loading states
```

**Maintenance:**
- Update when Claude makes mistakes
- Add during code review
- Whole team maintains it
- Check into git

---

### Teleport (Terminal ↔ Web)

**Purpose:** Move sessions between terminal and web UI

**Terminal → Web:**
```bash
claude --teleport
```

**Web → Terminal:**
Use the export/teleport option in claude.ai/code

**Use cases:**
- Start on mobile, finish on desktop
- Switch between interfaces
- Share session with team

---

### Session Management

**List running sessions:**
```bash
claude --list-sessions
```

**Resume session:**
```bash
claude --resume <session-id>
```

**Export session:**
```bash
claude --export <session-id> > session.json
```

**Import session:**
```bash
claude --import session.json
```

---

## Best Practices

### 1. Always Use Plan Mode First
- For any non-trivial task
- Reduces iterations
- Catches issues early

### 2. Verify Everything
- Use subagents
- Run tests
- Check builds
- Review changes

### 3. Maintain CLAUDE.md
- Update when mistakes happen
- Document decisions
- Share team knowledge

### 4. Start Conservative
- Begin with manual approvals
- Add pre-approved commands gradually
- Test in safe environments first

### 5. Use Version Control
- Commit before major changes
- Easy to revert
- Track what Claude changed

### 6. Leverage Slash Commands
- Create for repeated workflows
- Include pre-computed context
- Share with team

### 7. Enable Notifications
- For parallel sessions
- For background tasks
- For long-running operations

---

## Troubleshooting

### Claude asks for permission too often

**Solution:** Add more commands to `allow` list in settings.json

### Hooks not running

**Checklist:**
- Hook command installed? (`prettier`, `black`, etc.)
- File pattern matches? (check glob pattern)
- Silent mode hiding errors? (set `"silent": false`)

### MCP server not working

**Checklist:**
- API token set? (`echo $GITHUB_TOKEN`)
- Token has correct scopes?
- Network connectivity?
- Check Claude logs: `~/.claude/logs/`

### Changes not formatted

**Checklist:**
- Formatter installed?
- Correct file pattern in hooks.json?
- Run manually to test: `prettier --write file.ts`

### Subagent fails

**Solutions:**
- Check subagent prerequisites (tests exist, build command works)
- Run commands manually first
- Review subagent script for project-specific paths

---

## Performance Tips

### Reduce Token Usage
- Use subagents for complex workflows
- Pre-compute context in slash commands
- Use CLAUDE.md for persistent knowledge

### Speed Up Responses
- Use Sonnet for simple tasks
- Lower thinking budget for straightforward work
- Pre-approve more commands

### Improve Quality
- Use Opus for complex tasks
- High thinking budget
- Plan Mode for everything
- Verification subagents

### Maximize Autonomy
- Pre-approve safe commands
- Use hooks for automatic formatting
- Background agents for long tasks
- Parallel sessions for multiple tasks

---

## Summary

The Claude Code Optimization Kit provides:

1. **Configuration** - Settings for permissions, model, thinking
2. **Commands** - Reusable prompts for common tasks
3. **Subagents** - Autonomous task runners
4. **Hooks** - Automatic actions after Claude's edits
5. **MCP Servers** - External tool integrations
6. **Workflows** - Proven patterns for maximum efficiency

**Goal:** Reduce user interactions, increase Claude autonomy, improve output quality.

**Getting Started:** Run `./setup.sh` and follow the wizard.
