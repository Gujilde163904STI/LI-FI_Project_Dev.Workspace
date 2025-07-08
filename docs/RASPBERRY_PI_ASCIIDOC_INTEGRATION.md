# Raspberry Pi AsciiDoc Integration Guide

This document provides comprehensive guidance for using the official Raspberry Pi AsciiDoc documentation to enable intelligent coding, automation, and remote development workflows.

## 📚 Documentation Structure

### Official Documentation Location

- **Path**: `docs/raspberrypi-documentation/`
- **Source**: Official Raspberry Pi documentation in AsciiDoc format
- **Purpose**: Verified, official procedures for LI-FI system deployment

### Key Documentation Categories

#### **Remote Access** (`documentation/asciidoc/computers/remote-access/`)

- **SSH**: `ssh.adoc` - Secure shell access and configuration
- **VNC**: `vnc.adoc` - Remote GUI access and desktop sharing
- **Rsync**: `rsync.adoc` - File transfer and deployment automation
- **Network Boot**: `network-boot-raspberry-pi.adoc` - PXE boot and provisioning
- **SCP**: `scp.adoc` - Secure file copy operations
- **Samba**: `samba.adoc` - Windows file sharing integration

#### **System Configuration** (`documentation/asciidoc/computers/`)

- **OS**: `os.adoc` - Operating system management
- **Configuration**: `configuration.adoc` - System configuration
- **Config.txt**: `config_txt.adoc` - Boot configuration
- **Linux Kernel**: `linux_kernel.adoc` - Kernel development

#### **Hardware Documentation** (`documentation/asciidoc/computers/`)

- **Raspberry Pi**: `raspberry-pi.adoc` - Hardware specifications
- **Processors**: `processors.adoc` - CPU and SoC information
- **Camera**: `camera_software.adoc` - Camera module integration

## 🧠 Intelligent Coding Integration

### AsciiDoc File Processing

- **Parsing**: Cursor can read and understand `.adoc` files
- **Indexing**: All documentation is indexed for search and reference
- **Cross-Reference**: Automatic linking between related documentation
- **Code Generation**: Auto-suggest scripts and configs from documentation

### Mission-Critical Topics

#### **Remote Access (SSH/VNC)**

- **Priority**: 🔴 HIGH PRIORITY
- **Use Case**: Enable remote development from Windows to Raspberry Pi
- **Documentation**: `ssh.adoc`, `vnc.adoc`
- **Auto-Generated**: SSH configs, VNC setup scripts, connection tests

#### **File Transfer and Deployment (Rsync)**

- **Priority**: 🔴 HIGH PRIORITY
- **Use Case**: Automated firmware deployment to Raspberry Pi devices
- **Documentation**: `rsync.adoc`
- **Auto-Generated**: Deployment scripts, sync automation, file management

#### **Network Boot and Provisioning**

- **Priority**: 🔴 HIGH PRIORITY
- **Use Case**: Bare-metal provisioning and recovery of Raspberry Pi devices
- **Documentation**: `network-boot-raspberry-pi.adoc`
- **Auto-Generated**: PXE setup, DHCP configs, TFTP configurations

## 🛠️ Generated Automation Scripts

### SSH Configuration (`tools/rpi/ssh_config_setup.sh`)

- **Based on**: `ssh.adoc`
- **Features**:
  - SSH key generation and management
  - Multi-device SSH configuration
  - VSCode/Cursor remote development setup
  - Connection testing and validation
  - Windows development environment optimization

### VNC Configuration (`tools/rpi/vnc_setup.sh`)

- **Based on**: `vnc.adoc`
- **Features**:
  - RealVNC and TigerVNC server setup
  - Windows VNC client configuration
  - Remote GUI access optimization
  - VNC service management
  - Connection testing and monitoring

### Network Boot Setup (`tools/rpi/network_boot_setup.sh`)

- **Based on**: `network-boot-raspberry-pi.adoc`
- **Features**:
  - TFTP server configuration
  - DHCP server setup for PXE boot
  - Raspberry Pi boot file management
  - Network boot monitoring
  - Automated provisioning workflows

### Deployment Automation (`tools/rpi/deploy_to_pi.sh`)

- **Based on**: `rsync.adoc`
- **Features**:
  - Automated firmware deployment
  - Incremental file synchronization
  - Service restart automation
  - Multi-device deployment
  - Error handling and validation

## 🔧 Workspace Integration

### Cursor Configuration

- **AsciiDoc Support**: Full parsing and indexing of `.adoc` files
- **Intelligent Suggestions**: Context-aware code generation from documentation
- **Cross-Reference**: Automatic linking between documentation and code
- **Live Preview**: AsciiDoc rendering and navigation

### VS Code Integration

- **Remote Development**: SSH-based development on Raspberry Pi
- **File Synchronization**: Automatic sync between Windows and Pi
- **Extension Support**: Remote-SSH, AsciiDoc preview, and more
- **IntelliSense**: Documentation-aware code completion

## 🎯 Usage Workflows

### 1. Remote Development Setup

```bash
# Setup SSH for remote development
./tools/rpi/ssh_config_setup.sh

# Test connections
./tools/rpi/test_connections.sh

# Connect with VSCode/Cursor
# Use Remote-SSH extension with hostnames: rpi3, rpi4, rpi3-lifi, rpi4-lifi
```

### 2. VNC Remote GUI Access

```bash
# Setup VNC on Raspberry Pi
./tools/rpi/vnc_setup.sh rpi4-lifi

# Connect via VNC (Windows)
./tools/rpi/connect_vnc.ps1 rpi4-lifi

# Test VNC connections
./tools/rpi/test_vnc.sh
```

### 3. Automated Deployment

```bash
# Deploy firmware to Raspberry Pi
./tools/rpi/deploy_to_pi.sh rpi4-lifi

# Monitor deployment
./tools/rpi/test_connections.sh
```

### 4. Network Boot Provisioning

```bash
# Setup network boot server (requires root)
sudo ./tools/rpi/network_boot_setup.sh

# Configure Raspberry Pi 4 for network boot
scp tools/rpi/setup_network_boot.sh rpi4-lifi:~/
ssh rpi4-lifi 'chmod +x ~/setup_network_boot.sh && ~/setup_network_boot.sh'

# Test network boot
./tools/rpi/test_network_boot.sh
```

## 📋 Configuration Files

### SSH Configuration (`~/.ssh/config`)

```ssh
# Auto-generated SSH configuration
Host rpi3 rpi4 rpi3-lifi rpi4-lifi
    HostName 192.168.1.xxx
    User pi
    IdentityFile ~/.ssh/id_rsa
    ForwardX11 yes
    ForwardAgent yes
    ControlMaster auto
    ControlPath ~/.ssh/control-%r@%h:%p
    ControlPersist 10m
```

### VNC Service Configuration (`tools/rpi/vncserver.service`)

```ini
[Unit]
Description=TigerVNC Server
After=network.target

[Service]
Type=forking
User=pi
WorkingDirectory=/home/pi
ExecStart=/usr/bin/vncserver -depth 24 -geometry 1920x1080 :%i

[Install]
WantedBy=multi-user.target
```

### DHCP Configuration (`/etc/dhcp/dhcpd.conf`)

```dhcp
# Network boot DHCP configuration
subnet 192.168.1.0 netmask 255.255.255.0 {
    range 192.168.1.100 192.168.1.200;
    option tftp-server-name "192.168.1.1";
    option bootfile-name "bootcode.bin";

    host rpi4-lifi {
        hardware ethernet dc:a6:32:00:00:01;
        fixed-address 192.168.1.111;
    }
}
```

## 🔍 Documentation References

### Official Documentation Files

- **SSH**: `docs/raspberrypi-documentation/documentation/asciidoc/computers/remote-access/ssh.adoc`
- **VNC**: `docs/raspberrypi-documentation/documentation/asciidoc/computers/remote-access/vnc.adoc`
- **Rsync**: `docs/raspberrypi-documentation/documentation/asciidoc/computers/remote-access/rsync.adoc`
- **Network Boot**: `docs/raspberrypi-documentation/documentation/asciidoc/computers/remote-access/network-boot-raspberry-pi.adoc`

### Generated Scripts

- **SSH Setup**: `tools/rpi/ssh_config_setup.sh`
- **VNC Setup**: `tools/rpi/vnc_setup.sh`
- **Network Boot**: `tools/rpi/network_boot_setup.sh`
- **Deployment**: `tools/rpi/deploy_to_pi.sh`
- **Connection Tests**: `tools/rpi/test_connections.sh`, `tools/rpi/test_vnc.sh`

## 🚀 Best Practices

### Documentation-Driven Development

1. **Reference First**: Always check official documentation before implementation
2. **Auto-Generate**: Use documentation to generate scripts and configs
3. **Validate**: Cross-reference generated code with official procedures
4. **Update**: Keep documentation and generated scripts synchronized

### Remote Development Workflow

1. **SSH Setup**: Configure secure remote access
2. **VNC Access**: Enable remote GUI when needed
3. **File Sync**: Use rsync for efficient deployment
4. **Network Boot**: Enable automated provisioning

### Windows Development Environment

1. **WSL Integration**: Use Windows Subsystem for Linux
2. **SSH Keys**: Generate and manage SSH keys properly
3. **VNC Viewer**: Install RealVNC or TigerVNC viewer
4. **Remote Extensions**: Use VSCode Remote-SSH extension

## 📝 Integration with Project Files

### Existing Project Integration

- **`tools/scripts/restructure_lifi.sh`**: Can reference AsciiDoc for deployment procedures
- **`tools/rpi/flash_pi.sh`**: Can use network boot documentation for provisioning
- **`RPI3/src/ssh_bootstrap.py`**: Can reference SSH documentation for configuration
- **`RPI4/config/netboot_setup.sh`**: Can use network boot documentation for setup

### Future Enhancements

- **Smart Tooltips**: AsciiDoc content in code editor tooltips
- **Quick Commands**: Documentation-based command templates
- **Validation**: Cross-reference code with official procedures
- **Automation**: Generate scripts from documentation examples

---

**Note**: This integration enables seamless remote development between Windows and Raspberry Pi devices, with all procedures based on verified official documentation.
