#!/usr/bin/env python3
"""
Cross-Platform LI-FI Project Development Setup
Supports both macOS (development) and Windows (client production)
"""

import sys
import os
import platform
import subprocess
import json

def detect_platform():
    """Detect the current operating system"""
    system = platform.system().lower()
    return {
        'darwin': 'macos',
        'windows': 'windows',
        'linux': 'linux'
    }.get(system, system)

def setup_gpio_environment():
    """Setup GPIO libraries based on platform"""
    current_platform = detect_platform()
    
    if current_platform == 'macos':
        # macOS: Use fake-rpi for development simulation
        try:
            import fake_rpi
            print("✅ [macOS] GPIO simulation enabled with fake-rpi")
            return True
        except ImportError:
            print("❌ [macOS] fake-rpi not installed. Run: pip install fake-rpi")
            return False
            
    elif current_platform == 'windows':
        # Windows: Use fake-rpi for development, document real RPi.GPIO for deployment
        try:
            import fake_rpi
            print("✅ [Windows] GPIO simulation enabled with fake-rpi")
            print("ℹ️  [Windows] For Raspberry Pi deployment, use the local RPi.GPIO-0.7.1 package on the Pi.")
            return True
        except ImportError:
            print("❌ [Windows] fake-rpi not available. Install via: pip install fake-rpi")
            return False
            
    elif current_platform == 'linux':
        # Linux: Try local RPi.GPIO-0.7.1 first, fall back to fake-rpi
        try:
            import sys, os
            sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), 'RPi.GPIO-0.7.1')))
            import RPi.GPIO
            print("✅ [Linux] Local RPi.GPIO-0.7.1 detected (Raspberry Pi deployment)")
            return True
        except ImportError:
            try:
                import fake_rpi
                print("✅ [Linux] GPIO simulation enabled with fake-rpi")
                return True
            except ImportError:
                print("❌ [Linux] Neither local RPi.GPIO nor fake-rpi available")
                return False
    return False

def get_serial_ports():
    """Get available serial ports for ESP8266 communication"""
    try:
        import serial.tools.list_ports
        ports = list(serial.tools.list_ports.comports())
        
        current_platform = detect_platform()
        
        if current_platform == 'macos':
            # macOS typically uses /dev/cu.usbserial* or /dev/cu.SLAB_USBtoUART
            esp_ports = [p for p in ports if 'usbserial' in p.device or 'SLAB' in p.device]
        elif current_platform == 'windows':
            # Windows typically uses COM ports
            esp_ports = [p for p in ports if p.device.startswith('COM')]
        else:
            # Linux typically uses /dev/ttyUSB* or /dev/ttyACM*
            esp_ports = [p for p in ports if 'ttyUSB' in p.device or 'ttyACM' in p.device]
        
        return ports, esp_ports
    except ImportError:
        print("❌ pyserial not available. Install via: pip install pyserial")
        return [], []

def test_platformio():
    """Test PlatformIO availability across platforms"""
    try:
        result = subprocess.run(['pio', '--version'], capture_output=True, text=True)
        if result.returncode == 0:
            version = result.stdout.strip()
            print(f"✅ PlatformIO available: {version}")
            return True
        else:
            print("❌ PlatformIO not working properly")
            return False
    except FileNotFoundError:
        current_platform = detect_platform()
        if current_platform == 'windows':
            print("❌ PlatformIO not found. Install via: pip install platformio")
            print("ℹ️  [Windows] You may need to add Python Scripts to PATH")
        else:
            print("❌ PlatformIO not found. Install via: pip install platformio")
        return False

def create_cross_platform_config():
    """Create platform-specific configuration files"""
    current_platform = detect_platform()
    
    # Platform-specific settings
    if current_platform == 'macos':
        platformio_config = {
            "monitor_port": "/dev/cu.usbserial*",
            "upload_port": "/dev/cu.usbserial*",
            "python_path": "python3"
        }
    elif current_platform == 'windows':
        platformio_config = {
            "monitor_port": "COM*",
            "upload_port": "COM*", 
            "python_path": "python"
        }
    else:  # Linux/Raspberry Pi
        platformio_config = {
            "monitor_port": "/dev/ttyUSB*",
            "upload_port": "/dev/ttyUSB*",
            "python_path": "python3"
        }
    
    # Save platform config
    config_file = f"platform_config_{current_platform}.json"
    with open(config_file, 'w') as f:
        json.dump(platformio_config, f, indent=2)
    
    print(f"✅ Created platform configuration: {config_file}")
    return config_file

def check_development_tools():
    """Check availability of development tools"""
    tools_status = {}
    
    # Check Python
    try:
        python_version = f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}"
        tools_status['python'] = {'available': True, 'version': python_version}
        print(f"✅ Python {python_version}")
    except:
        tools_status['python'] = {'available': False}
        print("❌ Python not available")
    
    # Check Git
    try:
        result = subprocess.run(['git', '--version'], capture_output=True, text=True)
        if result.returncode == 0:
            version = result.stdout.strip()
            tools_status['git'] = {'available': True, 'version': version}
            print(f"✅ {version}")
        else:
            tools_status['git'] = {'available': False}
            print("❌ Git not working")
    except FileNotFoundError:
        tools_status['git'] = {'available': False}
        print("❌ Git not found")
    
    # Check VS Code
    vscode_commands = ['code', 'code.cmd', 'code.exe']
    vscode_found = False
    
    for cmd in vscode_commands:
        try:
            result = subprocess.run([cmd, '--version'], capture_output=True, text=True)
            if result.returncode == 0:
                version = result.stdout.split('\n')[0]
                tools_status['vscode'] = {'available': True, 'version': version}
                print(f"✅ VS Code {version}")
                vscode_found = True
                break
        except FileNotFoundError:
            continue
    
    if not vscode_found:
        tools_status['vscode'] = {'available': False}
        print("❌ VS Code not found")
    
    return tools_status

def generate_platform_readme():
    """Generate README with platform-specific instructions"""
    current_platform = detect_platform()
    
    readme_content = f"""# LI-FI Project - Cross-Platform Setup

## Current Platform: {current_platform.upper()}

### Platform-Specific Instructions

"""
    
    if current_platform == 'macos':
        readme_content += """
#### macOS Development Setup
```bash
# Install dependencies
pip3 install platformio pyserial fake-rpi gpiozero

# Open project in VS Code
code LI-FI_Project_Dev.Workspace.code-workspace

# Serial ports typically: /dev/cu.usbserial* or /dev/cu.SLAB_USBtoUART
```
"""
    elif current_platform == 'windows':
        readme_content += """
#### Windows Production Setup
```cmd
# Install dependencies
pip install platformio pyserial fake-rpi gpiozero

# Open project in VS Code
code LI-FI_Project_Dev.Workspace.code-workspace

# Serial ports typically: COM1, COM2, COM3, etc.
# Check Device Manager for ESP8266 port assignment
```

##### Windows-Specific Notes:
- ESP8266 drivers may be required (CH340/CP2102)
- Add Python Scripts directory to PATH if needed
- Use Device Manager to identify COM ports
"""
    
    readme_content += """
### Cross-Platform Commands

#### ESP8266 Development (Works on all platforms)
```bash
# Build ESP8266 firmware
pio run

# Upload to ESP8266
pio run --target upload

# Monitor serial output
pio device monitor

# List connected devices
pio device list
```

#### Python Development
```bash
# Run transmitter
python tx/main.py

# Run receiver  
python rx/main.py

# Test GPIO (simulated on non-Pi platforms)
python test_gpio.py
```

### Transfer Instructions (macOS → Windows)

1. **Compress project directory:**
   ```bash
   tar -czf lifi_project.tar.gz LI-FI_Project_Dev.Workspace/
   ```

2. **On Windows, extract and setup:**
   ```cmd
   # Extract files
   tar -xzf lifi_project.tar.gz
   
   # Install Python dependencies
   pip install -r requirements.txt
   
   # Test environment
   python setup_environment.py
   ```

3. **Open in VS Code:**
   ```cmd
   code LI-FI_Project_Dev.Workspace.code-workspace
   ```
"""
    
    with open(f'README_{current_platform.upper()}.md', 'w') as f:
        f.write(readme_content)
    
    print(f"✅ Created platform-specific README: README_{current_platform.upper()}.md")

def main():
    """Main setup function"""
    current_platform = detect_platform()
    
    print("🚀 LI-FI Project Cross-Platform Setup")
    print("=" * 50)
    print(f"📱 Detected Platform: {current_platform.upper()}")
    print("=" * 50)
    
    # Run tests
    tests = [
        ("Development Tools", check_development_tools),
        ("GPIO Environment", setup_gpio_environment),
        ("PlatformIO", test_platformio),
    ]
    
    results = []
    for test_name, test_func in tests:
        print(f"\n📋 Testing {test_name}...")
        if test_name == "Development Tools":
            result = test_func()
            success = all(tool['available'] for tool in result.values())
        else:
            success = test_func()
        results.append((test_name, success))
    
    # Check serial ports
    print(f"\n📋 Checking Serial Ports...")
    all_ports, esp_ports = get_serial_ports()
    if all_ports:
        print("Available serial ports:")
        for port in all_ports:
            marker = "🔌 ESP8266?" if port in esp_ports else "📱"
            print(f"  {marker} {port.device}: {port.description}")
    else:
        print("⚠️  No serial ports detected")
    
    # Create platform-specific files
    print(f"\n📋 Creating Platform Configuration...")
    config_file = create_cross_platform_config()
    generate_platform_readme()
    
    # Summary
    print("\n" + "=" * 50)
    print("🏁 Setup Results:")
    for test_name, success in results:
        status = "✅ PASS" if success else "❌ FAIL"
        print(f"  {test_name}: {status}")
    
    print(f"\n🎯 Platform: {current_platform.upper()}")
    print(f"📄 Config: {config_file}")
    print(f"📖 README: README_{current_platform.upper()}.md")
    
    if current_platform == 'macos':
        print("\n💡 Next Steps for macOS → Windows Transfer:")
        print("1. Develop and test on macOS")
        print("2. Run: tar -czf lifi_project.tar.gz LI-FI_Project_Dev.Workspace/")
        print("3. Transfer file to Windows client")
        print("4. Extract and run setup_environment.py on Windows")

if __name__ == "__main__":
    main()
