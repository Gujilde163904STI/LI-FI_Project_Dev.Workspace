# Changelog

## [v2-apt-cache-fix] - December 2024

### Fixed

- **Docker Build APT Cache Issue**: Fixed APT cache mount directory error in Dockerfile
  - Pre-create `/var/lib/apt/lists/partial` directory with proper permissions (0755)
  - Prevents BuildKit cache mount failures when partial directory doesn't exist
  - Addresses upstream Docker issue: https://github.com/moby/buildkit/issues/1673
  - Ensures reliable package installation during container builds

### Updated

- **Dockerfile**: Added concise comments explaining the APT cache mount fix
  - Lines 13-16: Documentation of BuildKit cache mount permission requirements
  - Lines 17-18: Pre-creation of partial directory with proper permissions

---

## [v2-coder-integration] - December 2024

### Added

- **Coder Development Environment Manager**: Web-based IDE and remote development integration
  - `tools/dev/coder_install.sh` - Comprehensive installation script for Linux/macOS/Windows
  - `tools/dev/coder_wrapper.sh` - CLI wrapper for easy server and workspace management
  - `tools/dev/setup_coder_service.sh` - Systemd service setup with security hardening
  - `tools/dev/README.md` - Complete documentation for Coder integration
  - `docs/raspberrypi-documentation/integrations/coder.md` - VSCode integration guide
- **Development Features**: Alternative to VSCode Remote-SSH and VNC
  - Web-based IDE accessible from any browser
  - Remote development on Raspberry Pi and IoT devices
  - SSH port forwarding and secure tunneling
  - Container-based development environments
  - Systemd service for automatic startup
  - CLI wrapper for easy management
- **Security Features**: Multi-layer security implementation
  - TLS certificate support for secure connections
  - SSH tunneling for secure remote access
  - Systemd security hardening with sandboxing
  - Firewall configuration and port management
  - Authentication and user management
- **Documentation**: Comprehensive integration guides and usage documentation
  - Complete VSCode integration guide with browser-based development
  - Systemd service documentation with security best practices
  - Troubleshooting guides and performance optimization
  - Integration with existing LI-FI project workflows

### Updated

- **Workspace Configurations**: Enhanced indexing for Coder development tools
  - `.cursor.mdc`: Added tools/dev and tools/dev/coder paths
  - `.code-workspace`: Updated paths, highlights, and intelligent coding rules
  - Added Coder-specific rules for development environment management
- **Intelligent Coding**: Enhanced AI assistance for Coder implementations
  - Development environment management and configuration
  - Web-based IDE setup and remote access
  - Systemd service configuration with security best practices
  - SSH tunnel creation and remote development automation

### Purpose

The Coder Integration enables:

- **Web-Based Development**: Alternative to VSCode Remote-SSH for lightweight development access
- **Remote Development**: Secure web-based IDE access for Raspberry Pi and ESP8266 development
- **SSH Integration**: Port forwarding and tunneling for secure remote access
- **Automated Deployment**: Comprehensive scripts for installation, configuration, and service management
- **Performance Optimization**: Lightweight web IDE with container-based development environments
- **Monitoring and Logging**: Systemd integration with comprehensive logging and status monitoring

### Integration

- **Cursor AI**: Indexed for intelligent code completion with Coder development tooling
- **Cross-Platform**: Support for Windows/macOS development machines and Raspberry Pi targets
- **Security First**: Multi-layer security with TLS, SSH tunneling, and authentication
- **Automation**: Auto-generated scripts for installation, configuration, and deployment
- **Alternative Workflow**: Web-based development complementing existing VSCode and VNC tools
- **Best Practices**: Documented security guidelines and performance optimization

---

## [v2-wayvnc-integration] - December 2024

### Added

- **WayVNC Build Module**: Comprehensive VNC server integration for secure remote development
  - `build/modules/wayvnc/` - Build module structure for WayVNC integration
  - `tools/rpi/wayvnc_setup.sh` - Complete WayVNC installation and build automation
  - `tools/rpi/enable_wayvnc.sh` - Service configuration and authentication setup
  - `tools/security/generate_tls.sh` - TLS certificate generation for secure VNC connections
  - `tools/security/generate_rsa.sh` - RSA-AES key generation for additional encryption
  - `tools/remote/wayvnc_tunnel.sh` - SSH tunnel creation for secure remote access
  - `tools/systemd/wayvnc.service` - Systemd service with security hardening
  - `tools/rpi/realvnc_setup.sh` - RealVNC fallback for X11 environments
- **Security Features**: Multi-layer security implementation
  - TLS X509 certificates for transport encryption
  - RSA-AES encryption for sensitive data protection
  - SSH tunneling for secure remote access
  - Systemd security hardening with sandboxing
  - Firewall configuration and port management
- **Documentation**: Comprehensive integration guides and fallback documentation
  - `docs/WAYVNC_INTEGRATION_GUIDE.md` - Complete WayVNC integration guide
  - `docs/RASPBERRY_PI_VNC_FALLBACK.md` - RealVNC fallback documentation
  - Architecture diagrams and security best practices
  - Troubleshooting guides and performance optimization

### Updated

- **Workspace Configurations**: Enhanced indexing for WayVNC and security tools
  - `.cursor.mdc`: Added build modules, security tools, systemd, and remote access paths
  - `.code-workspace`: Updated paths, highlights, and intelligent coding rules
  - Added WayVNC-specific rules for build procedures and security configurations
- **Intelligent Coding**: Enhanced AI assistance for VNC and security implementations
  - WayVNC build procedures and configuration management
  - TLS/RSA certificate generation and management
  - Systemd service configuration with security best practices
  - SSH tunnel creation and remote access automation

### Purpose

The WayVNC Integration enables:

- **Secure Remote Development**: Modern VNC server with TLS/RSA encryption for headless Raspberry Pi development
- **SSH Tunnel Security**: Encrypted tunnels for secure remote access from Windows/macOS development machines
- **Fallback Support**: RealVNC Server integration for X11 environments when Wayland is not available
- **Automated Deployment**: Comprehensive scripts for installation, configuration, and service management
- **Performance Optimization**: Hardware acceleration and compression settings for optimal remote development
- **Monitoring and Logging**: Systemd integration with comprehensive logging and status monitoring

### Integration

- **Cursor AI**: Indexed for intelligent code completion with WayVNC and security tooling
- **Cross-Platform**: Support for Windows/macOS development machines and Raspberry Pi targets
- **Security First**: Multi-layer encryption with TLS, RSA-AES, and SSH tunneling
- **Automation**: Auto-generated scripts for installation, configuration, and deployment
- **Fallback System**: RealVNC integration for environments where WayVNC is not suitable
- **Best Practices**: Documented security guidelines and performance optimization

---

## [v2-raspberry-pi-knowledge-base] - December 2024

### Added

- **Raspberry Pi Knowledge Base**: Comprehensive documentation and hardware diagram indexing for intelligent coding
  - `docs/datasheets/` - Official Raspberry Pi datasheets (Pi 4, Pico, RP2040)
  - `docs/manuals/` - Programming guides and protocol specifications (BCM2711, Build HAT, SDK docs)
  - `hardware/diagrams/mechanical/` - Mechanical drawings for physical layout and mounting
  - `hardware/diagrams/schematics/` - Circuit schematics for electrical design and GPIO mapping
  - `hardware/kicad/` - KiCAD design assets (USB tester, CM4 IO board)
  - `docs/RASPBERRY_PI_KNOWLEDGE_BASE.md` - Intelligent coding knowledge base with validation workflows
- **Official Raspberry Pi AsciiDoc Documentation**: Complete integration of verified official procedures
  - `docs/raspberrypi-documentation/` - Official Raspberry Pi documentation in AsciiDoc format
  - `docs/RASPBERRY_PI_ASCIIDOC_INTEGRATION.md` - Comprehensive integration guide for intelligent coding
  - Mission-critical documentation for SSH, VNC, rsync, and network boot procedures
  - Auto-generated automation scripts based on official documentation

### Updated

- **Workspace Configurations**: Enhanced indexing for intelligent coding assistance
  - `.cursor.mdc`: Added datasheets, manuals, diagrams, KiCAD folders, and AsciiDoc documentation
  - `.code-workspace`: Updated paths, highlights, and cursor workspace includes
  - Added intelligent coding rules for PDF, SVG, KiCAD, and AsciiDoc files
- **Documentation**: Updated docs index to include Raspberry Pi knowledge base and AsciiDoc integration
  - `docs/README.md`: Added reference to comprehensive knowledge base and AsciiDoc integration
  - Created README files for mechanical and schematic diagram directories
- **Automation Scripts**: Generated comprehensive automation based on official documentation
  - `tools/rpi/ssh_config_setup.sh` - SSH configuration and remote development setup
  - `tools/rpi/vnc_setup.sh` - VNC server and client configuration
  - `tools/rpi/network_boot_setup.sh` - Network boot and PXE provisioning
  - `tools/rpi/deploy_to_pi.sh` - Automated firmware deployment using rsync

### Purpose

The Raspberry Pi Knowledge Base and AsciiDoc Integration enables:

- **Intelligent Coding**: Context-aware suggestions based on datasheets, schematics, and official documentation
- **Hardware Validation**: Cross-reference GPIO functions, power requirements, and mechanical constraints
- **Remote Development**: SSH and VNC automation for Windows-to-Raspberry Pi development
- **Automated Deployment**: Rsync-based firmware deployment with official procedures
- **Network Provisioning**: PXE boot and bare-metal provisioning for Raspberry Pi devices
- **Design Assistance**: Use official documentation for accurate implementations
- **Protocol Validation**: Reference peripheral specifications for I2C, SPI, UART implementations

### Integration

- **Cursor AI**: Indexed for intelligent code completion and validation with AsciiDoc support
- **Cross-Reference**: Datasheets, schematics, KiCAD designs, and official documentation work together
- **Validation Workflow**: Structured approach to hardware and firmware validation
- **Remote Development**: Seamless Windows-to-Raspberry Pi development environment
- **Automation**: Auto-generated scripts based on verified official procedures
- **Best Practices**: Documented guidelines for Raspberry Pi development

---

## [v2-folder-consistency] - December 2024

### Renamed

- **Folder Naming Standardization**: Renamed folders to follow consistent lowercase/PascalCase format
  - `RPI-CUSTOM-BUILD` → `rpi-custom-build` (lowercase with hyphens)
  - `resources/ARDUINO-CLI` → `resources/arduino-cli` (lowercase with hyphens)
  - `resources/ARDUINO-CORE` → `resources/arduino-core` (lowercase with hyphens)
  - `resources/DOCUMENTATIONS` → `resources/legacy-docs` (descriptive name)

### Updated

- **Configuration Files**: Updated all workspace configurations to reflect new folder names
  - `.cursor.mdc`: Added new resource folder paths
  - `.code-workspace`: Updated paths, highlights, and cursor workspace includes
  - `rpi-custom-build-workspace.cursor.mdc`: Updated to reference new folder name
  - `rpi-custom-build-workspace.code-workspace`: Updated paths and highlights
- **Documentation**: Updated all documentation files to reference new folder names
  - `PROJECT_TREE.md`: Updated folder structure documentation
  - `README.md` files: Updated references in all workspace READMEs
  - `index`: Updated navigation references
  - `CHANGELOG.md`: Updated move references
- **Build Scripts**: Updated all build scripts to reference new folder paths
  - `build-systems/CUSTOM-OS-BUILDS/*/build.sh`: Updated PI_GEN_DIR paths
  - `build-systems/CUSTOM-OS-BUILDS/update_imager.sh`: Updated IMAGER_DIR paths
- **Sync Scripts**: Updated GitHub sync scripts to exclude new folder names
- **Wiring Diagrams**: Updated hardware documentation references

### Benefits

- **Consistent Naming**: All folders now follow standard naming conventions
- **Better Readability**: Lowercase names are easier to read and type
- **Improved Navigation**: Consistent naming makes workspace navigation more intuitive
- **Maintained Functionality**: All scripts and configurations updated to work with new names

---

## [v2-firmware-setup] - 2024-12-19

### Added

- **ESP8266 Firmware v2**: `ESP8266/src/firmware_v2.cpp` - Next-gen firmware scaffold with improved light modulation/demodulation, error handling, and diagnostics
- **RPi3 TCP Light Server v2**: `RPI3/src/tcp_light_server_v2.py` - Enhanced TCP server with improved light decoding and retry logic
- **Deployment Scripts**:
  - `tools/flash_all.sh` (macOS/Linux) - Flash all devices in one command
  - `tools/flash_all.ps1` (Windows) - Flash all devices in one command
- **Documentation Updates**:
  - Updated `docs/INTEGRATION_GUIDE.md` with new firmware and deployment integration
  - Updated `docs/PRACTICAL_EXAMPLES.md` with usage examples for new components
- **Workspace Configuration**: Updated `.cursor.mdc` and `.code-workspace` to include new files

### Changed

- **Configuration Cleanup**: Removed references to non-existent `SCRIPTS` directory from `pyrightconfig.json`
- **Indexing**: Rebuilt workspace indexing to ensure only valid folders are referenced

### Fixed

- **Python Environment**: Resolved Python extension loading issues and markdownlint MD050 errors
- **Workspace Structure**: Cleaned up broken folder references in all configuration files

### Technical Details

- ESP8266 firmware includes GPIO pin assignments and TODO placeholders for implementation
- RPi3 server includes retry logic (3 attempts) and GPIO-based light signal decoding
- Deployment scripts include device-specific flashing commands (to be customized)
- All new files include dev comments for hardware pins and GPIO usage

### Testing Status

- ✅ Structural validation complete
- ✅ Configuration files updated and validated
- ✅ Documentation synchronized
- ⏳ Implementation and hardware testing pending

---

## [Previous Versions]

- Initial workspace setup and documentation integration

## [v2-workspace-cleanup] - December 2024

### Removed

- **Comprehensive Archive Cleanup**: Permanently deleted unused and obsolete folders to dramatically reduce workspace size
  - **Conda-related folders**: constructor, menuinst, core, rattler, governance, schemas, maven, .move_manifest.txt
  - **Empty directories**: to_review (already emptied)
  - **Broken symlinks**: WIRING-CORE.DIAGRAM (broken symlink)
  - **Total Space Freed**: ~203MB (from 204MB to 616KB)
  - **Archive Size Reduction**: 99.7% reduction in \_\_archive directory size

### Moved & Organized

- **Arduino Tools**: `arduino-esp8266-serial-plugin` → `tools/arduino/`
- **ESP8266 Tools**: `espsoftwareserial` → `tools/esp8266/`
- **ESP8266 Drivers**: `esp82xx-nonos-linklayer` → `esp/drivers/`
- **Documentation**: `ESP8266-WIKI` → `docs/ESP8266-WIKI/`
- **Utility Scripts**: `scripts` → `tools/scripts/`
- **File System Tools**: `spiffs` → `tools/fs/`
- **Embedded Libraries**:
  - `umm_malloc` → `tools/embedded_libs/`
  - `uzlib-master` → `tools/embedded_libs/uzlib`
- **Raspberry Pi Tools**: `rpi_manager_module` → `tools/rpi/`
- **Deployment Tools**: `deployment` → `build/deployment/`
- **Backend Services**: `FTPClientServer` → `backend/FTPClientServer/`

### Updated

- **Configuration Files**: Updated `.cursor.mdc` and `.code-workspace` to include new organized structure
- **Documentation**: Updated `PROJECT_TREE.md` to reflect new folder organization
- **Workspace Structure**: Improved organization with logical grouping of tools, libraries, and services

### Benefits

- **Massive Space Savings**: 203MB of unnecessary files removed
- **Better Organization**: Tools and libraries now properly categorized
- **Improved Navigation**: Logical folder structure for easier development
- **Maintained Functionality**: All actively used components preserved and properly located

---

## [v2-custom-build-setup] - December 2024

### Added

- **New Raspberry Pi Custom Build Workspace**: Created specialized workspace for advanced kernel, firmware, and OS tooling development
  - `~/GALAHADD.WORKSPACES/rpi-custom-build-workspace/` - New workspace directory
  - `~/GALAHADD.WORKSPACES/rpi-custom-build-workspace/rpi-custom-build-workspace.code-workspace` - VS Code workspace configuration
  - `~/GALAHADD.WORKSPACES/rpi-custom-build-workspace/rpi-custom-build-workspace.cursor.mdc` - Cursor configuration
  - `README.md` - Comprehensive workspace documentation
  - `VERSION.txt` - Version information

### Moved

- **RPI-CUSTOM-BUILD/** → `~/GALAHADD.WORKSPACES/rpi-custom-build-workspace/rpi-custom-build/`
- **bootloader/** → `~/GALAHADD.WORKSPACES/rpi-custom-build-workspace/bootloader/`
- **platformio-vscode-ide/** → `~/GALAHADD.WORKSPACES/rpi-custom-build-workspace/platformio-vscode-ide/`
- **crosstool-NG-lx106/** → `~/GALAHADD.WORKSPACES/rpi-custom-build-workspace/crosstool-NG-lx106/`
- **makeEspArduino/** → `~/GALAHADD.WORKSPACES/rpi-custom-build-workspace/makeEspArduino/`
- **build-systems/** → `~/GALAHADD.WORKSPACES/rpi-custom-build-workspace/build-systems/`

### Removed

- **Unused Conda Folders**: Permanently deleted obsolete Conda packages to reduce workspace size
  - `__archive/conda-libmamba-solver` (1.6MB)
  - `__archive/conda-package-streaming` (5.6MB)
  - `__archive/conda-recipe-manager` (8.5MB)
  - `__archive/conda-standalone` (460KB)
  - **Total Space Freed**: ~16.2MB
  - **Rationale**: Conda can now be installed via remote CLI setup scripts in `setup_python_env.sh` and `requirements.txt`

### Updated

- **docs/README.md**: Added comprehensive documentation about the new Raspberry Pi custom build workspace
- **PROJECT_TREE.md**: Updated to include the new workspace structure and relationships
- **Workspace Architecture**: Now supports three specialized workspaces:
  1. Main Development Workspace (firmware, flashing, deployment)
  2. Simulation Workspace (testing, visualization, protocol validation)
  3. Raspberry Pi Custom Build Workspace (advanced kernel and OS development)

### Configuration

- **Main Workspace**: Excludes `~/GALAHADD.WORKSPACES/rpi-custom-build-workspace/` from indexing
- **Cross-References**: All workspaces can reference each other's documentation
- **Modular Design**: Each workspace operates independently while maintaining integration

### Purpose

The new Raspberry Pi Custom Build Workspace enables:

- Custom kernel development and optimization for Raspberry Pi
- Bootloader customization and firmware modification
- Cross-compilation toolchain setup and management
- Advanced OS tooling for embedded systems
- Build system development and automation

---

## [v2-simulation-workspace] - December 2024

### Added

- **Simulation Workspace**: Created lightweight simulation workspace for testing and visualization
  - `~/GALAHADD.WORKSPACES/simulation-workspace/` - New workspace directory
  - `~/GALAHADD.WORKSPACES/simulation-workspace/simulation-workspace.code-workspace` - VS Code workspace configuration
  - `~/GALAHADD.WORKSPACES/simulation-workspace/simulation-workspace.cursor.mdc` - Cursor configuration
  - `README.md` - Simulation workspace guide
  - `VERSION.txt` - Version information

### Moved

- **WOKWI\_\* folders** → `~/GALAHADD.WORKSPACES/simulation-workspace/`
- **NETWORK.DEV@\* folders** → `~/GALAHADD.WORKSPACES/simulation-workspace/`
- **GALAHADD.PROJECTS-SIMULATION/** → `~/GALAHADD.WORKSPACES/simulation-workspace/`

### Updated

- **docs/README.md**: Added simulation workspace documentation
- **PROJECT_TREE.md**: Updated to include simulation workspace structure
- **Main workspace**: Excludes ~/GALAHADD.WORKSPACES/simulation-workspace/ from indexing

### Purpose

The simulation workspace enables:

- Testing light pulse patterns without physical hardware
- Visualizing TCP/IP packet flows and network behavior
- Validating protocol implementations before deployment
- Debugging communication issues in a controlled environment

---

## [v2-firmware-milestone] - December 2024

### Added

- **Firmware Scaffolding**: Created new firmware files for ESP8266 and RPi3
  - `ESP8266/src/firmware_v2.cpp` - Next-generation ESP8266 firmware
  - `RPI3/src/tcp_light_server_v2.py` - Enhanced RPi3 TCP light server
  - `tools/flash_all.sh` - Multi-device flashing script (macOS/Linux)
  - `tools/flash_all.ps1` - Multi-device flashing script (Windows)

### Updated

- **Documentation**: Enhanced with practical examples and integration guides
- **Deployment Scripts**: Added comprehensive flashing and deployment automation
- **Versioning**: Implemented version management strategy

### Configuration

- **Python Environment**: Optimized for embedded development
- **PlatformIO**: Enhanced configuration for ESP8266 development
- **Cross-Platform**: Support for macOS, Linux, and Windows

---

## [v1-initial-setup] - December 2024

### Added

- **Initial Workspace Setup**: Created main development workspace
- **Core Components**: ESP8266, RPI3, RPI4 firmware development
- **Documentation**: Comprehensive documentation hub with external repositories
- **Tools**: PlatformIO integration and development tools
- **Configuration**: VS Code and Cursor workspace configurations

### Features

- **Multi-Platform Support**: macOS, Linux, and Windows compatibility
- **Documentation Integration**: .NET, Windows IoT, The Things Network, Thinger.io docs
- **Development Environment**: Optimized for embedded systems development
- **Version Control**: Git integration with proper ignore rules

---
 