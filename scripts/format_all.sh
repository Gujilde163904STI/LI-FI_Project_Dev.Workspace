#!/bin/bash

# Format all files in the Li-Fi Project
# This script runs all formatters on the project

set -e

echo "🎨 Formatting all files in Li-Fi Project..."

# Format Python files
echo "🐍 Formatting Python files..."
if command -v black &> /dev/null; then
    black . --line-length 100
    echo "✅ Black formatting complete"
else
    echo "⚠️  Black not found, skipping Python formatting"
fi

if command -v isort &> /dev/null; then
    isort . --profile black --line-length 100
    echo "✅ isort formatting complete"
else
    echo "⚠️  isort not found, skipping import sorting"
fi

# Format JavaScript, JSON, YAML, and Markdown files
echo "📄 Formatting JS/JSON/YAML/MD files..."
if command -v npx &> /dev/null; then
    npx prettier --write "**/*.{js,jsx,ts,tsx,json,yaml,yml,md}" --ignore-path .gitignore
    echo "✅ Prettier formatting complete"
else
    echo "⚠️  npx not found, skipping JS/JSON/YAML/MD formatting"
fi

# Format C++ and Arduino files
echo "⚙️  Formatting C++/Arduino files..."
if command -v clang-format &> /dev/null; then
    find . -name "*.cpp" -o -name "*.h" -o -name "*.c" -o -name "*.ino" | grep -v "venv" | grep -v ".git" | xargs -I {} clang-format -i {}
    echo "✅ clang-format formatting complete"
else
    echo "⚠️  clang-format not found, skipping C++ formatting"
fi

# Format shell scripts
echo "🐚 Formatting shell scripts..."
if command -v shfmt &> /dev/null; then
    find . -name "*.sh" -o -name "*.bash" | grep -v "venv" | grep -v ".git" | xargs -I {} shfmt -w {}
    echo "✅ shfmt formatting complete"
else
    echo "⚠️  shfmt not found, skipping shell formatting"
fi

echo "🎉 All formatting complete!"
echo ""
echo "📋 Formatted file types:"
echo "  • Python (.py, .pyi)"
echo "  • JavaScript/TypeScript (.js, .jsx, .ts, .tsx)"
echo "  • JSON (.json)"
echo "  • YAML (.yaml, .yml)"
echo "  • Markdown (.md)"
echo "  • C++/Arduino (.cpp, .h, .c, .ino)"
echo "  • Shell (.sh, .bash)" 