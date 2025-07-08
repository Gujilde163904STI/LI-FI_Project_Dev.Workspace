# Multi-Stage Docker Build Guide

This guide explains the optimized multi-stage Docker build setup for the LI-FI project, focusing on build caching, multi-architecture support, and development container optimization.

## Overview

The Dockerfile has been refactored to use a multi-stage build approach with two main stages:

1. **Build Stage (`tools`)**: Installs build tools and dependencies
2. **Runtime Stage (`dev`)**: Creates the final development environment

## Key Features

### 🏗️ Multi-Stage Build Architecture

- **Separation of Concerns**: Build tools are isolated from the runtime environment
- **Smaller Final Image**: Only necessary runtime dependencies are included
- **Faster Rebuilds**: Cached layers speed up subsequent builds

### 🚀 Build Caching Optimization

- **BuildKit Cache Mounts**: Uses `--mount=type=cache` for apt and pip operations
- **Layer Caching**: Optimized layer ordering for maximum cache reuse
- **Registry Cache**: Support for external cache registries

### 🔧 ARG-Driven Configuration

- **Base Image Selection**: Switch between architectures (e.g., `python:3.11-slim`, `arm64v8/python:3.11-slim`)
- **User/Group Mapping**: Matches host UID/GID for proper file permissions
- **Target Board Configuration**: Customizable target board selection

## Build Arguments

| Argument | Default | Description |
|----------|---------|-------------|
| `BASE_IMAGE` | `python:3.11-slim` | Base Python image |
| `USER_ID` | `1000` | Host user ID for file permissions |
| `GROUP_ID` | `1000` | Host group ID for file permissions |
| `TARGET_BOARD` | `generic` | Target board for embedded development |

## Usage Examples

### Basic Build

```bash
# Build with default settings
./build-docker.sh

# Or manually with docker buildx
docker buildx build --target dev --tag lifi-dev .
```

### Multi-Architecture Builds

```bash
# Build for ARM64 (Raspberry Pi)
./build-docker.sh --base-image arm64v8/python:3.11-slim --arch linux/arm64

# Build for AMD64 (Intel/AMD)
./build-docker.sh --base-image python:3.11-slim --arch linux/amd64
```

### With Cache Registry

```bash
# Use external registry for caching
./build-docker.sh --cache-registry registry.example.com/cache --push-cache

# Build with cache from registry
./build-docker.sh --cache-registry registry.example.com/cache
```

### Target-Specific Builds

```bash
# Build for ESP32 development
./build-docker.sh --target-board esp32 --tag lifi-esp32

# Build for Arduino Uno
./build-docker.sh --target-board uno --tag lifi-uno
```

## Cache Mount Benefits

The new Dockerfile uses BuildKit cache mounts for:

- **APT Package Cache**: `/var/cache/apt` and `/var/lib/apt`
- **PIP Package Cache**: `/root/.cache/pip`
- **User Permissions**: `uid=1000,gid=1000` ensures proper cache ownership

This results in:
- **Faster Builds**: Packages are downloaded only once
- **Reduced Network Usage**: Cached packages are reused
- **Better CI/CD Performance**: Significant speedup in automated builds

## File Structure

```
├── Dockerfile              # Multi-stage build configuration
├── .dockerignore           # Build context optimization
├── build-docker.sh         # Build script with advanced options
└── DOCKER_BUILD_GUIDE.md   # This documentation
```

## Build Stages Explained

### Stage 1: `tools` (Build Stage)

- Installs build dependencies (build-essential, curl, git)
- Downloads and installs Node.js LTS
- Installs Python packages (PlatformIO, pyserial)
- Downloads Arduino CLI
- Uses cache mounts for all package operations

### Stage 2: `dev` (Runtime Stage)

- Copies compiled binaries and packages from build stage
- Installs only runtime system dependencies
- Creates development user with proper permissions
- Sets up workspace and development environment
- Configures entrypoint and health checks

## Performance Optimizations

### Build Time Improvements

1. **Parallel Builds**: Multi-stage allows parallel processing
2. **Cache Reuse**: Shared cache across builds
3. **Layer Optimization**: Minimal layer rebuilds
4. **Context Filtering**: `.dockerignore` reduces build context

### Runtime Optimizations

1. **Smaller Images**: Runtime stage excludes build tools
2. **User Permissions**: Proper UID/GID mapping
3. **Environment Variables**: Optimized Python settings
4. **Health Checks**: Container health monitoring

## Development Workflow

### Initial Build

```bash
# First build (downloads everything)
./build-docker.sh --tag lifi-dev-v1
```

### Subsequent Builds

```bash
# Fast rebuild (uses cache)
./build-docker.sh --tag lifi-dev-v2
```

### Running the Container

```bash
# Basic development container
docker run -it --rm --privileged -v $(pwd):/workspace lifi-dev

# With serial device access
docker run -it --rm --privileged --device=/dev/ttyUSB0 -v $(pwd):/workspace lifi-dev

# With additional ports exposed
docker run -it --rm --privileged -p 5678:5678 -p 9229:9229 -v $(pwd):/workspace lifi-dev
```

## Troubleshooting

### Build Issues

1. **Cache Permission Errors**: Ensure BuildKit is enabled
2. **Architecture Mismatches**: Verify base image architecture
3. **Network Timeouts**: Check firewall and proxy settings

### Runtime Issues

1. **Permission Errors**: Verify USER_ID and GROUP_ID match host
2. **Device Access**: Ensure `--privileged` flag is used
3. **Port Conflicts**: Check exposed ports are available

## Advanced Configuration

### Custom Base Images

```bash
# Use different Python version
./build-docker.sh --base-image python:3.10-slim

# Use Alpine Linux
./build-docker.sh --base-image python:3.11-alpine
```

### Environment Customization

```bash
# Set custom environment variables
docker buildx build \
  --build-arg BASE_IMAGE=python:3.11-slim \
  --build-arg TARGET_BOARD=esp32 \
  --build-arg USER_ID=$(id -u) \
  --build-arg GROUP_ID=$(id -g) \
  --target dev \
  --tag lifi-custom .
```

## Best Practices

1. **Use Cache Mounts**: Always use BuildKit with cache mounts
2. **Match Host Permissions**: Set correct USER_ID and GROUP_ID
3. **Optimize Build Context**: Keep `.dockerignore` updated
4. **Version Tags**: Use semantic versioning for image tags
5. **Regular Updates**: Keep base images and dependencies updated

## Integration with CI/CD

The multi-stage build setup is optimized for CI/CD pipelines:

- **Registry Caching**: Reduces build times in CI
- **Multi-Architecture**: Supports various deployment targets
- **Reproducible Builds**: Consistent environments across teams
- **Security**: Minimal attack surface in runtime images

## Security Considerations

- **Non-Root User**: Runtime stage runs as unprivileged user
- **Minimal Dependencies**: Only necessary packages in final image
- **No Secrets**: No secrets embedded in image layers
- **Regular Updates**: Base images should be updated regularly
