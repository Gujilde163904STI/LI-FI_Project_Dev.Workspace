# LI-FI Project Development Workspace

A comprehensive development environment for light-based TCP/IP communication using Raspberry Pi and ESP8266 devices, with separate workspaces for development and simulation.

## 🏗️ Workspace Architecture

This project consists of two modular workspaces:

### **Main Development Workspace** (`LI-FI_Project_Dev.Workspace`)

- **Purpose**: Firmware development, device flashing, and deployment
- **Focus**: Production-ready code for ESP8266, Raspberry Pi 3/4, and hardware integration
- **Components**: Firmware, deployment scripts, documentation, backend services

### **Simulation Workspace** (`~/GALAHADD.WORKSPACES/simulation-workspace/`)

- **Purpose**: Testing, visualization, and protocol validation
- **Focus**: Light pulse simulation, TCP/IP flow visualization, protocol testing
- **Components**: Wokwi simulations, network protocols, framework testing

## 🚀 Quick Start

### Prerequisites

- Python 3.12+
- PlatformIO (for ESP8266 development)
- Git
- VS Code or Cursor IDE

### Main Development Workspace Setup

```bash
# Clone the repository
git clone <repository-url>
cd LI-FI_Project_Dev.Workspace

# Set up Python environment
./setup_python_env.sh

# Open the development workspace
code LI-FI_Project_Dev.Workspace.code-workspace
```

### Simulation Workspace Setup

```bash
# Navigate to simulation workspace
cd ~/GALAHADD.WORKSPACES/simulation-workspace/

# Open the simulation workspace
code ~/GALAHADD.WORKSPACES/simulation-workspace/simulation-workspace.code-workspace
```

## 📁 Project Structure

### Main Development Workspace

```
LI-FI_Project_Dev.Workspace/
├── ESP8266/                 # ESP8266 firmware and tools
│   └── src/
│       ├── main.cpp         # Current firmware
│       └── firmware_v2.cpp  # Next-gen firmware
├── RPI3/                    # Raspberry Pi 3 components
│   └── src/
│       ├── main.py          # Current server
│       └── tcp_light_server_v2.py  # Enhanced server
├── RPI4/                    # Raspberry Pi 4 components
├── tools/                   # Deployment and build tools
│   ├── flash_all.sh         # Multi-device flashing (macOS/Linux)
│   └── flash_all.ps1        # Multi-device flashing (Windows)
├── docs/                    # Comprehensive documentation
│   ├── README.md            # Documentation hub
│   ├── INTEGRATION_GUIDE.md # Integration guide
│   └── PRACTICAL_EXAMPLES.md # Usage examples
├── backend/                 # Backend services
├── hardware/                # Hardware specifications
└── config/                  # Configuration files
```

### Simulation Workspace

```
~/GALAHADD.WORKSPACES/simulation-workspace/
├── WOKWI_BUILD_RPi3/        # Raspberry Pi 3 simulation
├── WOKWI_BUILD_RPi4/        # Raspberry Pi 4 simulation
├── WOKWI_FLASH_ESP8266/     # ESP8266 simulation
├── NETWORK.DEV@PROTOCOL/    # Network protocols
├── NETWORK.DEV@FRAMEWORKS/  # IoT frameworks
├── GALAHADD.PROJECTS-SIMULATION/  # Main simulation environment
└── README.md                # Simulation workspace guide
```

## 🔧 Development Workflow

### 1. Firmware Development

```bash
# ESP8266 development
cd ESP8266/
platformio run --target upload

# Raspberry Pi development
cd RPI3/src/
python3 tcp_light_server_v2.py
```

### 2. Deployment

```bash
# Flash all devices (macOS/Linux)
cd tools/
./flash_all.sh

# Flash all devices (Windows)
cd tools/
./flash_all.ps1
```

### 3. Testing & Simulation

```bash
# Open simulation workspace
cd ~/GALAHADD.WORKSPACES/simulation-workspace/
code ~/GALAHADD.WORKSPACES/simulation-workspace/simulation-workspace.code-workspace

# Run specific simulations
cd WOKWI_FLASH_ESP8266/
# Follow simulation-specific instructions
```

## 📚 Documentation

### Main Documentation

- **[Integration Guide](docs/INTEGRATION_GUIDE.md)**: Complete integration instructions
- **[Practical Examples](docs/PRACTICAL_EXAMPLES.md)**: Usage examples and workflows
- **[Documentation Hub](docs/README.md)**: Centralized documentation index

### Simulation Documentation

- **[Simulation Workspace Guide](~/GALAHADD.WORKSPACES/simulation-workspace/README.md)**: Simulation-specific documentation

### Version Information

- **[Changelog](CHANGELOG.md)**: Version history and changes
- **[Versioning Guide](versioning.md)**: Version management strategy

## 🔄 Workspace Synchronization

Both workspaces are designed to work independently or in parallel:

- **Independent Development**: Work on firmware in main workspace, test in simulation
- **Parallel Development**: Use both workspaces simultaneously for development and testing
- **Shared Documentation**: Both workspaces reference the same documentation base

## 🛠️ Automation Scripts

### Environment Setup

- **Main Workspace**: `run_dev_env.sh` / `run_dev_env.ps1`
- **Simulation Workspace**: `run_sim_env.sh` / `run_sim_env.ps1`

### Quick Commands

```bash
# Set up and run main development environment
./run_dev_env.sh

# Set up and run simulation environment
cd ~/GALAHADD.WORKSPACES/simulation-workspace/
./run_sim_env.sh
```

## 📋 Version Information

- **Current Version**: v2-firmware-setup
- **Last Updated**: December 2024
- **Status**: Development and simulation workspaces separated and operational

## 🤝 Contributing

1. Use the appropriate workspace for your work (development vs. simulation)
2. Follow the documentation structure
3. Update version information when making significant changes
4. Test in simulation before deploying to hardware

## 📄 License

[Add your license information here]

---

**For detailed setup instructions, see [docs/INTEGRATION_GUIDE.md](docs/INTEGRATION_GUIDE.md)**
**For usage examples, see [docs/PRACTICAL_EXAMPLES.md](docs/PRACTICAL_EXAMPLES.md)**
**For simulation details, see [~/GALAHADD.WORKSPACES/simulation-workspace/README.md](~/GALAHADD.WORKSPACES/simulation-workspace/README.md)**
