#!/usr/bin/env python3
"""
Development Setup for LI-FI Project on Windows
This script sets up GPIO simulation and mock hardware for development on Windows
"""

# Raspberry Pi GPIO library for deployment is provided locally in RPi.GPIO-0.7.1/
# Do NOT install RPi.GPIO from PyPI for deployment; use the bundled source.
# For development on macOS/Windows, fake-rpi is used for GPIO simulation.

import sys
import os

# Mock RPi.GPIO for Windows development
try:
    import fake_rpi
    GPIO = getattr(fake_rpi, 'GPIO', None)
    if GPIO is None:
        class FakeGPIO:
            BCM = 11
            OUT = 0
            IN = 1
            HIGH = 1
            LOW = 0
            def setmode(self, mode): pass
            def setup(self, pin, mode): pass
            def output(self, pin, value): pass
            def input(self, pin): return 0
            def cleanup(self): pass
        GPIO = FakeGPIO()
except ImportError:
    print("❌ fake-rpi not installed. Run: pip install fake-rpi")
    GPIO = None

# Test GPIO simulation
def test_gpio_simulation():
    """Test GPIO functionality with simulation"""
    try:
        import RPi.GPIO as GPIO
        
        # Configure GPIO
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(18, GPIO.OUT)  # LED pin for LI-FI transmitter
        GPIO.setup(24, GPIO.IN)   # Photodiode pin for LI-FI receiver
        
        print("✅ GPIO simulation working - pins configured")
        
        # Test basic operations
        GPIO.output(18, GPIO.HIGH)
        print("✅ LED simulation: ON")
        
        GPIO.output(18, GPIO.LOW)
        print("✅ LED simulation: OFF")
        
        # Read photodiode (simulated)
        state = GPIO.input(24)
        print(f"✅ Photodiode simulation: {state}")
        
        GPIO.cleanup()
        print("✅ GPIO cleanup complete")
        
    except Exception as e:
        print(f"❌ GPIO simulation failed: {e}")
        return False
    
    return True

# Test serial communication
def test_serial_communication():
    """Test serial communication functionality"""
    try:
        import serial
        print("✅ pyserial available for ESP8266 communication")
        
        # List available serial ports
        import serial.tools.list_ports
        ports = list(serial.tools.list_ports.comports())
        
        if ports:
            print("Available serial ports:")
            for port in ports:
                print(f"  - {port.device}: {port.description}")
        else:
            print("⚠️  No serial ports detected (normal if ESP8266 not connected)")
        
        return True
        
    except Exception as e:
        print(f"❌ Serial communication test failed: {e}")
        return False

# Test PlatformIO integration
def test_platformio():
    """Test PlatformIO CLI functionality"""
    try:
        import subprocess
        result = subprocess.run(['pio', '--version'], capture_output=True, text=True, shell=True)
        
        if result.returncode == 0:
            print(f"✅ PlatformIO available: {result.stdout.strip()}")
            return True
        else:
            print("❌ PlatformIO not available")
            return False
            
    except Exception as e:
        print(f"❌ PlatformIO test failed: {e}")
        return False

# Main setup function
def main():
    """Run all development setup tests"""
    print("🚀 Setting up LI-FI Project development environment on Windows...")
    print("=" * 60)
    
    tests = [
        ("GPIO Simulation", test_gpio_simulation),
        ("Serial Communication", test_serial_communication),
        ("PlatformIO Integration", test_platformio)
    ]
    
    results = []
    for test_name, test_func in tests:
        print(f"\n📋 Testing {test_name}...")
        success = test_func()
        results.append((test_name, success))
    
    print("\n" + "=" * 60)
    print("🏁 Development Environment Setup Results:")
    
    for test_name, success in results:
        status = "✅ PASS" if success else "❌ FAIL"
        print(f"  {test_name}: {status}")
    
    all_passed = all(success for _, success in results)
    
    if all_passed:
        print("\n🎉 All tests passed! Your development environment is ready.")
        print("\nNext steps:")
        print("1. Open VS Code: code LI-FI_Project_Dev.Workspace.code-workspace")
        print("2. Activate Python virtual environment: venv\\Scripts\\activate")
        print("3. Start developing your LI-FI transmitter/receiver code")
    else:
        print("\n⚠️  Some tests failed. Please resolve the issues above.")
    
    return all_passed

if __name__ == "__main__":
    main()
