#!/usr/bin/env python3
"""
Build script for RPI3 LI-FI Controller
Handles dependency installation, code compilation, and deployment
"""

import os
import sys
import subprocess
import json
import shutil
from pathlib import Path
from typing import List, Dict, Any


class RPI3Builder:
    """Build system for RPI3 LI-FI controller"""

    def __init__(self):
        self.project_root = Path(__file__).parent
        self.src_dir = self.project_root / "src"
        self.config_dir = self.project_root / "config"
        self.build_dir = self.project_root / "build"
        self.dist_dir = self.project_root / "dist"

        # Create build directories
        self.build_dir.mkdir(exist_ok=True)
        self.dist_dir.mkdir(exist_ok=True)

    def install_dependencies(self) -> bool:
        """Install required Python dependencies"""
        print("Installing Python dependencies...")

        requirements = [
            "RPi.GPIO>=0.7.0",
            "numpy>=1.21.0",
            "scipy>=1.7.0",
            "cryptography>=3.4.0",
            "psutil>=5.8.0",
            "requests>=2.25.0",
            "websockets>=10.0",
        ]

        try:
            for req in requirements:
                subprocess.run(
                    [sys.executable, "-m", "pip", "install", req],
                    check=True,
                    capture_output=True,
                )
                print(f"✓ Installed {req}")

            return True

        except subprocess.CalledProcessError as e:
            print(f"✗ Failed to install dependencies: {e}")
            return False

    def validate_config(self) -> bool:
        """Validate configuration files"""
        print("Validating configuration...")

        config_file = self.config_dir / "device_config.json"

        try:
            with open(config_file, "r") as f:
                config = json.load(f)

            # Validate required fields
            required_fields = [
                "device_id",
                "role",
                "wifi",
                "light_communication",
                "hardware",
                "network",
                "logging",
            ]

            for field in required_fields:
                if field not in config:
                    print(f"✗ Missing required field: {field}")
                    return False

            print("✓ Configuration validated")
            return True

        except FileNotFoundError:
            print(f"✗ Configuration file not found: {config_file}")
            return False
        except json.JSONDecodeError as e:
            print(f"✗ Invalid JSON in config: {e}")
            return False

    def run_tests(self) -> bool:
        """Run unit tests"""
        print("Running tests...")

        test_files = list(self.src_dir.glob("*_test.py"))

        if not test_files:
            print("⚠ No test files found")
            return True

        try:
            for test_file in test_files:
                result = subprocess.run(
                    [sys.executable, str(test_file)], check=True, capture_output=True
                )
                print(f"✓ Tests passed: {test_file.name}")

            return True

        except subprocess.CalledProcessError as e:
            print(f"✗ Tests failed: {e}")
            return False

    def compile_code(self) -> bool:
        """Compile Python code (optional optimization)"""
        print("Compiling code...")

        try:
            # Copy source files to build directory
            shutil.copytree(self.src_dir, self.build_dir / "src", dirs_exist_ok=True)
            shutil.copytree(
                self.config_dir, self.build_dir / "config", dirs_exist_ok=True
            )

            # Create __init__.py files if missing
            init_files = [
                self.build_dir / "src" / "__init__.py",
                self.build_dir / "config" / "__init__.py",
            ]

            for init_file in init_files:
                if not init_file.exists():
                    init_file.touch()

            print("✓ Code compiled successfully")
            return True

        except Exception as e:
            print(f"✗ Compilation failed: {e}")
            return False

    def create_deployment_package(self) -> bool:
        """Create deployment package"""
        print("Creating deployment package...")

        try:
            # Create package structure
            package_dir = self.dist_dir / "rpi3_lifi_controller"
            package_dir.mkdir(exist_ok=True)

            # Copy built files
            shutil.copytree(self.build_dir, package_dir / "app", dirs_exist_ok=True)

            # Create startup script
            startup_script = package_dir / "start.sh"
            with open(startup_script, "w") as f:
                f.write(
                    """#!/bin/bash
cd "$(dirname "$0")/app/src"
python3 main.py
"""
                )
            os.chmod(startup_script, 0o755)

            # Create systemd service file
            service_file = package_dir / "lifi-controller.service"
            with open(service_file, "w") as f:
                f.write(
                    """[Unit]
Description=LI-FI Controller Service
After=network.target

[Service]
Type=simple
User=pi
WorkingDirectory=/opt/lifi-controller/app/src
ExecStart=/usr/bin/python3 main.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
"""
                )

            # Create requirements.txt
            requirements_file = package_dir / "requirements.txt"
            with open(requirements_file, "w") as f:
                f.write(
                    """RPi.GPIO>=0.7.0
numpy>=1.21.0
scipy>=1.7.0
cryptography>=3.4.0
psutil>=5.8.0
requests>=2.25.0
websockets>=10.0
"""
                )

            print("✓ Deployment package created")
            return True

        except Exception as e:
            print(f"✗ Package creation failed: {e}")
            return False

    def deploy(self, target_path: str = "/opt/lifi-controller") -> bool:
        """Deploy to target system"""
        print(f"Deploying to {target_path}...")

        try:
            package_dir = self.dist_dir / "rpi3_lifi_controller"

            # Copy to target location
            if os.path.exists(target_path):
                shutil.rmtree(target_path)

            shutil.copytree(package_dir, target_path)

            # Install systemd service
            service_file = Path(target_path) / "lifi-controller.service"
            systemd_service = Path("/etc/systemd/system/lifi-controller.service")

            if os.access("/etc/systemd/system", os.W_OK):
                shutil.copy(service_file, systemd_service)
                subprocess.run(["systemctl", "daemon-reload"], check=True)
                subprocess.run(
                    ["systemctl", "enable", "lifi-controller.service"], check=True
                )
                print("✓ Systemd service installed")
            else:
                print("⚠ Cannot install systemd service (requires sudo)")

            print("✓ Deployment completed")
            return True

        except Exception as e:
            print(f"✗ Deployment failed: {e}")
            return False

    def build(self, deploy: bool = False) -> bool:
        """Run complete build process"""
        print("Starting RPI3 LI-FI Controller build...")

        steps = [
            ("Installing dependencies", self.install_dependencies),
            ("Validating configuration", self.validate_config),
            ("Running tests", self.run_tests),
            ("Compiling code", self.compile_code),
            ("Creating deployment package", self.create_deployment_package),
        ]

        for step_name, step_func in steps:
            print(f"\n--- {step_name} ---")
            if not step_func():
                print(f"Build failed at: {step_name}")
                return False

        if deploy:
            print(f"\n--- Deploying ---")
            if not self.deploy():
                print("Deployment failed")
                return False

        print("\n🎉 Build completed successfully!")
        return True


def main():
    """Main entry point"""
    import argparse

    parser = argparse.ArgumentParser(description="Build RPI3 LI-FI Controller")
    parser.add_argument("--deploy", action="store_true", help="Deploy after build")
    parser.add_argument(
        "--target", default="/opt/lifi-controller", help="Deployment target"
    )

    args = parser.parse_args()

    builder = RPI3Builder()
    success = builder.build(deploy=args.deploy)

    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
