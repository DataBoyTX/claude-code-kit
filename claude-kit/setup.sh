#!/bin/bash
# Claude Code Optimization Kit - Interactive Setup
# Usage: ./setup.sh [target-directory]

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print helpers
print_header() {
    echo -e "\n${MAGENTA}═══════════════════════════════════════════════════════${NC}"
    echo -e "${MAGENTA}  $1${NC}"
    echo -e "${MAGENTA}═══════════════════════════════════════════════════════${NC}\n"
}

print_step() {
    echo -e "${CYAN}➜${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Ask yes/no with default
ask_yn() {
    local prompt="$1"
    local default="${2:-y}"
    local response

    if [ "$default" = "y" ]; then
        prompt="$prompt [Y/n]"
    else
        prompt="$prompt [y/N]"
    fi

    read -p "$(echo -e ${CYAN}?${NC}) $prompt: " response
    response="${response:-$default}"
    [[ "$response" =~ ^[Yy] ]]
}

# Ask for input with default
ask_input() {
    local prompt="$1"
    local default="$2"
    local response

    if [ -n "$default" ]; then
        prompt="$prompt (default: $default)"
    fi

    read -p "$(echo -e ${CYAN}?${NC}) $prompt: " response
    echo "${response:-$default}"
}

# Ask for choice from list
ask_choice() {
    local prompt="$1"
    shift
    local options=("$@")

    echo -e "${CYAN}?${NC} $prompt" >&2
    for i in "${!options[@]}"; do
        echo "  $((i+1)). ${options[$i]}" >&2
    done

    local choice
    while true; do
        read -p "$(echo -e ${CYAN}?${NC}) Enter choice [1-${#options[@]}]: " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#options[@]}" ]; then
            echo "${options[$((choice-1))]}"
            return
        fi
        echo -e "${RED}✗${NC} Invalid choice. Please enter a number between 1 and ${#options[@]}" >&2
    done
}

# Main setup
main() {
    clear
    print_header "Claude Code Optimization Kit - Setup Wizard"

    echo "This wizard will help you configure Claude Code for maximum performance."
    echo "You can press Enter to accept defaults shown in parentheses."
    echo ""

    # Step 1: Target directory
    print_header "Step 1: Installation Target"

    TARGET="${1:-.}"
    if [ "$TARGET" = "." ]; then
        if ask_yn "Install to current directory ($(pwd))?" "y"; then
            TARGET="$(pwd)"
        else
            TARGET=$(ask_input "Enter target directory path")
        fi
    fi

    # Expand tilde in target path
    TARGET="${TARGET/#\~/$HOME}"

    print_info "Installing to: $TARGET"

    # Verify target
    if [ ! -d "$TARGET" ]; then
        if ask_yn "Directory doesn't exist. Create it?" "y"; then
            mkdir -p "$TARGET"
            print_success "Created directory: $TARGET"
        else
            print_error "Setup cancelled"
            exit 1
        fi
    fi

    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Step 2: Project Type Detection
    print_header "Step 2: Project Configuration"

    PROJECT_TYPE="unknown"
    PACKAGE_MANAGER="unknown"
    FORMATTER="unknown"

    # Detect project type
    if [ -f "$TARGET/package.json" ]; then
        PROJECT_TYPE="node"
        print_info "Detected Node.js project"

        # Detect package manager
        if [ -f "$TARGET/pnpm-lock.yaml" ]; then
            PACKAGE_MANAGER="pnpm"
        elif [ -f "$TARGET/yarn.lock" ]; then
            PACKAGE_MANAGER="yarn"
        elif [ -f "$TARGET/bun.lockb" ]; then
            PACKAGE_MANAGER="bun"
        else
            PACKAGE_MANAGER="npm"
        fi
        print_info "Detected package manager: $PACKAGE_MANAGER"

        # Check for formatter
        if command -v prettier &> /dev/null || grep -q "prettier" "$TARGET/package.json" 2>/dev/null; then
            FORMATTER="prettier"
        fi
    elif [ -f "$TARGET/requirements.txt" ] || [ -f "$TARGET/setup.py" ] || [ -f "$TARGET/pyproject.toml" ]; then
        PROJECT_TYPE="python"
        print_info "Detected Python project"

        # Check for formatter
        if command -v black &> /dev/null; then
            FORMATTER="black"
        elif command -v ruff &> /dev/null; then
            FORMATTER="ruff"
        fi
    elif [ -f "$TARGET/Cargo.toml" ]; then
        PROJECT_TYPE="rust"
        FORMATTER="rustfmt"
        print_info "Detected Rust project"
    elif [ -f "$TARGET/go.mod" ]; then
        PROJECT_TYPE="go"
        FORMATTER="gofmt"
        print_info "Detected Go project"
    fi

    # Ask for confirmation/override
    echo ""
    CONFIRMED_TYPE=$(ask_choice "Confirm project type:" \
        "Node.js/TypeScript" \
        "Python" \
        "Go" \
        "Rust" \
        "Java/Kotlin" \
        "Other/Mixed")

    # Step 3: Model Selection
    print_header "Step 3: Claude Model Selection"

    echo "Opus 4.6: Most capable, best for complex work (recommended)"
    echo "Sonnet 4.6: Fast and capable, good balance"
    echo "Haiku 4.5: Fastest and cheapest, good for simple tasks"
    echo ""

    MODEL_CHOICE=$(ask_choice "Select Claude model:" \
        "Opus 4.6 (recommended)" \
        "Sonnet 4.6" \
        "Haiku 4.5")

    if [[ "$MODEL_CHOICE" == *"Opus"* ]]; then
        MODEL="claude-opus-4-6"
        THINKING_DEFAULT="high"
    elif [[ "$MODEL_CHOICE" == *"Sonnet"* ]]; then
        MODEL="claude-sonnet-4-6"
        THINKING_DEFAULT="medium"
    else
        MODEL="claude-haiku-4-5-20251001"
        THINKING_DEFAULT="low"
    fi

    # Thinking budget
    THINKING_BUDGET=$(ask_choice "Extended thinking budget:" \
        "High (most thorough)" \
        "Medium (balanced)" \
        "Low (faster)" \
        "Disabled")

    case "$THINKING_BUDGET" in
        *"High"*) THINKING_BUDGET="high" ;;
        *"Medium"*) THINKING_BUDGET="medium" ;;
        *"Low"*) THINKING_BUDGET="low" ;;
        *"Disabled"*) THINKING_BUDGET="disabled" ;;
    esac

    # Step 4: Permissions
    print_header "Step 4: Permission Configuration"

    echo "Pre-allowing safe commands reduces interruptions."
    echo "You can customize this later in .claude/settings.json"
    echo ""

    AUTO_ACCEPT_EDITS="false"
    if ask_yn "Auto-accept file edits? (risky but faster)" "n"; then
        AUTO_ACCEPT_EDITS="true"
    fi

    # Additional commands
    CUSTOM_COMMANDS=""
    echo ""
    if ask_yn "Add project-specific commands to allow list?" "n"; then
        print_info "Enter commands one per line (e.g., 'make', 'cargo', 'go'). Empty line to finish."
        while true; do
            cmd=$(ask_input "Command to allow (or press Enter to finish)" "")
            [ -z "$cmd" ] && break
            CUSTOM_COMMANDS="${CUSTOM_COMMANDS}      \"Bash($cmd:*)\",
"
        done
    fi

    # Step 5: Hooks (Auto-formatting)
    print_header "Step 5: Hooks Configuration"

    echo "Hooks run automatically after Claude makes changes."
    echo "Common use: auto-format files after editing"
    echo ""

    ENABLE_HOOKS="false"
    HOOK_CONFIG=""

    if ask_yn "Enable auto-formatting hooks?" "y"; then
        ENABLE_HOOKS="true"

        # Detect or ask for formatter
        if [ "$FORMATTER" = "unknown" ]; then
            FORMATTER_CHOICE=$(ask_choice "Select formatter:" \
                "prettier (JS/TS)" \
                "black (Python)" \
                "ruff (Python)" \
                "rustfmt (Rust)" \
                "gofmt (Go)" \
                "None")

            case "$FORMATTER_CHOICE" in
                *"prettier"*) FORMATTER="prettier" ;;
                *"black"*) FORMATTER="black" ;;
                *"ruff"*) FORMATTER="ruff" ;;
                *"rustfmt"*) FORMATTER="rustfmt" ;;
                *"gofmt"*) FORMATTER="gofmt" ;;
                *) FORMATTER="none" ;;
            esac
        else
            if ! ask_yn "Use detected formatter ($FORMATTER)?" "y"; then
                FORMATTER="none"
            fi
        fi
    fi

    # Step 6: MCP Servers
    print_header "Step 6: MCP Server Configuration"

    echo "MCP servers connect Claude to external tools and services."
    echo "You can configure API tokens now or add them later to .mcp.json"
    echo ""

    declare -A MCP_SERVERS

    if ask_yn "Enable MCP servers?" "y"; then
        # Always enable memory and fetch (no auth needed)
        MCP_SERVERS["memory"]="true"
        MCP_SERVERS["fetch"]="true"

        # GitHub
        if ask_yn "  Enable GitHub integration?" "y"; then
            MCP_SERVERS["github"]="true"
            if ask_yn "    Configure GitHub token now?" "n"; then
                GITHUB_TOKEN=$(ask_input "    GitHub token (PAT)")
            else
                print_info "    Add GITHUB_TOKEN to .mcp.json later"
            fi
        fi

        # Slack
        if ask_yn "  Enable Slack integration?" "n"; then
            MCP_SERVERS["slack"]="true"
            if ask_yn "    Configure Slack tokens now?" "n"; then
                SLACK_BOT_TOKEN=$(ask_input "    Slack bot token")
                SLACK_TEAM_ID=$(ask_input "    Slack team ID")
            else
                print_info "    Add SLACK_BOT_TOKEN and SLACK_TEAM_ID to .mcp.json later"
            fi
        fi

        # PostgreSQL
        if ask_yn "  Enable PostgreSQL integration?" "n"; then
            MCP_SERVERS["postgres"]="true"
            if ask_yn "    Configure database URL now?" "n"; then
                DATABASE_URL=$(ask_input "    Database URL")
            else
                print_info "    Add DATABASE_URL to .mcp.json later"
            fi
        fi

        # Brave Search
        if ask_yn "  Enable Brave Search?" "n"; then
            MCP_SERVERS["brave-search"]="true"
            if ask_yn "    Configure Brave API key now?" "n"; then
                BRAVE_API_KEY=$(ask_input "    Brave API key")
            else
                print_info "    Add BRAVE_API_KEY to .mcp.json later"
            fi
        fi

        # Sentry
        if ask_yn "  Enable Sentry integration?" "n"; then
            MCP_SERVERS["sentry"]="true"
            if ask_yn "    Configure Sentry now?" "n"; then
                SENTRY_AUTH_TOKEN=$(ask_input "    Sentry auth token")
                SENTRY_ORG=$(ask_input "    Sentry organization")
            else
                print_info "    Add SENTRY_AUTH_TOKEN and SENTRY_ORG to .mcp.json later"
            fi
        fi
    fi

    # Step 7: Notifications
    print_header "Step 7: Notification Settings"

    NOTIFICATIONS_ENABLED="true"
    NOTIFICATIONS_SOUND="true"

    if ! ask_yn "Enable desktop notifications?" "y"; then
        NOTIFICATIONS_ENABLED="false"
        NOTIFICATIONS_SOUND="false"
    else
        if ! ask_yn "Enable notification sounds?" "y"; then
            NOTIFICATIONS_SOUND="false"
        fi
    fi

    # Step 8: Installation
    print_header "Step 8: Installing Files"

    print_step "Creating directories..."
    mkdir -p "$TARGET/.claude/commands"
    mkdir -p "$TARGET/subagents"

    print_step "Copying slash commands..."
    for file in "$SCRIPT_DIR/.claude/commands"/*.md; do
        [ -f "$file" ] && cp "$file" "$TARGET/.claude/commands/"
    done
    print_success "Installed slash commands: /commit-push-pr, /debug, /plan, /review, /test"

    print_step "Copying subagents..."
    for file in "$SCRIPT_DIR/subagents"/*.md; do
        [ -f "$file" ] && cp "$file" "$TARGET/subagents/"
    done
    print_success "Installed subagents: build-validator, code-architect, code-simplifier, oncall-guide, verify-app"

    # Generate settings.json
    print_step "Generating .claude/settings.json..."
    cat > "$TARGET/.claude/settings.json" << EOF
{
  "\$schema": "https://code.claude.com/settings-schema.json",
  "permissions": {
    "allow": [
      "Bash(npm:*)",
      "Bash(npx:*)",
      "Bash(pnpm:*)",
      "Bash(yarn:*)",
      "Bash(bun:*)",
      "Bash(node:*)",
      "Bash(git:*)",
      "Bash(gh:*)",
      "Bash(curl:*)",
      "Bash(cat:*)",
      "Bash(ls:*)",
      "Bash(head:*)",
      "Bash(tail:*)",
      "Bash(grep:*)",
      "Bash(find:*)",
      "Bash(wc:*)",
      "Bash(sort:*)",
      "Bash(uniq:*)",
      "Bash(diff:*)",
      "Bash(echo:*)",
      "Bash(mkdir:*)",
      "Bash(cp:*)",
      "Bash(mv:*)",
      "Bash(rm:*)",
      "Bash(touch:*)",
      "Bash(chmod:*)",
      "Bash(pwd:*)",
      "Bash(cd:*)",
      "Bash(which:*)",
      "Bash(env:*)",
      "Bash(export:*)",
      "Bash(date:*)",
      "Bash(sleep:*)",
      "Bash(kill:*)",
      "Bash(ps:*)",
      "Bash(lsof:*)",
      "Bash(tree:*)",
      "Bash(jq:*)",
      "Bash(sed:*)",
      "Bash(awk:*)",
      "Bash(tsc:*)",
      "Bash(eslint:*)",
      "Bash(prettier:*)",
      "Bash(jest:*)",
      "Bash(vitest:*)",
      "Bash(pytest:*)",
      "Bash(python:*)",
      "Bash(python3:*)",
      "Bash(pip:*)",
      "Bash(pip3:*)",
      "Bash(cargo:*)",
      "Bash(rustc:*)",
      "Bash(go:*)",
      "Bash(make:*)",
      "Bash(docker:*)",
      "Bash(docker-compose:*)",
      "Bash(bq:*)",
${CUSTOM_COMMANDS}      "Read(*)",
      "Write(*)"
    ],
    "deny": [
      "Bash(sudo:*)",
      "Bash(su:*)",
      "Bash(rm -rf /)",
      "Bash(rm -rf /*)",
      "Bash(:(){ :|:& };:)",
      "Bash(> /dev/sda)",
      "Bash(dd if=/dev/zero of=/dev/sda)",
      "Bash(mkfs.*)"
    ]
  },
  "model": "$MODEL",
  "thinking": {
    "enabled": $([ "$THINKING_BUDGET" = "disabled" ] && echo "false" || echo "true"),
    "budget": "$THINKING_BUDGET"
  },
  "autoAcceptEdits": $AUTO_ACCEPT_EDITS,
  "notifications": {
    "enabled": $NOTIFICATIONS_ENABLED,
    "sound": $NOTIFICATIONS_SOUND
  }
}
EOF
    print_success "Generated settings.json with $MODEL and $THINKING_BUDGET thinking"

    # Generate hooks.json
    print_step "Generating .claude/hooks.json..."

    if [ "$ENABLE_HOOKS" = "true" ] && [ "$FORMATTER" != "none" ]; then
        case "$FORMATTER" in
            prettier)
                HOOK_COMMAND="npx prettier --write {{filepath}}"
                HOOK_PATTERN='**/*.{ts,tsx,js,jsx,json,md,css,scss}'
                ;;
            black)
                HOOK_COMMAND="black {{filepath}}"
                HOOK_PATTERN='**/*.py'
                ;;
            ruff)
                HOOK_COMMAND="ruff format {{filepath}}"
                HOOK_PATTERN='**/*.py'
                ;;
            rustfmt)
                HOOK_COMMAND="rustfmt {{filepath}}"
                HOOK_PATTERN='**/*.rs'
                ;;
            gofmt)
                HOOK_COMMAND="gofmt -w {{filepath}}"
                HOOK_PATTERN='**/*.go'
                ;;
        esac

        cat > "$TARGET/.claude/hooks.json" << EOF
{
  "\$schema": "https://code.claude.com/hooks-schema.json",
  "PostToolUse": [
    {
      "name": "format-on-edit",
      "match": {
        "tool": "edit_file",
        "filePatterns": ["$HOOK_PATTERN"]
      },
      "command": "$HOOK_COMMAND",
      "silent": true,
      "description": "Auto-format files with $FORMATTER after editing"
    }
  ]
}
EOF
        print_success "Configured auto-formatting with $FORMATTER"
    else
        cat > "$TARGET/.claude/hooks.json" << EOF
{
  "\$schema": "https://code.claude.com/hooks-schema.json",
  "PostToolUse": []
}
EOF
        print_success "Created empty hooks.json (no auto-formatting)"
    fi

    # Generate .mcp.json
    print_step "Generating .mcp.json..."
    cat > "$TARGET/.mcp.json" << EOF
{
  "\$schema": "https://code.claude.com/mcp-schema.json",
  "mcpServers": {
EOF

    # Add enabled MCP servers
    FIRST_SERVER=true
    for server in memory fetch github slack postgres brave-search sentry; do
        if [ "${MCP_SERVERS[$server]}" = "true" ]; then
            [ "$FIRST_SERVER" = false ] && echo "," >> "$TARGET/.mcp.json"
            FIRST_SERVER=false

            case "$server" in
                memory)
                    cat >> "$TARGET/.mcp.json" << 'EOF'
    "memory": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-memory"],
      "description": "Persistent memory across sessions"
    }
EOF
                    ;;
                fetch)
                    cat >> "$TARGET/.mcp.json" << 'EOF'
    "fetch": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-fetch"],
      "description": "Fetch web content and APIs"
    }
EOF
                    ;;
                github)
                    TOKEN_VAL="${GITHUB_TOKEN:-\${GITHUB_TOKEN\}}"
                    cat >> "$TARGET/.mcp.json" << EOF
    "github": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-github"],
      "env": {
        "GITHUB_TOKEN": "$TOKEN_VAL"
      },
      "description": "Interact with GitHub repositories, issues, and PRs"
    }
EOF
                    ;;
                slack)
                    BOT_TOKEN="${SLACK_BOT_TOKEN:-\${SLACK_BOT_TOKEN\}}"
                    TEAM_ID="${SLACK_TEAM_ID:-\${SLACK_TEAM_ID\}}"
                    cat >> "$TARGET/.mcp.json" << EOF
    "slack": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "$BOT_TOKEN",
        "SLACK_TEAM_ID": "$TEAM_ID"
      },
      "description": "Search and post to Slack channels"
    }
EOF
                    ;;
                postgres)
                    DB_URL="${DATABASE_URL:-\${DATABASE_URL\}}"
                    cat >> "$TARGET/.mcp.json" << EOF
    "postgres": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-postgres"],
      "env": {
        "DATABASE_URL": "$DB_URL"
      },
      "description": "Query PostgreSQL databases"
    }
EOF
                    ;;
                brave-search)
                    API_KEY="${BRAVE_API_KEY:-\${BRAVE_API_KEY\}}"
                    cat >> "$TARGET/.mcp.json" << EOF
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "$API_KEY"
      },
      "description": "Web search via Brave"
    }
EOF
                    ;;
                sentry)
                    AUTH_TOKEN="${SENTRY_AUTH_TOKEN:-\${SENTRY_AUTH_TOKEN\}}"
                    ORG="${SENTRY_ORG:-\${SENTRY_ORG\}}"
                    cat >> "$TARGET/.mcp.json" << EOF
    "sentry": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-sentry"],
      "env": {
        "SENTRY_AUTH_TOKEN": "$AUTH_TOKEN",
        "SENTRY_ORG": "$ORG"
      },
      "description": "Query Sentry for error logs and issues"
    }
EOF
                    ;;
            esac
        fi
    done

    echo "" >> "$TARGET/.mcp.json"
    echo "  }" >> "$TARGET/.mcp.json"
    echo "}" >> "$TARGET/.mcp.json"

    print_success "Generated .mcp.json with $(echo ${!MCP_SERVERS[@]} | wc -w) enabled servers"

    # Copy CLAUDE.md if it doesn't exist
    print_step "Setting up CLAUDE.md..."
    if [ ! -f "$TARGET/CLAUDE.md" ]; then
        cp "$SCRIPT_DIR/CLAUDE.md" "$TARGET/"
        print_success "Created CLAUDE.md template"
        print_warning "Customize CLAUDE.md with your project specifics"
    else
        print_info "CLAUDE.md already exists - skipped"
    fi

    # Update .gitignore
    print_step "Updating .gitignore..."
    if [ -f "$TARGET/.gitignore" ]; then
        if ! grep -q ".claude/settings.local.json" "$TARGET/.gitignore" 2>/dev/null; then
            echo "" >> "$TARGET/.gitignore"
            echo "# Claude Code local overrides" >> "$TARGET/.gitignore"
            echo ".claude/settings.local.json" >> "$TARGET/.gitignore"
            print_success "Added .claude/settings.local.json to .gitignore"
        else
            print_info ".gitignore already configured"
        fi
    else
        print_warning "No .gitignore found - consider creating one"
    fi

    # Summary
    print_header "Installation Complete!"

    echo -e "${GREEN}✓ Installed to:${NC} $TARGET"
    echo ""
    echo -e "${CYAN}Configuration Summary:${NC}"
    echo "  • Model: $MODEL"
    echo "  • Thinking: $THINKING_BUDGET"
    echo "  • Auto-accept edits: $AUTO_ACCEPT_EDITS"
    echo "  • Auto-formatting: $FORMATTER"
    echo "  • MCP servers: $(echo ${!MCP_SERVERS[@]} | tr ' ' ', ')"
    echo "  • Notifications: $NOTIFICATIONS_ENABLED"
    echo ""
    echo -e "${CYAN}Installed Files:${NC}"
    echo "  • .claude/settings.json    - Pre-allowed permissions & model config"
    echo "  • .claude/hooks.json       - Auto-formatting hooks"
    echo "  • .claude/commands/        - 5 slash commands (/commit-push-pr, /debug, /plan, /review, /test)"
    echo "  • subagents/               - 5 autonomous task runners"
    echo "  • .mcp.json                - External tool integrations"
    echo "  • CLAUDE.md                - Team knowledge base template"
    echo ""
    echo -e "${YELLOW}Next Steps:${NC}"
    echo "  1. Edit CLAUDE.md with your project details"
    echo "  2. Review .claude/settings.json permissions"
    if [ -z "$GITHUB_TOKEN" ] && [ "${MCP_SERVERS[github]}" = "true" ]; then
        echo "  3. Add GITHUB_TOKEN to .mcp.json or environment"
    fi
    if [ -z "$SLACK_BOT_TOKEN" ] && [ "${MCP_SERVERS[slack]}" = "true" ]; then
        echo "  4. Add SLACK_BOT_TOKEN and SLACK_TEAM_ID to .mcp.json"
    fi
    echo ""
    echo -e "${CYAN}Getting Started:${NC}"
    echo "  cd $TARGET"
    echo "  claude          # Start in interactive mode"
    echo "  # or press shift+tab twice to start in Plan Mode"
    echo ""
    echo -e "${CYAN}Quick Tips:${NC}"
    echo "  • Start every session with Plan Mode (shift+tab twice)"
    echo "  • Use /commit-push-pr for quick PR workflows"
    echo "  • Run subagents with: claude --agent subagents/build-validator.md"
    echo "  • Check QUICKSTART.md for more workflows"
    echo ""
    print_success "Happy coding with Claude!"
}

# Run main function
main "$@"
