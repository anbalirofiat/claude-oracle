# Claude Oracle 🔮

A Gemini-powered AI orchestrator for Claude Code. Use Google's Gemini as a "lead architect" to guide Claude's development work.

## Features

- **`oracle ask`** - Strategic planning and code review
- **`oracle ask --files`** - Attach code files for review
- **`oracle ask --image`** - Analyze screenshots/diagrams
- **`oracle imagine`** - Generate images (auto-provisions US server if geo-restricted)
- **`oracle quick`** - Quick text answers
- **`oracle history`** - Conversation memory (5 exchanges per project)

## Installation

```bash
git clone https://github.com/n1ira/claude-oracle.git
cd claude-oracle
./install.sh
```

## Setup

Get a [Gemini API key](https://makersuite.google.com/app/apikey) and add to your shell:

```bash
echo 'export GEMINI_API_KEY="your-key-here"' >> ~/.bashrc
source ~/.bashrc
```

**Optional** (for image generation in geo-restricted regions):
```bash
echo 'export VAST_API_KEY="your-vast-key"' >> ~/.bashrc
```

## Usage

```bash
# Strategic planning
oracle ask "How should I implement a caching layer?"

# Code review
oracle ask --files src/main.py "Review this code"
oracle ask --files "src/main.py:1-100" "Review lines 1-100"

# Image analysis
oracle ask --image screenshot.png "What's wrong here?"

# Image generation
oracle imagine "A logo for my startup"

# Quick questions
oracle quick "What's the best Python HTTP library?"

# History
oracle history          # View recent exchanges
oracle history --clear  # Clear history
```

## Claude Code Integration

After installation, use the `/fullauto` command in Claude Code:

```
/fullauto implement a user authentication system
```

This activates **FULLAUTO MODE** where Claude uses the Oracle as lead architect.

## License

MIT
