# Coder Integration Guide for LI-FI Project

## Overview

Coder is a development environment manager that provides web-based IDE access and remote development capabilities. This integration enables:

- **Web-based development** from any browser
- **Remote development** on Raspberry Pi and IoT devices
- **Alternative to VSCode Remote-SSH** for lightweight access
- **Container-based development** environments
- **SSH port forwarding** and secure tunneling

## Installation

### Automatic Installation

```bash
# Run the installation script
./tools/dev/coder_install.sh
```

### Manual Installation

#### Linux/macOS

```bash
curl -L https://coder.com/install.sh | sh
```

#### Windows

1. Download from https://github.com/coder/coder/releases
2. Extract to `%USERPROFILE%\coder\`
3. Add to PATH: `setx PATH "%PATH%;C:\Users\<you>\coder"`

## Quick Start

### 1. Start Coder Server

#### Local Development

```bash
# Start local server
./tools/dev/coder_wrapper.sh local

# Or use the wrapper
coder_wrapper.sh local
```

#### Remote Development

```bash
# Start remote server
./tools/dev/coder_wrapper.sh remote

# Or use the wrapper
coder_wrapper.sh remote
```

### 2. Access Web Interface

Open your browser to:

- **Local**: http://localhost:8080
- **Remote**: http://raspberrypi.local:8080

### 3. Create Workspace

1. Click "Create Workspace"
2. Select template (Python, Node.js, etc.)
3. Configure resources (CPU, RAM, disk)
4. Start development

## VSCode Integration

### Browser-Based Development

Coder provides a full-featured web IDE that includes:

- **Code editor** with syntax highlighting
- **Integrated terminal** with SSH access
- **File browser** and project management
- **Git integration** and version control
- **Debugging support** for multiple languages
- **Extension marketplace** (limited)

### VSCode Remote Development

#### Option 1: Direct SSH Access

```bash
# SSH into Raspberry Pi
ssh pi@raspberrypi.local

# Start Coder server
coder server --address 0.0.0.0:8080

# Access from VSCode
# Use Remote-SSH extension to connect to Raspberry Pi
```

#### Option 2: Port Forwarding

```bash
# Forward Coder port through SSH
ssh -L 8080:localhost:8080 pi@raspberrypi.local

# Access locally
# Open browser to http://localhost:8080
```

#### Option 3: Reverse Tunnel

```bash
# From Raspberry Pi to development machine
ssh -R 8080:localhost:8080 user@dev-machine.local

# Access from development machine
# Open browser to http://localhost:8080
```

### VSCode Extension Integration

#### Coder Extension

```json
// .vscode/extensions.json
{
  "recommendations": ["coder.coder"]
}
```

#### Remote Development Extensions

```json
// .vscode/extensions.json
{
  "recommendations": [
    "ms-vscode-remote.remote-ssh",
    "ms-vscode-remote.remote-containers",
    "ms-vscode-remote.remote-wsl"
  ]
}
```

## Raspberry Pi Integration

### Development Workflow

#### 1. Setup Raspberry Pi

```bash
# Install Coder on Raspberry Pi
curl -L https://coder.com/install.sh | sh

# Create configuration
mkdir -p ~/.config/coder
cat > ~/.config/coder/config.yaml << EOF
address: "0.0.0.0:8080"
access_url: "http://raspberrypi.local:8080"
devurl_host: "raspberrypi.local"
devurl_port: "8080"
tls_enable: false
log_level: "info"
EOF
```

#### 2. Start Development Server

```bash
# Start Coder server
coder server --config ~/.config/coder/config.yaml

# Or use systemd service
sudo systemctl enable coder.service
sudo systemctl start coder.service
```

#### 3. Access from Development Machine

```bash
# SSH tunnel for secure access
ssh -L 8080:localhost:8080 pi@raspberrypi.local

# Or direct access (if on same network)
# Open browser to http://raspberrypi.local:8080
```

### ESP8266 Development

#### Arduino IDE Integration

```bash
# Create Arduino workspace template
coder template create arduino-workspace

# Configure Arduino IDE in workspace
# Install Arduino CLI for headless compilation
```

#### Serial Monitor Access

```bash
# Forward serial port through SSH
ssh -L 115200:localhost:115200 pi@raspberrypi.local

# Access serial monitor in web IDE
# Use built-in terminal for serial communication
```

## Security Configuration

### TLS/SSL Setup

```bash
# Generate self-signed certificate
./tools/security/generate_tls.sh

# Configure Coder with TLS
cat > ~/.config/coder/config.yaml << EOF
address: "0.0.0.0:8080"
access_url: "https://raspberrypi.local:8080"
tls_enable: true
tls_cert_file: "/path/to/cert.pem"
tls_key_file: "/path/to/key.pem"
EOF
```

### Authentication

```bash
# Enable authentication
coder user create admin

# Configure OAuth (if available)
# Set up LDAP integration
# Configure SSO with your organization
```

### Firewall Configuration

```bash
# Allow Coder port
sudo ufw allow 8080/tcp

# Allow SSH
sudo ufw allow ssh

# Enable firewall
sudo ufw enable
```

## Systemd Service Management

### Enable Automatic Startup

```bash
# Setup systemd service
sudo ./tools/dev/setup_coder_service.sh

# Or manually
sudo systemctl enable coder.service
sudo systemctl start coder.service
```

### Service Management

```bash
# Check status
sudo systemctl status coder.service

# View logs
sudo journalctl -u coder.service -f

# Restart service
sudo systemctl restart coder.service
```

### Management Scripts

```bash
# Use management script
manage_coder_service.sh status
manage_coder_service.sh restart
manage_coder_service.sh logs

# Use monitoring script
monitor_coder.sh
```

## Development Templates

### Python Development

```yaml
# python-workspace.yaml
name: "python-dev"
description: "Python development environment"
variables:
  python_version: "3.11"
resources:
  cpu: 2
  memory: 4GB
  disk: 10GB
```

### Arduino/ESP8266 Development

```yaml
# arduino-workspace.yaml
name: "arduino-dev"
description: "Arduino/ESP8266 development environment"
variables:
  arduino_version: "1.8.19"
  board_type: "esp8266"
resources:
  cpu: 1
  memory: 2GB
  disk: 5GB
```

### LI-FI Project Template

```yaml
# lifi-workspace.yaml
name: "lifi-dev"
description: "LI-FI project development environment"
variables:
  python_version: "3.11"
  arduino_version: "1.8.19"
  board_type: "esp8266"
resources:
  cpu: 2
  memory: 4GB
  disk: 10GB
```

## Troubleshooting

### Common Issues

#### Server Not Starting

```bash
# Check if port is in use
sudo netstat -tlnp | grep :8080

# Kill conflicting process
sudo kill -9 <PID>

# Check configuration
coder server --config ~/.config/coder/config.yaml --dry-run
```

#### Connection Issues

```bash
# Check firewall
sudo ufw status

# Test connectivity
curl -I http://localhost:8080

# Check SSH tunnel
ssh -v -L 8080:localhost:8080 pi@raspberrypi.local
```

#### Performance Issues

```bash
# Monitor resource usage
htop

# Check disk space
df -h

# Monitor network
iftop
```

### Log Analysis

```bash
# View Coder logs
journalctl -u coder.service -f

# Check system logs
dmesg | tail

# Monitor access logs
tail -f /var/log/nginx/access.log
```

## Integration with LI-FI Project

### Development Workflow

1. **Setup Development Environment**

   ```bash
   # Install Coder
   ./tools/dev/coder_install.sh

   # Setup systemd service
   sudo ./tools/dev/setup_coder_service.sh
   ```

2. **Create LI-FI Workspace**

   ```bash
   # Create workspace from template
   coder workspace create lifi-dev

   # Or use web interface
   # Access http://localhost:8080
   ```

3. **Development Process**

   ```bash
   # Start development
   coder workspace start lifi-dev

   # Access web IDE
   # Open browser to workspace URL
   ```

4. **Deployment**

   ```bash
   # Build and deploy
   coder workspace build lifi-dev

   # Deploy to Raspberry Pi
   coder workspace deploy lifi-dev
   ```

### Project Structure

```
lifi-workspace/
├── src/
│   ├── python/
│   │   ├── lifi_transmitter.py
│   │   └── lifi_receiver.py
│   └── arduino/
│       ├── esp8266_transmitter.ino
│       └── esp8266_receiver.ino
├── docs/
│   ├── api/
│   └── deployment/
├── tests/
│   ├── unit/
│   └── integration/
└── config/
    ├── development.yaml
    └── production.yaml
```

### CI/CD Integration

#### GitHub Actions

```yaml
# .github/workflows/coder-deploy.yml
name: Deploy to Coder
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy to Coder
        run: |
          coder workspace build lifi-dev
          coder workspace deploy lifi-dev
```

#### Local Development

```bash
# Development workflow
./tools/dev/coder_wrapper.sh local
# Open browser to http://localhost:8080
# Create/start workspace
# Develop and test
# Commit and push changes
```

## Best Practices

### Security

- **Use HTTPS** in production environments
- **Enable authentication** for remote access
- **Configure firewall** rules appropriately
- **Monitor access logs** regularly
- **Use SSH tunneling** for secure access

### Performance

- **Monitor resource usage** regularly
- **Use appropriate workspace sizes** for your needs
- **Clean up unused workspaces** periodically
- **Optimize disk usage** with regular cleanup

### Development

- **Use templates** for consistent environments
- **Version control** your workspace configurations
- **Document workspace setup** procedures
- **Test deployments** in staging environments

### Monitoring

- **Set up alerts** for service failures
- **Monitor resource usage** trends
- **Track user activity** and workspace usage
- **Regular backup** of configurations and data

## Advanced Configuration

### Nginx Reverse Proxy

```nginx
# /etc/nginx/sites-available/coder
server {
    listen 80;
    server_name coder.example.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name coder.example.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Docker Integration

```dockerfile
# Dockerfile for Coder workspace
FROM codercom/enterprise-base:ubuntu

# Install development tools
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    arduino-cli \
    git

# Install Python dependencies
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Setup Arduino
RUN arduino-cli core install esp8266:esp8266

# Copy project files
COPY . /workspace
```

### Kubernetes Deployment

```yaml
# coder-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: coder
spec:
  replicas: 1
  selector:
    matchLabels:
      app: coder
  template:
    metadata:
      labels:
        app: coder
    spec:
      containers:
        - name: coder
          image: codercom/coder:latest
          ports:
            - containerPort: 8080
          env:
            - name: CODER_CONFIG_DIR
              value: "/config"
          volumeMounts:
            - name: config
              mountPath: "/config"
      volumes:
        - name: config
          configMap:
            name: coder-config
```

## Conclusion

Coder provides a powerful alternative to traditional VSCode Remote-SSH workflows, offering:

- **Web-based development** from any device
- **Lightweight resource usage** compared to full VSCode
- **Easy deployment** and management
- **Secure remote access** with proper configuration
- **Integration** with existing development workflows

For the LI-FI project, Coder enables:

- **Remote development** on Raspberry Pi devices
- **ESP8266 development** with web-based Arduino IDE
- **Collaborative development** through web interfaces
- **Automated deployment** and CI/CD integration

This integration complements the existing VNC and SSH workflows, providing additional flexibility for development and deployment scenarios.
