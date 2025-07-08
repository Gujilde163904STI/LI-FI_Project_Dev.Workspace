#!/usr/bin/env python3
"""
project_setup.py
Cross-platform project setup script for LI-FI_Project_Dev.Workspace.
Detects OS (macOS/Windows), configures VS Code, Python venv, and dependencies.
"""
import os
import sys
import subprocess
import shutil

WORKSPACE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCRIPTS_DIR = os.path.join(WORKSPACE_DIR, "scripts")
VSCODE_DIR = os.path.join(WORKSPACE_DIR, ".vscode")
VENV_DIR = os.path.join(WORKSPACE_DIR, "venv")

# 1. Detect OS
if sys.platform.startswith("darwin"):
    os_name = "macos"
    cpp_config = os.path.join(SCRIPTS_DIR, "c_cpp_properties.macos.json")
    print("[INFO] Detected macOS.")
elif sys.platform.startswith("win"):
    os_name = "windows"
    cpp_config = os.path.join(SCRIPTS_DIR, "c_cpp_properties.windows.json")
    print("[INFO] Detected Windows.")
else:
    print("[ERROR] Unsupported OS. Only macOS and Windows are supported.")
    sys.exit(1)

# 2. Setup VS Code C++ IntelliSense config
target_cpp_config = os.path.join(VSCODE_DIR, "c_cpp_properties.json")
os.makedirs(VSCODE_DIR, exist_ok=True)
shutil.copyfile(cpp_config, target_cpp_config)
print(f"[INFO] VS Code C++ config set: {target_cpp_config}")

# 3. Setup Python virtual environment
if not os.path.isdir(VENV_DIR):
    print("[INFO] Creating Python virtual environment...")
    subprocess.check_call([sys.executable, "-m", "venv", VENV_DIR])
    print("[INFO] Virtual environment created.")
else:
    print("[INFO] Python virtual environment already exists.")

# 4. Install Python dependencies
if sys.platform.startswith("win"):
    pip_path = os.path.join(VENV_DIR, "Scripts", "pip.exe")
    python_path = os.path.join(VENV_DIR, "Scripts", "python.exe")
else:
    pip_path = os.path.join(VENV_DIR, "bin", "pip")
    python_path = os.path.join(VENV_DIR, "bin", "python")

print("[INFO] Upgrading pip and installing dependencies (pyserial, RPi.GPIO)...")
subprocess.check_call([pip_path, "install", "--upgrade", "pip"])
subprocess.check_call([pip_path, "install", "pyserial", "RPi.GPIO"])
print("[INFO] Python dependencies installed.")

print("[SUCCESS] Project setup complete. You can now use the workspace on macOS or Windows.")
