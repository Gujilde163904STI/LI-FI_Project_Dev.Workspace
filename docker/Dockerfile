# syntax=docker/dockerfile:1

ARG FROM_IMAGE=python:3.11-slim
FROM ${FROM_IMAGE}

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PLATFORMIO_CORE_DIR=/workspace/.pio
ENV ARDUINO_CLI_DIR=/workspace/.arduino15

# Install system dependencies and Node.js with cache mounts
# Pre-create cache directories with proper permissions to avoid permission issues
# when using BuildKit cache mounts, which can cause issues if directories don't exist
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    mkdir -p /var/lib/apt/lists/partial && \
    chmod 0755 /var/lib/apt/lists /var/lib/apt/lists/partial && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        wget \
        git \
        build-essential \
        cmake \
        pkg-config \
        libusb-1.0-0-dev \
        libudev-dev \
        udev \
        minicom \
        screen \
        vim \
        nano \
        htop \
        tree \
        avrdude \
        sudo \
        rsync \
        openssh-client \
        make \
        ca-certificates && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install PlatformIO
RUN python -m pip install --upgrade pip setuptools wheel
RUN python -m pip install platformio

# Install ESP-IDF prerequisites
RUN apt-get update && apt-get install -y \
    flex bison gperf \
    python3-venv \
    ccache \
    libffi-dev libssl-dev dfu-util \
    && rm -rf /var/lib/apt/lists/*

# Install ESP-IDF
ENV IDF_PATH=/opt/esp-idf
ENV ESP_IDF_VERSION=v5.1.1
RUN mkdir -p /opt && \
    cd /opt && \
    git clone --recursive --depth 1 --branch ${ESP_IDF_VERSION} https://github.com/espressif/esp-idf.git && \
    cd esp-idf && \
    ./install.sh all && \
    . ./export.sh

# Add ESP-IDF to PATH
ENV PATH="${IDF_PATH}/tools:${PATH}"

# Install Arduino CLI
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        ARDUINO_ARCH="Linux_64bit"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        ARDUINO_ARCH="Linux_ARM64"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    curl -fsSL https://downloads.arduino.cc/arduino-cli/arduino-cli_latest_${ARDUINO_ARCH}.tar.gz | tar xz -C /usr/local/bin arduino-cli

# Install Python dependencies
RUN python -m pip install \
    pyserial \
    click \
    rich \
    requests \
    watchdog \
    flask \
    qrcode[pil]

# Create workspace directory
WORKDIR /workspace

# Create directories for serial devices and cache
RUN mkdir -p /workspace/.pio /workspace/.arduino15 /workspace/.cache

# Copy entrypoint script
COPY tools/dev/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import serial; print('Container healthy')" || exit 1

# Expose ports for debugging and web interfaces
EXPOSE 5678 8080 5050 7080

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Default command (interactive shell)
CMD ["/bin/bash"]
