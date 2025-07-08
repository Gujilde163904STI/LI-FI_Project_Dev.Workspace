#!/bin/bash
# scripts/deploy_pi.sh
# Deploy LI-FI Python scripts to Raspberry Pi (TX and RX)
#
# Usage:
#   bash deploy_pi.sh [pi_user] [pi_host] [device_type]
#
#   pi_user:     SSH username (default: pi)
#   pi_host:     Hostname or IP of the Pi (default: raspberrypi.local)
#   device_type: RPI3 or RPI4 (default: RPI3)

set -e

PI_USER=${1:-pi}
PI_HOST=${2:-raspberrypi.local}
DEVICE_TYPE=${3:-RPI3}

PI_PATH="/home/$PI_USER/lifi"

# Select source directory based on device type
if [[ "$DEVICE_TYPE" == "RPI4" ]]; then
    SRC_DIR="../LIFI_FIRMWARE_BUILD/RPI4"
    MAIN_PY="lifi_rpi4_main.py"
else
    SRC_DIR="../LIFI_FIRMWARE_BUILD/RPI3"
    MAIN_PY="lifi_rpi3_main.py"
fi

# Create target directory on Pi
ssh "$PI_USER@$PI_HOST" "mkdir -p $PI_PATH $PI_PATH/config $PI_PATH/lib/utils"

# Copy main firmware script
scp "$SRC_DIR/$MAIN_PY" "$PI_USER@$PI_HOST:$PI_PATH/"

# Copy config and utils (update paths as needed)
scp ../config/settings.json "$PI_USER@$PI_HOST:$PI_PATH/config/"
scp ../lib/utils/serial_utils.py "$PI_USER@$PI_HOST:$PI_PATH/lib/utils/"
scp ../lib/utils/lifi_utils.py "$PI_USER@$PI_HOST:$PI_PATH/lib/utils/"

# Install Python requirements
scp ../requirements.txt "$PI_USER@$PI_HOST:$PI_PATH/"
ssh "$PI_USER@$PI_HOST" "python3 -m pip install --user -r $PI_PATH/requirements.txt"

echo "[INFO] $DEVICE_TYPE Python firmware deployed to Raspberry Pi at $PI_HOST."
