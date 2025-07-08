#!/bin/bash
# Auto git add, commit, and push for LI-FI_Project_Dev.Workspace
set -e
cd "$(dirname "$0")/.."

MSG="Auto-commit: $(date '+%Y-%m-%d %H:%M:%S')"

git add .
git commit -m "$MSG" || echo "Nothing to commit."
git push origin master
