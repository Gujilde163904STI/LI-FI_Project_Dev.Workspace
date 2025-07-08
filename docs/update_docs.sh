#!/bin/bash

# Li-Fi Project Documentation Update Script
# This script updates all documentation repositories and rebuilds indexing

echo "🔄 Updating Li-Fi Project Documentation Repositories..."

# Function to update a repository
update_repo() {
    local repo_name=$1
    local repo_path=$2
    
    echo "📚 Updating $repo_name..."
    if [ -d "$repo_path" ]; then
        cd "$repo_path"
        if [ -d ".git" ]; then
            git pull origin main
            echo "✅ $repo_name updated successfully"
        else
            echo "⚠️  $repo_name is not a git repository"
        fi
        cd - > /dev/null
    else
        echo "❌ $repo_name directory not found"
    fi
}

# Update each documentation repository
update_repo ".NET Documentation" "dotnet-docs"
update_repo "Windows IoT Core Documentation" "windows-iot-docs"
update_repo "The Things Network Documentation" "things-network-docs"
update_repo "Thinger.io Documentation" "thinger-docs"

echo ""
echo "🎯 Rebuilding workspace indexing..."

# Rebuild cursor indexing
if command -v cursor &> /dev/null; then
    echo "🔄 Rebuilding Cursor index..."
    cursor index
    echo "✅ Cursor indexing completed"
else
    echo "⚠️  Cursor command not found, skipping cursor indexing"
fi

# Clean and rebuild Python analysis
echo "🐍 Cleaning Python cache..."
find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
find . -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null || true

echo ""
echo "🎉 Documentation update completed!"
echo ""
echo "📖 Available documentation:"
echo "   • .NET Documentation: ./dotnet-docs/"
echo "   • Windows IoT Core: ./windows-iot-docs/"
echo "   • The Things Network: ./things-network-docs/"
echo "   • Thinger.io: ./thinger-docs/"
echo ""
echo "🔗 See README.md for integration details and navigation guides." 