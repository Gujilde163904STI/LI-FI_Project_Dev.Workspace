#!/usr/bin/env python3
"""
Flexible Plugin Loader for LI-FI_Project_Dev.Workspace
- Scans resource folders for scripts/plugins/extensions (Python, shell, Node.js, etc.)
- Executes or lists them based on naming convention or config
- Designed for VS Code Task Automation and cross-environment use
"""
import os
import subprocess
from pathlib import Path

# Folders to scan for plugins/scripts
RESOURCE_FOLDERS = [
    '../Workspace.DEV.Resources',
    '../Platformio.CORE.Resources',
    '../Global.INTEGRATE.Resources',
]

# File extensions to consider as plugins/scripts
PLUGIN_EXTENSIONS = ['.py', '.sh', '.js']

# Optional: Only run scripts with this prefix (for safety)
PLUGIN_PREFIX = 'plugin_'  # e.g., plugin_hello.py

def find_plugins():
    plugins = []
    for folder in RESOURCE_FOLDERS:
        abs_folder = Path(__file__).parent / folder
        if abs_folder.exists():
            for root, _, files in os.walk(abs_folder):
                for f in files:
                    if any(f.endswith(ext) for ext in PLUGIN_EXTENSIONS) and f.startswith(PLUGIN_PREFIX):
                        plugins.append(Path(root) / f)
    return plugins

def run_plugin(plugin_path):
    ext = plugin_path.suffix
    if ext == '.py':
        subprocess.run(['python3', str(plugin_path)], check=False)
    elif ext == '.sh':
        subprocess.run(['bash', str(plugin_path)], check=False)
    elif ext == '.js':
        subprocess.run(['node', str(plugin_path)], check=False)
    else:
        print(f"Unknown plugin type: {plugin_path}")

def main():
    plugins = find_plugins()
    if not plugins:
        print("No plugins found.")
        return
    print("Found plugins:")
    for p in plugins:
        print(f" - {p}")
    # Run all plugins (customize as needed)
    for p in plugins:
        print(f"\nRunning {p}...")
        run_plugin(p)

if __name__ == '__main__':
    main()
