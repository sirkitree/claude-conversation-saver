#!/bin/bash
# Stop hook - saves conversation after each Claude response

LOG_DIR="$HOME/.claude/conversation-logs"
mkdir -p "$LOG_DIR"

# Generate timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Read hook context from stdin
HOOK_DATA=$(cat)

# Save the raw hook data
echo "$HOOK_DATA" > "$LOG_DIR/session_$TIMESTAMP.json"

# Extract session info from the hook data
TRANSCRIPT_PATH=$(echo "$HOOK_DATA" | jq -r '.transcript_path // empty' 2>/dev/null)
SESSION_ID=$(echo "$HOOK_DATA" | jq -r '.session_id // "unknown"' 2>/dev/null)

# If we have a transcript path, copy and format the conversation
if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    # Copy the full transcript
    cp "$TRANSCRIPT_PATH" "$LOG_DIR/conversation_$TIMESTAMP.jsonl"

    # Use Python parser if available, otherwise fall back to basic format
    PARSER_PATH="${PLUGIN_DIR-}/hooks/parse-conversation.py"
    if command -v python3 &> /dev/null && [ -f "$PARSER_PATH" ]; then
        python3 "$PARSER_PATH" \
            "$LOG_DIR/conversation_$TIMESTAMP.jsonl" \
            "$LOG_DIR/conversation_$TIMESTAMP.md" \
            "$SESSION_ID" 2>/dev/null || true
    else
        # Fallback: just copy the JSONL with basic metadata
        MD_FILE="$LOG_DIR/conversation_$TIMESTAMP.md"
        echo "# Conversation Log" > "$MD_FILE"
        echo "Date: $(date '+%Y-%m-%d %H:%M:%S')" >> "$MD_FILE"
        echo "Session ID: $SESSION_ID" >> "$MD_FILE"
        echo "" >> "$MD_FILE"
        echo "Note: Install python3 for formatted output." >> "$MD_FILE"
        echo "Raw conversation available at: conversation_$TIMESTAMP.jsonl" >> "$MD_FILE"
    fi
fi

exit 0
