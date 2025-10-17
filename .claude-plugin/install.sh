#!/bin/bash
# Install script for conversation-saver plugin
# Ensures the conversation-logger skill is installed

set -e

SKILL_DIR="$HOME/.claude/skills/conversation-logger"
SKILL_REPO="https://github.com/sirkitree/conversation-logger.git"

echo "Installing conversation-saver plugin..."

# Check if the skill is already installed
if [ -d "$SKILL_DIR" ]; then
    echo "✓ conversation-logger skill already installed at $SKILL_DIR"

    # Check if it's a git repo and offer to update
    if [ -d "$SKILL_DIR/.git" ]; then
        echo "  Pulling latest updates..."
        (cd "$SKILL_DIR" && git pull -q) || echo "  Warning: Failed to update skill"
    fi
else
    echo "Installing conversation-logger skill..."

    # Ensure skills directory exists
    mkdir -p "$HOME/.claude/skills"

    # Clone the skill repository
    if git clone -q "$SKILL_REPO" "$SKILL_DIR"; then
        echo "✓ conversation-logger skill installed successfully"
    else
        echo "✗ Failed to install conversation-logger skill"
        echo "  You can manually install it with:"
        echo "  cd ~/.claude/skills && git clone $SKILL_REPO"
        exit 1
    fi
fi

# Ensure conversation logs directory exists
mkdir -p "$HOME/.claude/conversation-logs"

echo ""
echo "✓ Plugin installation complete!"
echo ""
echo "Features:"
echo "  • Automatic conversation saving on session end"
echo "  • Slash commands: /convo-search, /convo-list, /convo-recent"
echo "  • Full conversation history search"
echo ""
echo "Conversations will be saved to: ~/.claude/conversation-logs/"
echo ""
