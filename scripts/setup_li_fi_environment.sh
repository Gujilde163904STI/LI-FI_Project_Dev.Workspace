#!/bin/bash

echo "🔧 Starting LI-FI Embedded Dev Environment Setup (macOS/Linux)..."

# --- Step 1: Fix Node.js memory (heap out of memory) ---
echo "⚙️  Setting NODE_OPTIONS for increased memory..."
if ! grep -q "NODE_OPTIONS" ~/.zshrc 2>/dev/null && ! grep -q "NODE_OPTIONS" ~/.bashrc 2>/dev/null; then
  echo 'export NODE_OPTIONS="--max-old-space-size=4096"' >> ~/.zshrc
  echo 'export NODE_OPTIONS="--max-old-space-size=4096"' >> ~/.bashrc
  echo "✅ NODE_OPTIONS added to shell config."
else
  echo "✅ NODE_OPTIONS already configured."
fi

# --- Step 2: Ensure Git is configured ---
echo "🔐 Checking Git config..."
git config --global user.name || git config --global user.name "Galahadd Dev"
git config --global user.email || git config --global user.email "your-email@example.com"
echo "✅ Git user config set."

# --- Step 3: Git LFS setup ---
echo "📦 Setting up Git LFS..."
if ! command -v git-lfs &> /dev/null; then
  echo "Installing Git LFS..."
  brew install git-lfs
fi
git lfs install
echo "✅ Git LFS ready."

# --- Step 4: Docker memory fix (optional if Docker is installed) ---
echo "🐳 Checking Docker memory limit..."
DOCKER_PREFS=~/Library/Group\ Containers/group.com.docker/settings.json
if [ -f "$DOCKER_PREFS" ]; then
  echo "🧠 Docker preferences found. (You can manually increase memory to 6GB+ via Docker Desktop)"
else
  echo "ℹ️  Docker Desktop not detected — skipping Docker memory fix."
fi

# --- Step 5: VS Code terminal fix ---
echo "🖥️  Fixing VS Code terminal blank bug..."
mkdir -p .vscode
cat <<EOF > .vscode/settings.json
{
  "terminal.integrated.defaultProfile.osx": "zsh",
  "terminal.integrated.inheritEnv": true,
  "python.defaultInterpreterPath": "/usr/local/bin/python3",
  "editor.formatOnSave": true
}
EOF
echo "✅ VS Code settings updated."

# --- Step 6: Clean corrupted config files if they exist ---
echo "🧹 Checking for old configs to clean..."
for f in ".cursor" ".idea" ".env" ".vscode"; do
  if [ -d "$f" ]; then
    mv "$f" "$f.bak-$(date +%s)"
    echo "➡️  Moved $f to $f.bak-<timestamp>"
  fi
done

# --- Step 7: Show completion message ---
echo ""
echo "🎉 Setup complete. Please restart your terminal or run:"
echo "    source ~/.zshrc"
echo "or"
echo "    source ~/.bashrc"
echo ""
echo "You're ready to sync with Windows (Right Arm) or launch Docker manually when needed."