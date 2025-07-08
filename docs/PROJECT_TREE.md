# LI-FI Project Development Workspace - Project Tree

## Overview

This document provides a clean, organized view of the LI-FI embedded firmware development workspace structure after reorganization.

## Project Structure

```
LI-FI_Project_Dev.Workspace/
├── .git/                          # Git repository
├── .conda/                        # Conda environment
├── .trunk/                        # Trunk configuration
├── archive/                       # Legacy and archived files
│   ├── __archive/                 # Original archive
│   ├── node_modules/              # Archived node modules
│   ├── to_review/                 # Files pending review
│   └── typings/                   # TypeScript definitions
├── config/                        # Configuration files
│   ├── pyrightconfig.json         # Python type checking config
│   └── skaffold.yaml              # Kubernetes deployment config
├── devices/                       # Embedded device firmware
│   ├── ESP8266/                   # ESP8266 device firmware
│   ├── RPI3/                      # Raspberry Pi 3 firmware
│   ├── RPI4/                      # Raspberry Pi 4 firmware
│   ├── ESP32/                     # ESP32 device firmware
│   └── esp/                       # ESP development tools
├── docker/                        # Docker configuration
│   ├── Dockerfile                 # Main Docker image
│   ├── Dockerfile.debug           # Debug Docker image
│   ├── .dockerignore              # Docker ignore rules
│   ├── run_dev_env.sh             # Development environment script
│   └── run_dev_env.ps1            # PowerShell dev environment script
├── docs/                          # Documentation
│   ├── README.md                  # Main project documentation
│   ├── CHANGELOG.md               # Project changelog
│   ├── VERSION.txt                # Version information
│   ├── versioning.md              # Versioning guidelines
│   ├── CONFIGURATION_FIXES_SUMMARY.md
│   ├── DOCKER_BUILD_GUIDE.md
│   ├── GITHUB_SYNC_GUIDE.md
│   ├── MD050_AND_EXTENSION_FIXES.md
│   ├── PYTHON_EXTENSION_STATUS.md
│   └── [various documentation subdirectories]
├── firmware/                      # Built firmware binaries
├── hardware/                      # Hardware schematics and designs
│   ├── diagram/                   # Hardware diagrams
│   ├── diagrams/                  # Additional diagrams
│   ├── esp8266/                   # ESP8266 hardware designs
│   ├── kicad/                     # KiCad PCB designs
│   ├── lifi_core/                 # LI-FI core hardware
│   ├── parts/                     # Component libraries
│   ├── raspberry_pi/              # Raspberry Pi hardware
│   └── wiring/                    # Wiring diagrams
├── integrations/                  # Third-party integrations
│   ├── Adafruit_NFCShield_I2C/
│   ├── arduino-device-lib/
│   ├── arduino-mqtt/
│   ├── awesome-iot/
│   ├── azure-iot-sdks/
│   ├── buildstream/
│   ├── chrome-nfc/
│   ├── esp-idf/
│   ├── esp-iot-solution/
│   ├── iotdb/
│   ├── iotjs/
│   ├── IOTstack/
│   ├── RFIDIOt/
│   ├── RIOT/
│   ├── superset/
│   └── TDengine/
├── meta/                          # Development environment config
│   ├── .cursor/                   # Cursor IDE configuration
│   ├── .devcontainer/             # Dev container config
│   ├── .github/                   # GitHub Actions workflows
│   ├── .idea/                     # JetBrains IDE config
│   └── .vscode/                   # VS Code configuration
├── monitoring/                    # Monitoring and observability
│   ├── grafana/                   # Grafana dashboards
│   └── prometheus.yml             # Prometheus configuration
├── resources/                     # Project resources
│   ├── arduino-cli/               # Arduino CLI tools
│   ├── arduino-core/              # Arduino core files
│   ├── legacy-docs/               # Legacy documentation
│   └── LIFI_Build_References/     # Build references
├── scripts/                       # Build and utility scripts
│   ├── build/                     # Build scripts
│   ├── flash/                     # Flash scripts
│   ├── boot.sh                    # Boot script
│   ├── fix_extensions.sh          # Extension fix script
│   ├── fix_md050.sh               # Markdown fix script
│   ├── setup_python_env.sh        # Python environment setup
│   ├── setup_python_env.ps1       # PowerShell Python setup
│   ├── sync_to_github.sh          # GitHub sync script
│   ├── sync_to_github.ps1         # PowerShell GitHub sync
│   ├── sync_to_windows.sh         # Windows sync script
│   └── update_lib_jars.sh         # Library update script
├── test/                          # Test files and utilities
│   ├── index                      # Test index file
│   └── test_python.py             # Python test file
├── tools/                         # Development tools
│   ├── arduino/                   # Arduino tools
│   ├── control-center/             # Control center tools
│   ├── dev/                       # Development utilities
│   ├── embedded_libs/             # Embedded libraries
│   ├── esp-quick-toolchain/       # ESP toolchain
│   ├── esp8266/                   # ESP8266 tools
│   ├── flash_all.ps1              # Flash all script
│   ├── flash_all.sh               # Flash all script
│   ├── fs/                        # File system tools
│   ├── platformio/                # PlatformIO tools
│   ├── remote/                    # Remote development tools
│   ├── rpi/                       # Raspberry Pi tools
│   ├── scripts/                   # Tool scripts
│   ├── security/                  # Security tools
│   ├── systemd/                   # Systemd services
│   ├── tui/                       # Terminal UI tools
│   └── webui/                     # Web UI tools
├── venv/                          # Python virtual environment
├── .cursor.mdc                    # Cursor workspace config
├── .cursorignore                  # Cursor ignore rules
├── .cursorindexingignore          # Cursor indexing ignore
├── .cspell.json                   # Spell checker config
├── .cspell-technical-terms.txt    # Technical terms for spell checker
├── .env                           # Environment variables
├── .gitattributes                 # Git attributes
├── .gitignore                     # Git ignore rules
├── .gitlab-ci.yml                 # GitLab CI configuration
├── cursor.mdc                     # Cursor configuration
├── LI-FI_Project_Dev.Workspace.code-workspace  # VS Code workspace
├── package.json                   # Node.js package config
├── package-lock.json              # Node.js lock file
├── qodana.yaml                    # Qodana configuration
└── requirements.txt               # Python dependencies
```

## Key Directories

### 🎯 Core Development

- **`devices/`** - Embedded device firmware for ESP8266, RPI3, RPI4, ESP32
- **`firmware/`** - Built firmware binaries and releases
- **`hardware/`** - Hardware schematics, PCB designs, and wiring diagrams
- **`scripts/`** - Build scripts, flash utilities, and development tools

### 📚 Documentation & Resources

- **`docs/`** - Project documentation, guides, and changelog
- **`resources/`** - Build references, toolchains, and legacy docs
- **`integrations/`** - Third-party IoT and embedded libraries

### ⚙️ Configuration & Tools

- **`config/`** - Project configuration files
- **`meta/`** - IDE and development environment configurations
- **`tools/`** - Development utilities and toolchains
- **`docker/`** - Containerization and deployment configs

### 🧪 Testing & Monitoring

- **`test/`** - Test files and utilities
- **`monitoring/`** - Observability and monitoring tools

### 🗄️ Archive & Legacy

- **`archive/`** - Legacy files, deprecated code, and review items
- **`venv/`** - Python virtual environment (excluded from indexing)

## Build Targets

### ESP8266 Firmware

```bash
# Build ESP8266 firmware
cd devices/ESP8266/
# Build commands specific to ESP8266
```

### Raspberry Pi 3 Firmware

```bash
# Build RPI3 firmware
cd devices/RPI3/
# Build commands specific to RPI3
```

### Raspberry Pi 4 Firmware

```bash
# Build RPI4 firmware
cd devices/RPI4/
# Build commands specific to RPI4
```

## Development Workflow

1. **Firmware Development**: Work in `devices/[DEVICE_TYPE]/`
2. **Hardware Design**: Use `hardware/` for schematics and PCB designs
3. **Build & Flash**: Use scripts in `scripts/` for building and flashing
4. **Documentation**: Update docs in `docs/` directory
5. **Testing**: Place test files in `test/` directory

## Performance Optimizations

- **`.cursorignore`** excludes `archive/`, `venv/`, `node_modules/` for faster indexing
- **`pyrightconfig.json`** prioritizes `devices/`, `scripts/`, `docs/` for type checking
- Legacy and archived files are moved to `archive/` to reduce workspace clutter

## Last Updated

Generated on: $(date)
Workspace Version: $(cat VERSION.txt 2>/dev/null || echo "Unknown")
