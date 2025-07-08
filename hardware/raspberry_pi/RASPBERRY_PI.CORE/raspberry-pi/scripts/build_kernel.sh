#!/bin/bash
# build_kernel.sh: Build the Raspberry Pi Linux kernel from source
# Usage: ./build_kernel.sh

set -e
cd "$(dirname "$0")/../firmware/linux-kernel"

# Install dependencies (Debian/Ubuntu)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  sudo apt update
  sudo apt install -y git bc bison flex libssl-dev make libc6-dev libncurses5-dev crossbuild-essential-armhf
fi

# Clean and build
make mrproper
KERNEL=kernel7l
make bcm2711_defconfig
make -j$(nproc) zImage modules dtbs

echo "Kernel build complete. Output in arch/arm/boot/ and modules/"
