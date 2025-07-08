#!/usr/bin/env python3
"""
Raspberry Pi Manager GUI

A comprehensive GUI tool for:
1. Detecting Raspberry Pi devices (USB, Network, Serial)
2. Flashing Raspberry Pi OS images
3. SSH/VNC connection to Raspberry Pi
4. Custom OS building integration
"""

import os
import sys
import platform
import subprocess
import threading
import tkinter as tk
from tkinter import ttk, filedialog, messagebox, scrolledtext
import socket
import re
import time
import json
import webbrowser
from concurrent.futures import ThreadPoolExecutor, as_completed

# Try to import optional dependencies
try:
    import serial.tools.list_ports
    SERIAL_AVAILABLE = True
except ImportError:
    SERIAL_AVAILABLE = False

try:
    import paramiko
    SSH_AVAILABLE = True
except ImportError:
    SSH_AVAILABLE = False

# Constants
DEFAULT_SSH_PORT = 22
DEFAULT_VNC_PORT = 5900
DEFAULT_USERNAME = "pi"
DEFAULT_PASSWORD = "raspberry"
DEFAULT_TIMEOUT = 5

# Get package data directory
def get_package_data_dir():
    """Get the directory where package data is stored"""
    # When installed as a package
    if getattr(sys, 'frozen', False):
        # PyInstaller creates a temp folder and stores path in _MEIPASS
        return os.path.join(sys._MEIPASS, 'rpi_manager_data')
    
    # When running from source
    return os.path.abspath(os.path.join(os.path.dirname(__file__), 'data'))

# Paths
PACKAGE_DATA_DIR = get_package_data_dir()

class RaspberryPiManager(tk.Tk):
    """Main application window for Raspberry Pi Manager"""
    
    def __init__(self):
        super().__init__()
        self.title("Raspberry Pi Manager")
        self.geometry("900x700")
        self.minsize(800, 600)
        
        # Application state
        self.detected_devices = {
            "usb": [],
            "serial": [],
            "network": []
        }
        self.selected_device = None
        self.detection_running = False
        self.flashing_running = False
        self.building_running = False
        
        # Create UI
        self.create_menu()
        self.create_notebook()
        self.create_status_bar()
        
        # Initial detection
        self.after(1000, self.detect_devices_async)

    def create_menu(self):
        """Create application menu"""
        menubar = tk.Menu(self)
        
        # File menu
        file_menu = tk.Menu(menubar, tearoff=0)
        file_menu.add_command(label="Detect Devices", command=self.detect_devices_async)
        file_menu.add_command(label="Load Custom Image", command=self.load_custom_image)
        file_menu.add_separator()
        file_menu.add_command(label="Exit", command=self.quit)
        menubar.add_cascade(label="File", menu=file_menu)
        
        # Tools menu
        tools_menu = tk.Menu(menubar, tearoff=0)
        tools_menu.add_command(label="SSH Settings", command=self.show_ssh_settings)
        tools_menu.add_command(label="VNC Settings", command=self.show_vnc_settings)
        tools_menu.add_command(label="Network Settings", command=self.show_network_settings)
        menubar.add_cascade(label="Tools", menu=tools_menu)
        
        # Help menu
        help_menu = tk.Menu(menubar, tearoff=0)
        help_menu.add_command(label="Documentation", command=lambda: webbrowser.open("https://www.raspberrypi.org/documentation/"))
        help_menu.add_command(label="About", command=self.show_about)
        menubar.add_cascade(label="Help", menu=help_menu)
        
        self.config(menu=menubar)

    def create_notebook(self):
        """Create tabbed interface"""
        self.notebook = ttk.Notebook(self)
        self.notebook.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)
        
        # Create tabs
        self.detection_tab = ttk.Frame(self.notebook)
        self.flashing_tab = ttk.Frame(self.notebook)
        self.ssh_vnc_tab = ttk.Frame(self.notebook)
        self.custom_os_tab = ttk.Frame(self.notebook)
        
        self.notebook.add(self.detection_tab, text="Device Detection")
        self.notebook.add(self.flashing_tab, text="OS Flashing")
        self.notebook.add(self.ssh_vnc_tab, text="SSH/VNC")
        self.notebook.add(self.custom_os_tab, text="Custom OS")
        
        # Setup each tab
        self.setup_detection_tab()
        self.setup_flashing_tab()
        self.setup_ssh_vnc_tab()
        self.setup_custom_os_tab()

    # ... [rest of the RaspberryPiManager class implementation] ...
    # Note: For brevity, I'm not including the entire implementation here.
    # The full implementation would be copied from the existing rpi_manager_gui.py file.

    def create_status_bar(self):
        """Create status bar at the bottom of the window"""
        self.status_var = tk.StringVar()
        self.status_var.set("Ready")
        status_bar = ttk.Label(self, textvariable=self.status_var, relief=tk.SUNKEN, anchor=tk.W)
        status_bar.pack(side=tk.BOTTOM, fill=tk.X)

    # ... [implementation of all methods] ...

    def check_command_exists(self, cmd):
        """Check if a command exists in the system path"""
        return subprocess.run(['which', cmd], capture_output=True).returncode == 0

def main():
    """Main entry point for the GUI application"""
    app = RaspberryPiManager()
    app.mainloop()

if __name__ == "__main__":
    main()