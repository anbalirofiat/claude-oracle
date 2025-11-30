#!/usr/bin/env bash
set -e

echo "🔮 Installing Claude Oracle..."

INSTALL_DIR="$HOME/.oracle"
mkdir -p "$INSTALL_DIR"

# Copy files
cp oracle.py schemas.py oracle "$INSTALL_DIR/"

# Create venv and install deps
echo "📦 Creating virtual environment..."
python3 -m venv "$INSTALL_DIR/venv"
"$INSTALL_DIR/venv/bin/pip" install -q google-genai requests Pillow

# Add to PATH
if ! grep -q '.oracle' ~/.bashrc 2>/dev/null; then
    echo 'export PATH="$HOME/.oracle:$PATH"' >> ~/.bashrc
fi

# Install Claude Code command
CLAUDE_CMD_DIR="$HOME/.claude/commands"
mkdir -p "$CLAUDE_CMD_DIR"
cp commands/fullauto.md "$CLAUDE_CMD_DIR/"

echo ""
echo "✅ Installation complete!"
echo ""
echo "⚠️  Set your API key:"
echo '   echo '\''export GEMINI_API_KEY="your-key-here"'\'' >> ~/.bashrc'
echo ""
echo "   Optional (for image generation in geo-restricted regions):"
echo '   echo '\''export VAST_API_KEY="your-vast-key"'\'' >> ~/.bashrc'
echo ""
echo "🔄 Restart terminal or run: source ~/.bashrc"
echo ""
echo "🚀 Usage:"
echo "   oracle ask \"How should I implement X?\""
echo "   oracle imagine \"A logo for my project\""
echo "   oracle quick \"What is Python?\""
