#!/bin/bash

# GitHub Repository Setup Script
# This script helps create the repository if it doesn't exist

REPO_NAME="LI-FI_Project_Dev.Workspace"
GITHUB_USERNAME="Gujilde163904"
PAT="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"

echo "=== GitHub Repository Setup ==="
echo "Repository: $GITHUB_USERNAME/$REPO_NAME"
echo ""

# Check if repository exists
echo "Checking if repository exists on GitHub..."
response=$(curl -s -H "Authorization: token $PAT" \
  "https://api.github.com/repos/$GITHUB_USERNAME/$REPO_NAME")

if echo "$response" | grep -q '"message": "Not Found"'; then
    echo "❌ Repository not found. Creating repository..."
    
    # Create repository
    create_response=$(curl -s -H "Authorization: token $PAT" \
      -H "Content-Type: application/json" \
      -X POST \
      -d '{
        "name": "'$REPO_NAME'",
        "description": "LI-FI Embedded System Development Workspace - Arduino, ESP8266, ESP32, Raspberry Pi",
        "private": false,
        "has_issues": true,
        "has_projects": true,
        "has_wiki": true,
        "auto_init": false
      }' \
      "https://api.github.com/user/repos")
    
    if echo "$create_response" | grep -q '"clone_url"'; then
        echo "✅ Repository created successfully!"
    else
        echo "❌ Failed to create repository:"
        echo "$create_response"
        exit 1
    fi
else
    echo "✅ Repository already exists!"
fi

echo ""
echo "Setting up local Git configuration..."

# Configure Git with PAT
git config --global credential.helper store
git remote set-url origin "https://$PAT@github.com/$GITHUB_USERNAME/$REPO_NAME.git"

echo ""
echo "Testing connection..."
if git ls-remote origin &>/dev/null; then
    echo "✅ Git connection successful!"
    
    echo ""
    echo "Pushing initial commit..."
    git add .
    git commit -m "Initial commit: LI-FI Embedded System Workspace setup" || echo "Nothing to commit"
    git branch -M main
    git push -u origin main
    
    echo ""
    echo "🎉 Repository setup complete!"
    echo "🔗 Repository URL: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
else
    echo "❌ Git connection failed. Please check your Personal Access Token."
    exit 1
fi
