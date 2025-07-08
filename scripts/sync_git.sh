#!/bin/bash

# LI-FI Project Git Sync Script
# Usage: ./sync_git.sh [commit_message]

PROJECT_DIR="/Users/djcarlogujilde/GALAHADD.DEV.PROJECTS/LI-FI_Project_Dev.Workspace"
REMOTE_URL="https://github.com/Gujilde163904/LI-FI_Project_Dev.Workspace.git"
BRANCH="main"

cd "$PROJECT_DIR" || exit 1

echo "=== LI-FI Project Git Sync ==="
echo "Project: $PROJECT_DIR"
echo "Remote: $REMOTE_URL"
echo "Branch: $BRANCH"
echo ""

# Set commit message
COMMIT_MSG="${1:-sync: Mac → GitHub → Windows sync $(date '+%Y-%m-%d %H:%M')}"

echo "Step 1: Pull latest changes from remote..."
git pull origin "$BRANCH" || {
    echo "Warning: Pull failed, continuing..."
}

echo ""
echo "Step 2: Add all changes..."
git add .

echo ""
echo "Step 3: Check status..."
git status --porcelain

echo ""
echo "Step 4: Commit changes..."
if git diff --cached --quiet; then
    echo "No changes to commit."
else
    git commit -m "$COMMIT_MSG"
    echo "Committed: $COMMIT_MSG"
fi

echo ""
echo "Step 5: Push to remote..."
git push origin "$BRANCH" || {
    echo "Push failed! Check your authentication."
    echo "You may need to configure a Personal Access Token."
    exit 1
}

echo ""
echo "✅ Sync complete! Changes pushed to GitHub."
echo "Windows can now run: git pull origin main"
