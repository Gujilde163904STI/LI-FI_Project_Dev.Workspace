#!/usr/bin/env python3
"""
Detects the current VS Code environment (Windows or macOS) and ensures .NET SDK is installed using local installers.
- Moves .NET files to the dotnet/ folder if not already present.
- Installs .NET SDK for the detected platform if missing.
- Can be run as a VS Code task or manually.
"""
import os
import platform
import shutil
import subprocess
import sys

WORKSPACE = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
DOTNET_DIR = os.path.join(WORKSPACE, 'dotnet')
MAC_PKG = os.path.join(DOTNET_DIR, 'dotnet-sdk-9.0.301-osx-arm64.pkg')
WIN_ZIP = os.path.join(DOTNET_DIR, 'dotnet-sdk-9.0.301-win-x64.zip')
PDF = os.path.join(DOTNET_DIR, 'dotnet-navigate-tools-diagnostics.pdf')

# Move files if not already in dotnet/
def move_dotnet_files():
    files = [
        ('dotnet-navigate-tools-diagnostics.pdf', PDF),
        ('dotnet-sdk-9.0.301-osx-arm64.pkg', MAC_PKG),
        ('dotnet-sdk-9.0.301-win-x64.zip', WIN_ZIP),
    ]
    for src, dst in files:
        src_path = os.path.join(WORKSPACE, src)
        if os.path.exists(src_path) and not os.path.exists(dst):
            shutil.move(src_path, dst)
            print(f"Moved {src} to dotnet/")


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
    temp_dir = tempfile.mkdtemp()
    with zipfile.ZipFile(WIN_ZIP, 'r') as zip_ref:
        zip_ref.extractall(temp_dir)
    dotnet_exe = next((os.path.join(root, 'dotnet.exe')
                      for root, dirs, files in os.walk(temp_dir)
                      if 'dotnet.exe' in files), None)
    if not dotnet_exe:
        print('dotnet.exe not found in extracted files.')
        sys.exit(1)
    print(f"dotnet.exe extracted to: {dotnet_exe}")
    print("Add this directory to your PATH or move it to a permanent location.")
    print("You may need to restart your terminal or log out/in.")


def main():
    move_dotnet_files()
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
