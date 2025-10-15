# Claude Conversation Saver Plugin

A Claude Code plugin that automatically saves and indexes your conversations. Never lose context again.

## Features

- 🔄 **Auto-saves conversations** when Claude Code sessions end
- 📝 **Converts to markdown** - readable conversation transcripts
- 🔍 **Powerful search** - find past conversations instantly
- 📊 **Browse recent** - quickly review recent sessions
- 💾 **Full metadata** - preserves session info and timestamps
- ⚡ **Slash commands** - convenient `/convo-*` commands

## Installation

### Quick Install (Plugin Method - Recommended)

```bash
/plugin add https://github.com/sirkitree/claude-conversation-saver
```

That's it! The plugin will automatically:
- Install the SessionEnd hook
- Set up the search scripts
- Add slash commands: `/convo-search`, `/convo-list`, `/convo-recent`

### Prerequisites

Make sure you have:
- `jq` - JSON processor
- `python3` - For parsing conversations

```bash
# Termux
pkg install jq python -y

# macOS
brew install jq python3

# Debian/Ubuntu
sudo apt install jq python3
```

## Usage

### Automatic Saving

Once installed, conversations are automatically saved when Claude Code sessions end. No action needed!

Each session creates three files in `~/.claude/conversation-logs/`:
- `conversation_YYYY-MM-DD_HH-MM-SS.jsonl` - Raw conversation data
- `conversation_YYYY-MM-DD_HH-MM-SS.md` - Human-readable transcript
- `session_YYYY-MM-DD_HH-MM-SS.json` - Session metadata

### Slash Commands

The plugin adds three convenient slash commands:

**Search conversations:**
```
/convo-search hooks
```

**List all saved conversations:**
```
/convo-list
```

**Show recent conversations:**
```
/convo-recent 10
```

### Direct Script Usage

You can also use the search script directly:

```bash
# List all conversations
~/.claude/plugins/conversation-saver/scripts/search-conversations.sh --list

# Show recent conversations
~/.claude/plugins/conversation-saver/scripts/search-conversations.sh --recent 5

# Search for a term
~/.claude/plugins/conversation-saver/scripts/search-conversations.sh "hooks"

# Search with more context
~/.claude/plugins/conversation-saver/scripts/search-conversations.sh "git commit" --context 10
```

## How It Works

1. **SessionEnd Hook**: When a Claude Code session ends, the hook automatically triggers
2. **Capture Transcript**: Copies the session's JSONL transcript to `~/.claude/conversation-logs/`
3. **Parse to Markdown**: Python parser converts JSONL to readable markdown format
4. **Save Metadata**: Session information preserved in a separate JSON file
5. **Search Anytime**: Use slash commands or search script to find conversations

## Important: Session Behavior

The `SessionEnd` hook only fires when a session **terminates**, not when you exit and resume:

- ✅ Sessions that are resumed **don't** trigger the hook (keeps your context alive!)
- ✅ Only fully ended sessions are saved
- ✅ If you always resume, you'll have fewer but longer, more complete conversations

This is actually a good thing - it encourages long-running sessions while still capturing everything when they end.

## Plugin Structure

```
claude-conversation-saver/
├── .claude-plugin/
│   ├── plugin.json              # Plugin manifest
│   ├── commands/
│   │   ├── convo-search.md      # Search slash command
│   │   ├── convo-list.md        # List slash command
│   │   └── convo-recent.md      # Recent slash command
│   ├── hooks/
│   │   ├── session-end.sh       # Auto-save hook
│   │   └── parse-conversation.py # JSONL to markdown converter
│   └── scripts/
│       └── search-conversations.sh # Search utility
└── README.md
```

## Saved Files Location

```
~/.claude/conversation-logs/
├── conversation_2025-10-14_20-47-31.jsonl
├── conversation_2025-10-14_20-47-31.md
├── session_2025-10-14_20-47-31.json
└── ...
```

## Troubleshooting

**Hook not triggering?**
- Verify scripts are executable: `/plugin reinstall conversation-saver`
- Check that sessions are fully ending (not being resumed)
- Look for errors in Claude Code output when session ends

**Parser failing?**
- Ensure Python 3 is installed: `python3 --version`
- Reinstall plugin: `/plugin reinstall conversation-saver`

**Search not finding anything?**
- Verify conversations exist: `ls -lh ~/.claude/conversation-logs/`
- Try `/convo-list` to see all available conversations
- Make sure at least one session has fully ended

**Slash commands not working?**
- Restart Claude Code after plugin installation
- Verify plugin is installed: `/plugin list`

## Contributing

Contributions welcome! Feel free to:
- Report bugs via GitHub Issues
- Suggest features
- Submit pull requests
- Share your use cases

## License

MIT License - feel free to use and modify as needed.

## Related

- [Blog post](https://sirkitree.net/blog/claude-code-auto-save-conversations) - Full story and background
- [Claude Code Docs](https://docs.claude.com/en/docs/claude-code) - Official documentation
- [Plugin Docs](https://docs.claude.com/en/docs/claude-code/plugins) - How to create plugins

## Credits

Built with Claude Code itself. Meta inception achieved. 🚀

---

*Never lose a conversation again. Install once, search forever.*
