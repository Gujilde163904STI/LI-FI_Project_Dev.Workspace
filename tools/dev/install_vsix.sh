#!/usr/bin/env bash
set -e

# Directories to search for VSIX files
VSIX_DIRS=(".vsix" "extensions" "tools/dev/vsix")

# Find available CLI
CLI=""
if command -v code >/dev/null 2>&1; then
  CLI="code"
elif command -v cursor >/dev/null 2>&1; then
  CLI="cursor"
elif command -v codium >/dev/null 2>&1; then
  CLI="codium"
else
  echo "[VSIX INSTALLER] No supported CLI found (code, cursor, codium). Aborting."
  exit 1
fi

echo "[VSIX INSTALLER] Using CLI: $CLI"

# Find all .vsix files in the specified directories
VSIX_FILES=()
for dir in "${VSIX_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    while IFS= read -r -d $'\0' file; do
      VSIX_FILES+=("$file")
    done < <(find "$dir" -type f -name "*.vsix" -print0)
  fi
done

if [ ${#VSIX_FILES[@]} -eq 0 ]; then
  echo "[VSIX INSTALLER] No .vsix files found in: ${VSIX_DIRS[*]}"
  exit 0
fi

echo "[VSIX INSTALLER] Found ${#VSIX_FILES[@]} .vsix file(s):"
for f in "${VSIX_FILES[@]}"; do
  echo "  - $f"
done

echo "[VSIX INSTALLER] Installing extensions..."
for f in "${VSIX_FILES[@]}"; do
  echo "[VSIX INSTALLER] Installing $f ..."
  "$CLI" --install-extension "$f" --force || {
    echo "[VSIX INSTALLER] Failed to install $f"
  }
done

echo "[VSIX INSTALLER] All .vsix files processed." 