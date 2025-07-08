#!/usr/bin/env python3
"""
Raspberry Pi Manager Core

Core functionality for:
1. Detecting Raspberry Pi devices
2. Flashing Raspberry Pi OS images
3. SSH/VNC connection to Raspberry Pi
4. Custom OS building
"""

import os
import sys
import platform
import subprocess
import socket
import re
import time
import threading
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

class RaspberryPiCore:
    """Core functionality for Raspberry Pi Manager"""
    
    def __init__(self):
        """Initialize the core"""
        pass
    
    def detect_devices(self, usb=True, serial=True, network=True):
        """Detect Raspberry Pi devices"""
        devices = []
        
        if usb:
            devices.extend(self.detect_usb_devices())
        
        if serial and SERIAL_AVAILABLE:
            devices.extend(self.detect_serial_devices())
        
        if network:
            devices.extend(self.detect_network_devices())
        
        return devices
    
    def detect_usb_devices(self):
        """Detect USB-connected Raspberry Pi devices"""
        devices = []
        
        try:
            usb_devices = []
            if platform.system().lower() == "windows":
                # Windows: Use PowerShell
                result = subprocess.run(['powershell', '-Command', 
                                       'Get-WmiObject -Class Win32_PnPEntity | Where-Object {$_.Name -like "*USB*" -or $_.Name -like "*Serial*"} | Select-Object Name, DeviceID'], 
                                      capture_output=True, text=True)
                if result.returncode == 0:
                    lines = result.stdout.strip().split('\n')
                    for line in lines[2:]:  # Skip headers
                        if line.strip():
                            usb_devices.append(line.strip())
            else:
                # macOS/Linux: Use system_profiler or lsusb
                if platform.system().lower() == "darwin":
                    result = subprocess.run(['system_profiler', 'SPUSBDataType'], 
                                          capture_output=True, text=True)
                else:
                    result = subprocess.run(['lsusb'], capture_output=True, text=True)
                
                if result.returncode == 0:
                    usb_devices = result.stdout.strip().split('\n')
            
            # Look for Pi-related USB devices
            pi_keywords = ['raspberry', 'pi', 'broadcom', 'rpi', 'foundation']
            
            for device in usb_devices:
                device_lower = device.lower()
                if any(keyword in device_lower for keyword in pi_keywords):
                    devices.append({
                        "type": "USB",
                        "id": "usb-" + str(len(devices)),
                        "description": device,
                        "status": "Available"
                    })
        except Exception as e:
            print(f"Error detecting USB devices: {e}")
        
        return devices
    
    def detect_serial_devices(self):
        """Detect serial port Raspberry Pi devices"""
        devices = []
        
        if not SERIAL_AVAILABLE:
            return devices
        
        try:
            ports = list(serial.tools.list_ports.comports())
            
            for port in ports:
                # Check for Pi-related serial devices
                description = (port.description or '').lower()
                hwid = (port.hwid or '').lower()
                
                if any(keyword in description or keyword in hwid 
                       for keyword in ['raspberry', 'pi', 'broadcom', 'rpi']):
                    devices.append({
                        "type": "Serial",
                        "id": port.device,
                        "description": port.description,
                        "status": "Available"
                    })
        except Exception as e:
            print(f"Error detecting serial devices: {e}")
        
        return devices
    
    def detect_network_devices(self):
        """Detect network Raspberry Pi devices"""
        devices = []
        
        # Get local networks
        local_ips = self.get_network_interfaces()
        
        if not local_ips:
            # Default scan
            devices.extend(self.scan_network("192.168.1"))
        else:
            for ip in local_ips:
                network = '.'.join(ip.split('.')[:-1])
                devices.extend(self.scan_network(network))
        
        return devices
    
    def get_network_interfaces(self):
        """Get network interface information"""
        local_ips = []
        
        try:
            if platform.system().lower() == "windows":
                result = subprocess.run(['ipconfig'], capture_output=True, text=True)
            else:
                result = subprocess.run(['ifconfig'], capture_output=True, text=True)
            
            if result.returncode == 0:
                # Extract IP addresses
                ip_pattern = r'(\d+\.\d+\.\d+\.\d+)'
                ips = re.findall(ip_pattern, result.stdout)
                local_ips = [ip for ip in ips if not ip.startswith('127.') and not ip.endswith('.255')]
        except Exception as e:
            print(f"Error getting network info: {e}")
        
        return local_ips
    
    def scan_network(self, ip_range):
        """Scan network for Raspberry Pi devices"""
        devices = []
        
        def check_host(ip):
            """Check if host is reachable and potentially a Pi"""
            try:
                # Quick ping check
                if platform.system().lower() == "windows":
                    result = subprocess.run(['ping', '-n', '1', '-w', '1000', ip], 
                                          capture_output=True, text=True, timeout=2)
                else:
                    result = subprocess.run(['ping', '-c', '1', '-W', '1', ip], 
                                          capture_output=True, text=True, timeout=2)
                
                if result.returncode == 0:
                    # Try to get hostname
                    try:
                        hostname = socket.gethostbyaddr(ip)[0]
                        # Check for Pi-like hostnames
                        if any(pi_name in hostname.lower() for pi_name in ['raspberrypi', 'pi', 'rpi']):
                            return {'ip': ip, 'hostname': hostname, 'type': 'Pi (hostname)'}
                    except:
                        hostname = 'Unknown'
                    
                    # Try SSH port check
                    try:
                        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                        sock.settimeout(1)
                        result = sock.connect_ex((ip, 22))
                        sock.close()
                        if result == 0:
                            return {'ip': ip, 'hostname': hostname, 'type': 'SSH available'}
                    except:
                        pass
                    
                    return {'ip': ip, 'hostname': hostname, 'type': 'Reachable'}
            except:
                pass
            return None
        
        # Generate IP range
        ips = [f"{ip_range}.{i}" for i in range(1, 255)]
        
        with ThreadPoolExecutor(max_workers=50) as executor:
            future_to_ip = {executor.submit(check_host, ip): ip for ip in ips}
            for future in as_completed(future_to_ip):
                result = future.result()
                if result:
                    devices.append({
                        "type": "Network",
                        "id": result['ip'],
                        "description": f"{result['hostname']} - {result['type']}",
                        "status": "Available"
                    })
        
        return devices
    
    def flash_image(self, image, device, verify=False):
        """Flash image to device"""
        try:
            # Unmount device first (macOS/Linux)
            if platform.system() == 'Darwin':
                subprocess.run(['diskutil', 'unmountDisk', device], check=True, capture_output=True, text=True)
            
            # Use rpi-imager if available, otherwise use dd
            if self.check_command_exists('rpi-imager'):
                cmd = ['rpi-imager', '--cli', '--image', image, '--target', device]
                proc = subprocess.run(cmd, check=True, capture_output=True, text=True)
            else:
                if platform.system() == 'Windows':
                    # On Windows, use a different approach
                    print("Windows dd not supported, please use rpi-imager")
                    return False
                else:
                    # Use dd on Unix-like systems
                    cmd = ['sudo', 'dd', f'if={image}', f'of={device}', 'bs=4M', 'status=progress']
                    proc = subprocess.run(cmd, check=True, capture_output=True, text=True)
            
            # Verify if requested
            if verify:
                # Verification logic would go here
                pass
            
            return True
        except Exception as e:
            print(f"Error during flashing: {e}")
            return False
    
    def connect_ssh(self, host, username=DEFAULT_USERNAME, password=DEFAULT_PASSWORD, port=DEFAULT_SSH_PORT):
        """Connect to SSH server"""
        if not SSH_AVAILABLE:
            print("Error: paramiko not available for SSH connections")
            return False
        
        try:
            client = paramiko.SSHClient()
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            
            client.connect(hostname=host, port=port, username=username, password=password, timeout=DEFAULT_TIMEOUT)
            
            # Launch SSH client based on platform
            if platform.system() == 'Windows':
                # Use PuTTY if available
                if self.check_command_exists('putty'):
                    subprocess.Popen(['putty', '-ssh', f'{username}@{host}', '-P', str(port)])
                else:
                    print("PuTTY not found. Please install PuTTY or use another SSH client.")
                    return False
            elif platform.system() == 'Darwin':
                # macOS: Use Terminal
                subprocess.Popen(['osascript', '-e', f'tell app "Terminal" to do script "ssh {username}@{host} -p {port}"'])
            else:
                # Linux: Use xterm or gnome-terminal
                if self.check_command_exists('gnome-terminal'):
                    subprocess.Popen(['gnome-terminal', '--', 'ssh', f'{username}@{host}', '-p', str(port)])
                elif self.check_command_exists('xterm'):
                    subprocess.Popen(['xterm', '-e', f'ssh {username}@{host} -p {port}'])
                else:
                    print("No terminal emulator found. Please install gnome-terminal or xterm.")
                    return False
            
            client.close()
            return True
        except Exception as e:
            print(f"SSH connection failed: {e}")
            return False
    
    def connect_vnc(self, host, port=DEFAULT_VNC_PORT):
        """Connect to VNC server"""
        try:
            if platform.system() == 'Windows':
                # Use VNC Viewer if available
                if self.check_command_exists('vncviewer'):
                    subprocess.Popen(['vncviewer', f'{host}:{port}'])
                else:
                    print("VNC Viewer not found. Please install VNC Viewer or use another VNC client.")
                    return False
            elif platform.system() == 'Darwin':
                # macOS: Use built-in Screen Sharing
                subprocess.Popen(['open', f'vnc://{host}:{port}'])
            else:
                # Linux: Use vncviewer or similar
                if self.check_command_exists('vncviewer'):
                    subprocess.Popen(['vncviewer', f'{host}:{port}'])
                elif self.check_command_exists('gvncviewer'):
                    subprocess.Popen(['gvncviewer', host, '--port', str(port)])
                else:
                    print("No VNC viewer found. Please install vncviewer or gvncviewer.")
                    return False
            
            return True
        except Exception as e:
            print(f"VNC connection failed: {e}")
            return False
    
    def build_custom_os(self, base_os, hostname, username, password, wifi_ssid=None, wifi_password=None,
                        enable_ssh=True, enable_vnc=False, output_dir=None):
        """Build custom OS image"""
        try:
            if not output_dir:
                output_dir = os.path.join(os.path.expanduser("~"), "custom_rpi_os")
            
            # Create output directory if it doesn't exist
            os.makedirs(output_dir, exist_ok=True)
            
            # Create config directory
            config_dir = os.path.join(output_dir, "config")
            os.makedirs(config_dir, exist_ok=True)
            
            # Create config files
            with open(os.path.join(config_dir, "config"), "w") as f:
                f.write(f"IMG_NAME={hostname}\n")
                
                # Select stage based on base OS
                if "lite" in base_os.lower():
                    f.write("STAGE_LIST=\"stage0 stage1 stage2\"\n")
                elif "desktop" in base_os.lower():
                    f.write("STAGE_LIST=\"stage0 stage1 stage2 stage3\"\n")
                elif "full" in base_os.lower():
                    f.write("STAGE_LIST=\"stage0 stage1 stage2 stage3 stage4\"\n")
                
                # 64-bit support
                if "64-bit" in base_os:
                    f.write("ARM64=1\n")
                
                f.write(f"TARGET_HOSTNAME={hostname}\n")
                f.write(f"FIRST_USER_NAME={username}\n")
                f.write(f"FIRST_USER_PASS={password}\n")
                
                # WiFi settings
                if wifi_ssid and wifi_password:
                    f.write(f"WPA_ESSID=\"{wifi_ssid}\"\n")
                    f.write(f"WPA_PASSWORD=\"{wifi_password}\"\n")
                    f.write("WPA_COUNTRY=US\n")
                
                # Enable SSH
                if enable_ssh:
                    f.write("ENABLE_SSH=1\n")
            
            # Create custom script if needed
            if enable_vnc:
                # Create stage2 custom directory
                stage2_dir = os.path.join(output_dir, "stage2", "01-custom")
                os.makedirs(stage2_dir, exist_ok=True)
                
                # Create custom script
                with open(os.path.join(stage2_dir, "00-run.sh"), "w") as f:
                    f.write("#!/bin/bash -e\n\n")
                    f.write("on_chroot << EOF\n")
                    
                    # Enable VNC
                    f.write("# Enable VNC\n")
                    f.write("apt-get update\n")
                    f.write("apt-get install -y realvnc-vnc-server\n")
                    f.write("systemctl enable vncserver-x11-serviced.service\n")
                    
                    f.write("\nEOF\n")
                
                # Make script executable
                os.chmod(os.path.join(stage2_dir, "00-run.sh"), 0o755)
            
            # Run pi-gen
            # Note: This is a simplified version. In a real implementation,
            # you would need to locate pi-gen and run the build script.
            print(f"Custom OS configuration created in {output_dir}")
            print("To build the OS, run the pi-gen build script in this directory.")
            
            return True
        except Exception as e:
            print(f"Error building custom OS: {e}")
            return False
    
    def check_command_exists(self, cmd):
        """Check if a command exists in the system path"""
        return subprocess.run(['which', cmd], capture_output=True).returncode == 0