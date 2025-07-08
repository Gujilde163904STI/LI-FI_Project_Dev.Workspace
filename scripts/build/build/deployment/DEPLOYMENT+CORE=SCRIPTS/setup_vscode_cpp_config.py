import os
import shutil
import sys

# Paths
workspace_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
vscode_dir = os.path.join(workspace_dir, ".vscode")
macos_cfg = os.path.join(workspace_dir, "scripts", "c_cpp_properties.macos.json")
windows_cfg = os.path.join(workspace_dir, "scripts", "c_cpp_properties.windows.json")
target_cfg = os.path.join(vscode_dir, "c_cpp_properties.json")

# Detect OS
if sys.platform.startswith("darwin"):
    src = macos_cfg
    print("Detected macOS. Using macOS C++ config.")
elif sys.platform.startswith("win"):
    src = windows_cfg
    print("Detected Windows. Using Windows C++ config.")
else:
    print("Unsupported OS. Only macOS and Windows are supported.")
    sys.exit(1)

# Copy config
shutil.copyfile(src, target_cfg)
print(f"Copied {src} to {target_cfg}")
