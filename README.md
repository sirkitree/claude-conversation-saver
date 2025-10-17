# Claude Conversation Saver Plugin

A lightweight Claude Code plugin that adds automatic conversation saving via hooks and slash commands. Built on top of the [conversation-logger skill](https://github.com/sirkitree/conversation-logger).

## What is This?

This plugin is an **automation wrapper** around the `conversation-logger` skill:
- **The skill** contains all the core logic (saving, parsing, searching)
- **This plugin** adds automatic triggers (Stop hook) and convenience commands

## Why This Approach?

**Hybrid Benefits**:
- ✅ **Single source of truth**: All core logic lives in the skill
- ✅ **Real-time automatic saves**: Plugin hook triggers after each response
- ✅ **User choice**: Use just the skill manually, or add the plugin for automation
- ✅ **Easy maintenance**: Update the skill, plugin automatically benefits
- ✅ **Cross-platform**: Skill works everywhere, plugin adds Claude Code automation

## Features

- 🔄 **Auto-saves conversations** after each Claude response in real-time
- 📝 **Converts to markdown** - readable conversation transcripts
- 🔍 **Powerful search** - find past conversations instantly
- 📊 **Browse recent** - quickly review recent sessions
- 💾 **Full metadata** - preserves session info and timestamps
- ⚡ **Slash commands** - convenient `/convo-*` commands

## Installation

### Quick Install

**Step 1:** Add the marketplace:
```bash
/plugin marketplace add https://github.com/sirkitree/claude-conversation-saver
```

**Step 2:** Restart Claude Code to load the plugin.

That's it! The plugin will automatically:
- Install the [conversation-logger skill](https://github.com/sirkitree/conversation-logger) if not present
- Set up the Stop hook (saves after each response)
- Add slash commands: `/convo-search`, `/convo-list`, `/convo-recent`

### Prerequisites

Make sure you have:
- `git` - For cloning the skill
- `jq` - JSON processor (for hook data parsing)
- `python3` - For parsing conversations to markdown

```bash
# Termux
pkg install git jq python -y

# macOS
brew install git jq python3

# Debian/Ubuntu
sudo apt install git jq python3
```

## Usage

### Automatic Saving

Once installed, conversations are automatically saved after each Claude response. No action needed!

Each response creates/updates files in `~/.claude/conversation-logs/`:
- `conversation_YYYY-MM-DD_HH-MM-SS.jsonl` - Raw conversation data
- `conversation_YYYY-MM-DD_HH-MM-SS.md` - Human-readable transcript
- `session_YYYY-MM-DD_HH-MM-SS.json` - Session metadata
- `conversation_latest.md` - Symlink to most recent conversation

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

### Using the Skill Directly

You can also use Claude naturally - the skill activates automatically when you ask:
- "Save this conversation"
- "Search conversations about docker"
- "When did we work on authentication?"

Or run the scripts directly:
```bash
# Search
~/.claude/skills/conversation-logger/scripts/search-conversations.sh "search-term"

# List all
~/.claude/skills/conversation-logger/scripts/search-conversations.sh --list

# Recent
~/.claude/skills/conversation-logger/scripts/search-conversations.sh --recent 5
```

## How It Works

1. **Plugin Installation**: Install script ensures the conversation-logger skill is present
2. **Stop Hook**: Triggers after each Claude response, calls skill's save script
3. **Skill Execution**: Skill saves JSONL, converts to markdown, creates metadata
4. **Search Anytime**: Use slash commands or skill directly to find conversations

## Architecture

```
Plugin (Automation Layer)
    ↓ calls
Skill (Core Logic)
    ↓ creates
Saved Conversations (~/.claude/conversation-logs/)
```

**Plugin provides**:
- Stop hook → real-time automatic saving after each response
- Slash commands → convenience shortcuts
- Install script → ensures skill is present

**Skill provides**:
- Save script → JSONL to markdown conversion
- Search script → full-text search with context
- Parse script → readable conversation formatting

## Real-Time Saving Behavior

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
│   ├── install.sh               # Ensures skill is installed
│   ├── commands/
│   │   ├── convo-search.md      # Search slash command
│   │   ├── convo-list.md        # List slash command
│   │   └── convo-recent.md      # Recent slash command
│   ├── hooks/
│   │   └── stop.sh              # Real-time auto-save hook (calls skill)
│   └── scripts/
│       └── search-conversations.sh # Wrapper (calls skill)
└── README.md
```

## Troubleshooting

**Hook not triggering?**
- Verify scripts are executable: `/plugin reinstall conversation-saver`
- Check Claude Code output after responses for any errors
- Ensure the Stop hook is properly configured

**Skill not found error?**
- The plugin should auto-install the skill, but you can manually install:
  ```bash
  cd ~/.claude/skills
  git clone https://github.com/sirkitree/conversation-logger.git
  ```

**Parser failing?**
- Ensure Python 3 is installed: `python3 --version`
- Reinstall: `/plugin reinstall conversation-saver`

**Search not finding anything?**
- Verify conversations exist: `ls -lh ~/.claude/conversation-logs/`
- Try `/convo-list` to see all available conversations
- Make sure you've had at least one Claude response after installing the plugin

**Slash commands not working?**
- Restart Claude Code after plugin installation
- Verify plugin is installed: `/plugin list`

## Want Just the Skill?

If you prefer manual control without automatic hooks, you can use just the skill:

```bash
cd ~/.claude/skills
git clone https://github.com/sirkitree/conversation-logger.git
```

Then ask Claude to save/search conversations naturally, or use the scripts directly.

## Contributing

Contributions welcome! Feel free to:
- Report bugs via GitHub Issues
- Suggest features
- Submit pull requests
- Share your use cases

## Related Projects

- [conversation-logger skill](https://github.com/sirkitree/conversation-logger) - The core skill this plugin wraps
- [Blog post](https://sirkitree.net/blog/claude-code-auto-save-conversations) - Full story and background
- [Claude Code Skills](https://www.anthropic.com/news/skills) - Official skills documentation
- [Claude Code Docs](https://docs.claude.com/en/docs/claude-code) - Official documentation

## License

MIT License - feel free to use and modify as needed.

## Credits

Built with Claude Code itself. Meta inception achieved. 🚀

---

*Never lose a conversation again. Install once, search forever.*
