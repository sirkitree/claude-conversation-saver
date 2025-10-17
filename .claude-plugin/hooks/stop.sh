#!/bin/bash
# Stop hook - saves conversation after each Claude response
# Calls the conversation-logger skill for actual save logic

# Read hook context from stdin
HOOK_DATA=$(cat)

# Extract session info from the hook data
TRANSCRIPT_PATH=$(echo "$HOOK_DATA" | jq -r '.transcript_path // empty' 2>/dev/null)
SESSION_ID=$(echo "$HOOK_DATA" | jq -r '.session_id // "unknown"' 2>/dev/null)

# Check if we have a valid transcript path
if [ -z "$TRANSCRIPT_PATH" ] || [ ! -f "$TRANSCRIPT_PATH" ]; then
    echo "Warning: No valid transcript path found, skipping save" >&2
    exit 0
fi

# Call the conversation-logger skill's save script
SKILL_SCRIPT="$HOME/.claude/skills/conversation-logger/scripts/save-conversation.sh"

if [ -f "$SKILL_SCRIPT" ]; then
    # Skill is installed, use it
    bash "$SKILL_SCRIPT" "$TRANSCRIPT_PATH" "$SESSION_ID"
else
    # Skill not found, provide helpful message
    echo "Warning: conversation-logger skill not found at $SKILL_SCRIPT" >&2
    echo "Please install the skill: cd ~/.claude/skills && git clone https://github.com/sirkitree/conversation-logger.git" >&2

    # Fall back to basic save (just copy the JSONL)
    LOG_DIR="$HOME/.claude/conversation-logs"
    mkdir -p "$LOG_DIR"
    TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
    cp "$TRANSCRIPT_PATH" "$LOG_DIR/conversation_$TIMESTAMP.jsonl"
    echo "Conversation saved to: $LOG_DIR/conversation_$TIMESTAMP.jsonl" >&2
fi

exit 0
