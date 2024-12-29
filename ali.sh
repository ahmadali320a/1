#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Matrix effect
matrix_effect() {
    local lines=25
    local cols=80
    for ((i=0; i<$lines; i++)); do
        for ((j=0; j<$cols; j++)); do
            if [ $((RANDOM % 2)) -eq 0 ]; then
                echo -ne "${GREEN}$(printf \\$(printf '%03o' $((RANDOM % 93 + 33))))${NC}"
            else
                echo -n " "
            fi
        done
        echo
        sleep 0.02
    done
}

# Typing effect
type_text() {
    local text="$1"
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep 0.03
    done
    echo
}

# Loading bar with percentage
show_loading_bar() {
    local width=50
    local percent=0
    while [ $percent -le 100 ]; do
        local filled=$((width * percent / 100))
        local empty=$((width - filled))
        printf "\r${CYAN}["
        printf "%${filled}s" | tr ' ' '█'
        printf "%${empty}s" | tr ' ' '▒'
        printf "] %3d%%" $percent
        percent=$((percent + 2))
        sleep 0.02
    done
    echo -e "${NC}"
}

# Cool startup animation
show_startup_animation() {
    clear
    matrix_effect
    clear
    
    echo -e "${CYAN}${BOLD}"
    type_text "Initializing DOGAR System..."
    show_loading_bar
    
    # Animated DOGAR logo
    for i in {1..3}; do
        clear
        echo -e "${PURPLE}${BOLD}"
        echo "██████╗  ██████╗  ██████╗  █████╗ ██████╗ "
        echo "██╔══██╗██╔═══██╗██╔════╝ ██╔══██╗██╔══██╗"
        echo "██║  ██║██║   ██║██║  ███╗███████║██████╔╝"
        echo "██║  ██║██║   ██║██║   ██║██╔══██║██╔══██╗"
        echo "██████╔╝╚██████╔╝╚██████╔╝██║  ██║██║  ██║"
        echo "╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝"
        sleep 0.3
        clear
        sleep 0.2
    done
    
    echo -e "${PURPLE}${BOLD}"
    echo "██████╗  ██████╗  ██████╗  █████╗ ██████╗ "
    echo "██╔══██╗██╔═══██╗██╔════╝ ██╔══██╗██╔══██╗"
    echo "██║  ██║██║   ██║██║  ███╗███████║██████╔╝"
    echo "██║  ██║██║   ██║██║   ██║██╔══██║██╔══██╗"
    echo "██████╔╝╚██████╔╝╚██████╔╝██║  ██║██║  ██║"
    echo "╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝"
    echo -e "${NC}"
    
    type_text "${GREEN}[+] System initialized successfully${NC}"
    sleep 1
}

# Show animated banner
show_banner() {
    clear
    echo -e "${CYAN}${BOLD}╔════════════════════════════════════════╗${NC}"
    type_text "${YELLOW}         WIRELESS MONITORING TOOL${NC}"
    echo -e "${CYAN}${BOLD}╚════════════════════════════════════════╝${NC}"
}

# Function to install required packages
install_packages() {
    show_banner
    echo -e "${YELLOW}[*] System Update in Progress...${NC}"
    show_loading_bar
    sudo apt-get update >/dev/null 2>&1
    echo -e "${YELLOW}[*] Installing Required Packages...${NC}"
    show_loading_bar
    sudo apt-get install -y aircrack-ng >/dev/null 2>&1
    echo -e "${GREEN}[+] Installation Complete!${NC}"
    sleep 1
}

# Animated menu
show_animated_menu() {
    local options=("$@")
    local selected=0
    local key=""
    
    while true; do
        clear
        show_banner
        echo
        
        for i in "${!options[@]}"; do
            if [ $i -eq $selected ]; then
                echo -e "${GREEN}${BOLD}▶ ${options[$i]} ◀${NC}"
            else
                echo "  ${options[$i]}"
            fi
        done
        
        read -n1 -s key
        
        case "$key" in
            "A") # Up arrow
                if [ $selected -gt 0 ]; then
                    selected=$((selected - 1))
                fi
                ;;
            "B") # Down arrow
                if [ $selected -lt $((${#options[@]} - 1)) ]; then
                    selected=$((selected + 1))
                fi
                ;;
            "") # Enter key
                echo
                return $selected
                ;;
        esac
    done
}

# Function to show monitor mode options
show_monitor_options() {
    while true; do
        local options=("Monitor Mode ON" "BACK")
        show_animated_menu "${options[@]}"
        local choice=$?
        
        case $choice in
            0)
                echo -e "${YELLOW}[*] Initializing Monitor Mode...${NC}"
                show_loading_bar
                sudo airmon-ng check kill >/dev/null 2>&1
                sudo airmon-ng start wlan0 >/dev/null 2>&1
                echo -e "${GREEN}[+] Monitor Mode Activated Successfully${NC}"
                type_text "${CYAN}[*] Interface is now in monitoring state${NC}"
                sleep 2
                select_interface
                ;;
            1)
                return
                ;;
        esac
    done
}

# Function to select interface
select_interface() {
    while true; do
        local options=("wlan0" "wlan0mon" "BACK")
        show_animated_menu "${options[@]}"
        local choice=$?
        
        case $choice in
            0)
                run_airodump "wlan0"
                ;;
            1)
                run_airodump "wlan0mon"
                ;;
            2)
                return
                ;;
        esac
    done
}

# Temporary file for network information
TEMP_FILE="/tmp/network_scan.txt"

# Function to show scanning animation
show_scanning_animation() {
    local pid=$1
    local chars="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i + 1) % 10 ))
        printf "\r${CYAN}[%c] Scanning for networks...${NC}" "${chars:$i:1}"
        sleep 0.1
    done
    echo
}

# Function to run airodump-ng and capture network information
run_airodump() {
    interface=$1
    echo -e "${YELLOW}[*] Preparing Network Scan...${NC}"
    show_loading_bar
    
    # Run airodump-ng and save output to temporary file
    sudo airodump-ng $interface -w $TEMP_FILE --output-format csv >/dev/null 2>&1 &
    airodump_pid=$!
    
    show_scanning_animation $airodump_pid &
    animation_pid=$!
    
    sleep 10
    kill $airodump_pid 2>/dev/null
    wait $airodump_pid 2>/dev/null
    kill $animation_pid 2>/dev/null
    
    clear
    show_banner
    echo -e "\n${CYAN}${BOLD}Found Networks:${NC}\n"
    echo -e "${BLUE}${BOLD}╔═══════════════════════════════════════════════════════════╗${NC}"
    
    # Parse and display networks with fancy formatting
    awk -F, 'NR > 2 {
        printf "║ %2d) %-18s | Ch: %2s | Signal: %3s | %s\n", 
        NR-2, $14, $4, $3, $1
    }' "${TEMP_FILE}-01.csv" | grep -v "Signal:  " | while read line; do
        echo -e "${YELLOW}$line${NC}"
    done
    
    echo -e "${BLUE}${BOLD}╚═══════════════════════════════════════════════════════════╝${NC}"
    
    echo -ne "\n${GREEN}Select network number: ${NC}"
    read network_number
    
    # Get selected network details
    selected_network=$(awk -F, -v num=$network_number 'NR == num+2 {print $1","$4","$14}' "${TEMP_FILE}-01.csv")
    bssid=$(echo $selected_network | cut -d',' -f1)
    channel=$(echo $selected_network | cut -d',' -f2)
    ssid=$(echo $selected_network | cut -d',' -f3)
    
    clear
    show_banner
    echo -e "\n${GREEN}[+] Target Network:${NC}"
    echo -e "${CYAN}╔═══════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC} BSSID   : ${YELLOW}$bssid${NC}"
    echo -e "${CYAN}║${NC} Channel : ${YELLOW}$channel${NC}"
    echo -e "${CYAN}║${NC} SSID    : ${YELLOW}$ssid${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════╝${NC}"
    
    echo -e "\n${YELLOW}[*] Starting Targeted Capture...${NC}"
    show_loading_bar
    
    # Start targeted capture with fancy border
    echo -e "${BLUE}${BOLD}╔═══════════════════════════════════════════════════════════╗${NC}"
    sudo airodump-ng --bssid $bssid --channel $channel --write capture $interface
    echo -e "${BLUE}${BOLD}╚═══════════════════════════════════════════════════════════╝${NC}"
    
    # Cleanup
    rm -f "${TEMP_FILE}"*
}

# Main function
main() {
    show_startup_animation
    install_packages
    show_monitor_options
}

# Trap Ctrl+C
trap 'echo -e "\n${RED}[!] Exiting...${NC}"; exit' INT

# Start the script
main
