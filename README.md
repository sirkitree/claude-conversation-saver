# Claude Conversation Saver Plugin

A Claude Code plugin that automatically saves and indexes your conversations. Never lose context again.

## Features

- 🔄 **Auto-saves conversations** after each Claude response in real-time
- 📝 **Converts to markdown** - readable conversation transcripts
- 🔍 **Powerful search** - find past conversations instantly
- 📊 **Browse recent** - quickly review recent sessions
- 💾 **Full metadata** - preserves session info and timestamps
- ⚡ **Slash commands** - convenient `/convo-*` commands

## Installation

### Quick Install (Plugin Method - Recommended)

**Step 1:** Add the marketplace:
```bash
/plugin marketplace add https://github.com/sirkitree/claude-conversation-saver
```

**Step 2:** Restart Claude Code to load the plugin.

That's it! The plugin will automatically:
- Install the Stop hook (saves after each response)
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

Once installed, conversations are automatically saved after each Claude response. No action needed!

Each response creates/updates three files in `~/.claude/conversation-logs/`:
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

1. **Stop Hook**: After each Claude response, the hook automatically triggers
2. **Capture Transcript**: Copies the current conversation's JSONL transcript to `~/.claude/conversation-logs/`
3. **Parse to Markdown**: Python parser converts JSONL to readable markdown format in real-time
4. **Save Metadata**: Session information preserved in a separate JSON file
5. **Search Anytime**: Use slash commands or search script to find conversations

## Important: Real-Time Saving Behavior

The `Stop` hook fires **after every Claude response**, providing real-time conversation backups:

- ✅ Conversations are saved continuously as they evolve
- ✅ Each response updates the conversation files with the latest content
- ✅ Never lose work - even if Claude Code crashes, your conversation is preserved
- ✅ Great for long sessions - you can review progress at any time

This means you always have an up-to-date snapshot of your conversation, no need to wait for the session to end!

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
│   │   ├── stop.sh              # Real-time auto-save hook
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
- Check Claude Code output after responses for any errors
- Ensure the Stop hook is properly configured in `~/.claude/plugins/conversation-saver/plugin.json`

**Parser failing?**
- Ensure Python 3 is installed: `python3 --version`
- Reinstall plugin: `/plugin reinstall conversation-saver`

**Search not finding anything?**
- Verify conversations exist: `ls -lh ~/.claude/conversation-logs/`
- Try `/convo-list` to see all available conversations
- Make sure you've had at least one Claude response after installing the plugin

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
