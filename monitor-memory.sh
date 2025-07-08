#!/bin/bash

# Memory and Swap Monitoring Script for macOS
# Helps track memory usage and swap to maintain optimal performance

echo "🧠 Memory and Swap Monitor"
echo "=========================="

# Function to get memory information
get_memory_info() {
    echo "📊 Current Memory Usage:"
    echo "------------------------"
    
    # Get memory pressure information
    memory_pressure=$(memory_pressure 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo "Memory Pressure: $memory_pressure"
    fi
    
    # Get swap usage (macOS specific)
    swap_usage=$(sysctl vm.swapusage 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo "Swap Usage: $swap_usage"
    fi
    
    # Get memory stats using vm_stat
    echo ""
    echo "Virtual Memory Statistics:"
    vm_stat | head -20
    
    echo ""
    echo "Top Memory Consumers:"
    echo "--------------------"
    ps aux | sort -nr -k 4 | head -10 | awk '{printf "%-15s %6s %6s %s\n", $1, $3"%", $4"%", $11}'
}

# Function to check if swap is over threshold
check_swap_threshold() {
    local threshold_gb=${1:-1}  # Default 1GB threshold
    
    # Extract swap used in bytes and convert to GB
    swap_used_mb=$(sysctl vm.swapusage | grep -o 'used = [0-9.]*M' | grep -o '[0-9.]*')
    
    if [ -n "$swap_used_mb" ]; then
        swap_used_gb=$(echo "scale=2; $swap_used_mb / 1024" | bc 2>/dev/null)
        
        if [ -n "$swap_used_gb" ]; then
            echo "Current swap usage: ${swap_used_gb}GB"
            
            # Compare with threshold
            if (( $(echo "$swap_used_gb > $threshold_gb" | bc -l) )); then
                echo "⚠️  WARNING: Swap usage (${swap_used_gb}GB) exceeds threshold (${threshold_gb}GB)"
                echo "💡 Consider:"
                echo "   - Closing unnecessary applications"
                echo "   - Restarting VS Code"
                echo "   - Upgrading RAM if this is chronic"
                return 1
            else
                echo "✅ Swap usage is within acceptable limits"
                return 0
            fi
        fi
    fi
    
    echo "❓ Unable to determine swap usage"
    return 2
}

# Function to get system specs
get_system_specs() {
    echo "💻 System Specifications:"
    echo "------------------------"
    
    # Get total memory
    total_memory=$(sysctl hw.memsize | awk '{print $2}')
    total_memory_gb=$(echo "scale=2; $total_memory / 1024 / 1024 / 1024" | bc 2>/dev/null)
    echo "Total RAM: ${total_memory_gb}GB"
    
    # Get CPU info
    cpu_brand=$(sysctl machdep.cpu.brand_string | cut -d: -f2 | sed 's/^ *//')
    echo "CPU: $cpu_brand"
    
    # Get macOS version
    os_version=$(sw_vers -productVersion)
    echo "macOS: $os_version"
}

# Function to show memory optimization tips
show_memory_tips() {
    echo "💡 Memory Optimization Tips:"
    echo "  1. Keep swap usage below 1GB"
    echo "  2. Close unused applications and browser tabs"
    echo "  3. Use Activity Monitor to identify memory leaks"
    echo "  4. Restart VS Code if it consumes excessive memory"
    echo "  5. Consider upgrading RAM if swap usage is chronic"
    echo "  6. Use container resource limits to prevent runaway processes"
    echo "  7. Monitor background processes and helper apps"
}

# Function to continuously monitor (useful for troubleshooting)
continuous_monitor() {
    local interval=${1:-30}  # Default 30 seconds
    echo "🔄 Starting continuous monitoring (interval: ${interval}s)"
    echo "Press Ctrl+C to stop..."
    
    while true; do
        clear
        echo "$(date): Memory Monitor"
        echo "======================"
        get_memory_info
        echo ""
        check_swap_threshold
        echo ""
        echo "Next update in ${interval} seconds..."
        sleep "$interval"
    done
}

# Main menu
case "$1" in
    "info"|"--info")
        get_memory_info
        ;;
    "check"|"--check")
        threshold=${2:-1}
        check_swap_threshold "$threshold"
        ;;
    "specs"|"--specs")
        get_system_specs
        ;;
    "tips"|"--tips")
        show_memory_tips
        ;;
    "monitor"|"--monitor")
        interval=${2:-30}
        continuous_monitor "$interval"
        ;;
    *)
        echo "Usage: $0 [info|check|specs|tips|monitor] [options]"
        echo ""
        echo "Commands:"
        echo "  info     - Show current memory usage"
        echo "  check    - Check swap threshold (default: 1GB)"
        echo "  specs    - Show system specifications"
        echo "  tips     - Show memory optimization tips"
        echo "  monitor  - Continuous monitoring (default: 30s interval)"
        echo ""
        echo "Examples:"
        echo "  $0 info"
        echo "  $0 check 2    # Check with 2GB threshold"
        echo "  $0 monitor 60 # Monitor every 60 seconds"
        ;;
esac
