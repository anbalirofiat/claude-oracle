<p align="center">
  <a href="https://github.com/n1ira/claude-oracle">
    <img
      src="https://github.com/user-attachments/assets/1a3f8983-b7b9-4728-9b79-e448ea08622b"
      alt="logo"
      width="200"
    />
  </a>
</p>

<h1 align="center">Claude Oracle</h1>

<p align="center">
  A CLI that makes Google's Gemini 3 Pro the "lead architect" for Claude Code.
  Think of it as giving your AI coding assistant its own AI assistant for
  strategic decisions.
</p>

<p align="center">
  <a href="https://github.com/n1ira/claude-oracle">
    <img
      src="https://img.shields.io/github/stars/n1ira/claude-oracle?style=social"
      alt="Stars"
    />
  </a>
</p>


## Why?

Claude Code is great at writing code, but sometimes you want a second opinion on architecture, or need to validate an approach before diving in. This tool lets Claude query Gemini 3 Pro without leaving your terminal, and integrates directly into Claude Code workflows.

The `/fullauto` command will activate the whole system, Claude will autonomously consult Gemini at key decision points, like having a senior architect review your junior dev's work.

## Quick Start

### Linux / macOS

```bash
git clone https://github.com/n1ira/claude-oracle.git
cd claude-oracle
./install.sh
```

### Windows

```bash
git clone https://github.com/n1ira/claude-oracle.git
cd claude-oracle
install.cmd
```

### Option 1: Vertex AI Express (Recommended for Gemini 3 Pro)

Vertex AI Express provides access to Gemini 3 Pro without restrictions:

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Enable **Vertex AI API**
3. Create a service account and generate an API key
4. Set the environment variable:

```bash
export VERTEX_API_KEY="your-vertex-key"
```

### Option 2: Regular Gemini API Key

For Gemini 2.5 and earlier models ([get key here](https://makersuite.google.com/app/apikey)):

```bash
export GEMINI_API_KEY="your-key"
```

### Option 3: Google Account OAuth

If you have a Google AI Ultra subscription or want to use your Google account instead of an API key:

1. Go to [Google Cloud Console Credentials](https://console.cloud.google.com/apis/credentials)
2. Create OAuth 2.0 Client ID → **Desktop application**
3. Download the JSON and save as `~/.oracle/oauth/client_secret.json`
4. Run:

```bash
oracle login
```

This opens a browser for authentication. Once logged in, Oracle uses your Google account's access (including Ultra subscription benefits) automatically.

```bash
oracle logout  # Remove saved credentials
oracle info    # Check authentication status
```

## Commands

```bash
# Ask for strategic advice
oracle ask "Should I use Redis or Memcached for session caching?"

# Get code reviewed
oracle ask --files src/auth.py "Any security issues here?"

# Review specific lines
oracle ask --files "src/db.py:50-120" "Is this query efficient?"

# Analyze a screenshot or diagram
oracle ask --image error.png "What's causing this?"

# Generate images (auto-provisions US server if you're geo-restricted)
oracle imagine "architecture diagram for microservices"

# Quick one-off questions
oracle quick "regex for email validation"

# Conversation history (5 exchanges per project)
oracle history
oracle history --clear

# View FULLAUTO_CONTEXT.md (recovery header auto-prepended)
oracle context

# Google account login (for subscription users)
oracle login
oracle logout
oracle info  # Check auth status
```

## Claude Code Integration

After installing, you get the `/fullauto` slash command:

```
/fullauto implement rate limiting for the API
```

This puts Claude in high-autonomy mode where it:
1. Gathers context about your codebase
2. Consults Gemini for an implementation plan
3. Executes the plan, checking back with Gemini at decision points
4. Gets final validation before marking complete

It's like pair programming, but both programmers are AIs with different strengths.

## Image Generation Workaround

Gemini's image generation is geo-restricted in some regions. If you hit this, the Oracle will automatically:

1. Find the cheapest US instance on Vast.ai (~$0.08/hr)
2. Spin it up, generate your image there
3. Download the result and destroy the instance

Cost ends up being ~$0.01 per image. You'll need a [Vast.ai API key](https://vast.ai/) for this:

```bash
export VAST_API_KEY="your-vast-key"
```

## How it Works

The Oracle maintains a 5-exchange conversation history per project directory. This gives Gemini enough context to make useful suggestions without blowing up the context window.

For `/fullauto` mode, Claude creates `FULLAUTO_CONTEXT.md` in your project root to track task progress. Any oracle command auto-prepends a recovery header to this file, telling post-compaction Claude to reload the `/fullauto` instructions.

When Claude's context compacts mid-task, the new instance reads `FULLAUTO_CONTEXT.md`, sees the recovery header, reloads the full `/fullauto` command, and continues where it left off.

## Meta

This repo was created using itself. The `/fullauto` command orchestrated Claude through:
- Designing the directory structure
- Writing the install script
- Creating this README
- Pushing to GitHub

The Oracle bootstrapping its own existence.

## Credits

- Logo by [@Microck](https://github.com/Microck)

## License

MIT
