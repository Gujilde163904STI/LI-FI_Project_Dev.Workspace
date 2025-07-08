#!/usr/bin/env python3
"""
Automated .NET SDK installer for macOS and Windows.
- Checks if 'dotnet' is available in PATH.
- If missing, installs the correct SDK for the platform from the local 'dotnet' folder.
- Supports macOS (Apple Silicon) and Windows (x64).
"""
import os
import platform
import shutil
import subprocess
import sys

DOTNET_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '../dotnet'))
MAC_PKG = os.path.join(DOTNET_DIR, 'dotnet-sdk-9.0.301-osx-arm64.pkg')
WIN_ZIP = os.path.join(DOTNET_DIR, 'dotnet-sdk-9.0.301-win-x64.zip')


def is_dotnet_installed():
    return shutil.which('dotnet') is not None


def install_on_macos():
    print('Installing .NET SDK for macOS...')
    if not os.path.exists(MAC_PKG):
        print(f"Installer not found: {MAC_PKG}")
        sys.exit(1)
    subprocess.run(['sudo', 'installer', '-pkg', MAC_PKG, '-target', '/'], check=True)
    print('Done. You may need to restart your terminal.')


def install_on_windows():
    print('Installing .NET SDK for Windows...')
    import zipfile
    import tempfile
    if not os.path.exists(WIN_ZIP):
        print(f"Installer not found: {WIN_ZIP}")
        sys.exit(1)
    temp_dir = tempfile.mkdtemp()
    with zipfile.ZipFile(WIN_ZIP, 'r') as zip_ref:
        zip_ref.extractall(temp_dir)
    # Find dotnet.exe in extracted folder
    dotnet_exe = next((os.path.join(root, 'dotnet.exe')
                      for root, dirs, files in os.walk(temp_dir)
                      if 'dotnet.exe' in files), None)
    if not dotnet_exe:
        print('dotnet.exe not found in extracted files.')
        sys.exit(1)
    # Optionally, add to PATH or prompt user
    print(f"dotnet.exe extracted to: {dotnet_exe}")
    print("Add this directory to your PATH or move it to a permanent location.")
    print("You may need to restart your terminal or log out/in.")


def main():
    if is_dotnet_installed():
        print('dotnet is already installed.')
        return
    system = platform.system().lower()
    if system == 'darwin':
        install_on_macos()
    elif system == 'windows':
        install_on_windows()
    else:
        print(f'Unsupported OS: {system}')
        sys.exit(1)

if __name__ == '__main__':
    main()
