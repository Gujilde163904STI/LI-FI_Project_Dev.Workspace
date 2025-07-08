#!/usr/bin/env bash
set -e

LOG_LEVELS=("info" "warn" "error" "debug")
TIME_RANGES=("5m" "15m" "1h" "6h" "1d")

show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -l, --level LEVEL    Log level (info, warn, error, debug)"
    echo "  -t, --time RANGE     Time range (5m, 15m, 1h, 6h, 1d)"
    echo "  -n, --lines N        Number of lines to show (default: 50)"
    echo "  -f, --follow         Follow logs in real-time"
    echo "  -e, --errors         Show only error logs"
    echo "  -b, --build          Show only build logs"
    echo "  -h, --help           Show this help"
}

LEVEL="info"
TIME_RANGE="15m"
LINES=50
FOLLOW=false
ERRORS_ONLY=false
BUILD_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -l|--level)
            LEVEL="$2"
            shift 2
            ;;
        -t|--time)
            TIME_RANGE="$2"
            shift 2
            ;;
        -n|--lines)
            LINES="$2"
            shift 2
            ;;
        -f|--follow)
            FOLLOW=true
            shift
            ;;
        -e|--errors)
            ERRORS_ONLY=true
            shift
            ;;
        -b|--build)
            BUILD_ONLY=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Check if Skaffold is running
if ! systemctl --user is-active --quiet skaffold.service; then
    echo "[WARN] Skaffold service is not running."
    read -p "Start it now? [Y/n]: " yn
    yn=${yn:-Y}
    if [[ "$yn" =~ ^[Yy]$ ]]; then
        systemctl --user start skaffold.service
        echo "Started skaffold.service"
    else
        echo "No logs to show without Skaffold running."
        exit 1
    fi
fi

# Build journalctl command
CMD="journalctl --user -u skaffold.service --since $TIME_RANGE -n $LINES"

if [[ "$ERRORS_ONLY" == true ]]; then
    CMD="$CMD | grep -i error"
elif [[ "$BUILD_ONLY" == true ]]; then
    CMD="$CMD | grep -i build"
fi

if [[ "$FOLLOW" == true ]]; then
    CMD="$CMD -f"
fi

echo "[INFO] Showing Skaffold logs (level: $LEVEL, time: $TIME_RANGE, lines: $LINES)"
echo "Command: $CMD"
echo "---"

eval $CMD 