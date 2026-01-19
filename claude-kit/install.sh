#!/bin/bash
# Claude Code Optimization Kit Installer
# Usage: ./install.sh [target-directory]

set -e

TARGET="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing Claude Code optimizations to: $TARGET"

# Create directories
mkdir -p "$TARGET/.claude/commands"
mkdir -p "$TARGET/subagents"

# Copy .claude configs
cp "$SCRIPT_DIR/.claude/settings.json" "$TARGET/.claude/"
cp "$SCRIPT_DIR/.claude/hooks.json" "$TARGET/.claude/"
cp "$SCRIPT_DIR/.claude/commands/"*.md "$TARGET/.claude/commands/"

# Copy subagents
cp "$SCRIPT_DIR/subagents/"*.md "$TARGET/subagents/"

# Copy MCP config (user should customize)
cp "$SCRIPT_DIR/.mcp.json" "$TARGET/"

# Copy CLAUDE.md only if it doesn't exist
if [ ! -f "$TARGET/CLAUDE.md" ]; then
    cp "$SCRIPT_DIR/CLAUDE.md" "$TARGET/"
    echo "Created CLAUDE.md - customize for your project"
else
    echo "CLAUDE.md exists - skipped (won't overwrite)"
fi

# Add to .gitignore if exists
if [ -f "$TARGET/.gitignore" ]; then
    if ! grep -q ".claude/settings.local.json" "$TARGET/.gitignore" 2>/dev/null; then
        echo "" >> "$TARGET/.gitignore"
        echo "# Claude Code local overrides" >> "$TARGET/.gitignore"
        echo ".claude/settings.local.json" >> "$TARGET/.gitignore"
    fi
fi

echo ""
echo "Installed:"
echo "  .claude/settings.json    - Pre-allowed permissions"
echo "  .claude/hooks.json       - Auto-format on edit"
echo "  .claude/commands/        - Slash commands"
echo "  subagents/               - Autonomous task runners"
echo "  .mcp.json                - External tool config (customize tokens)"
echo ""
echo "Next steps:"
echo "  1. Edit CLAUDE.md for your project"
echo "  2. Add API tokens to .mcp.json"
echo "  3. Review .claude/settings.json permissions"
echo "  4. Start Claude with: shift+tab twice (plan mode)"
