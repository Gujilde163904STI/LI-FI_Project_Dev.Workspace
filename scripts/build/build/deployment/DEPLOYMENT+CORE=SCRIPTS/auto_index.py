"""
auto_index.py
Automation script to scan workspace and generate/update a summary index file.
"""
import os
from pathlib import Path

INDEX_FILE = "INDEX.md"
EXTRA_FOLDERS = ["resources", "integration", "plugins", "extension", "reference"]


def scan_workspace(root_dir):
    """Scan workspace and return folder structure."""
    folders = []
    for entry in os.scandir(root_dir):
        if entry.is_dir() and not entry.name.startswith('.'):
            folders.append(entry.name)
    # Add extra folders if they exist
    for extra in EXTRA_FOLDERS:
        if (Path(root_dir) / extra).exists():
            if extra not in folders:
                folders.append(extra)
    return sorted(folders)

def generate_index(root_dir, folders):
    """Generate or update the summary index file."""
    with open(Path(root_dir) / INDEX_FILE, 'w') as f:
        f.write(f"# Project Index\n\n")
        for folder in folders:
            f.write(f"- {folder}/\n")
    print(f"Index file '{INDEX_FILE}' updated.")

if __name__ == "__main__":
    root = Path(__file__).parent.parent
    folders = scan_workspace(root)
    generate_index(root, folders)

# Integration Note
#
# The workspace now includes:
#   - Arduino/ : ESP8266 Arduino core, libraries, and tools
#   - Arduino-ESP8266-NodeMCU/ : NodeMCU (ESP8266) Arduino examples and documentation
#
# These folders are indexed automatically by scripts/auto_index.py.
#
# To reference these folders in your scripts, use relative paths as shown in the main README and copilot-instructions.md.
