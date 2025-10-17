#!/bin/bash
# Wrapper script that calls the conversation-logger skill's search script

SKILL_SCRIPT="$HOME/.claude/skills/conversation-logger/scripts/search-conversations.sh"

if [ -f "$SKILL_SCRIPT" ]; then
    # Skill is installed, use it
    bash "$SKILL_SCRIPT" "$@"
else
    # Skill not found, provide helpful message
    echo "Error: conversation-logger skill not found at $SKILL_SCRIPT" >&2
    echo "Please install the skill: cd ~/.claude/skills && git clone https://github.com/sirkitree/conversation-logger.git" >&2
    exit 1
fi
