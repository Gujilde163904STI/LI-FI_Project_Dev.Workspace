#!/usr/bin/env bash
set -e

# Network targets
TARGETS=(
    "ESP8266:192.168.1.100:23"
    "RPi3:192.168.1.101:22"
    "RPi4:192.168.1.102:22"
)

# Network interfaces to check
INTERFACES=("wlan0" "eth0" "usb0")

check_interface() {
    local interface=$1
    if ip link show "$interface" >/dev/null 2>&1; then
        echo "[OK] Interface $interface is up"
        return 0
    else
        echo "[FAIL] Interface $interface is down"
        return 1
    fi
}

ping_target() {
    local name=$1
    local ip=$2
    local port=$3
    
    echo "Checking $name ($ip:$port)..."
    
    # Ping test
    if ping -c 1 -W 2 "$ip" >/dev/null 2>&1; then
        echo "  [OK] Ping successful"
    else
        echo "  [FAIL] Ping failed"
        return 1
    fi
    
    # Port test
    if timeout 3 bash -c "</dev/tcp/$ip/$port" 2>/dev/null; then
        echo "  [OK] Port $port accessible"
    else
        echo "  [FAIL] Port $port not accessible"
        return 1
    fi
    
    return 0
}

check_network_interfaces() {
    echo "=== Network Interface Check ==="
    local any_up=false
    for interface in "${INTERFACES[@]}"; do
        if check_interface "$interface"; then
            any_up=true
        fi
    done
    
    if [[ "$any_up" == false ]]; then
        echo "[ERROR] No network interfaces are up!"
        return 1
    fi
    return 0
}

check_targets() {
    echo "=== Target Device Check ==="
    local all_ok=true
    
    for target in "${TARGETS[@]}"; do
        IFS=':' read -r name ip port <<< "$target"
        if ! ping_target "$name" "$ip" "$port"; then
            all_ok=false
        fi
    done
    
    if [[ "$all_ok" == false ]]; then
        echo "[WARN] Some targets are not reachable"
        return 1
    fi
    return 0
}

check_internet() {
    echo "=== Internet Connectivity Check ==="
    if ping -c 1 -W 5 8.8.8.8 >/dev/null 2>&1; then
        echo "[OK] Internet connectivity available"
        return 0
    else
        echo "[FAIL] No internet connectivity"
        return 1
    fi
}

main() {
    echo "LI-FI Network Readiness Check"
    echo "============================="
    
    local exit_code=0
    
    if ! check_network_interfaces; then
        exit_code=1
    fi
    
    if ! check_internet; then
        exit_code=1
    fi
    
    if ! check_targets; then
        exit_code=1
    fi
    
    echo ""
    if [[ $exit_code -eq 0 ]]; then
        echo "[SUCCESS] Network is ready for deployment!"
    else
        echo "[WARNING] Network has issues. Check connectivity before deploying."
    fi
    
    exit $exit_code
}

main 