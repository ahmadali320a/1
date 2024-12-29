#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Cool startup animation
show_startup_animation() {
    clear
    echo -e "${BLUE}"
    echo "Loading DOGAR..."
    echo -ne '█▒▒▒▒▒▒▒▒▒ (10%)\r'
    sleep 0.5
    echo -ne '████▒▒▒▒▒▒ (40%)\r'
    sleep 0.5
    echo -ne '███████▒▒▒ (70%)\r'
    sleep 0.5
    echo -ne '██████████ (100%)\r'
    echo -ne '\n'
    
    # DOGAR ASCII art
    echo -e "${GREEN}${BOLD}"
    echo "██████╗  ██████╗  ██████╗  █████╗ ██████╗ "
    echo "██╔══██╗██╔═══██╗██╔════╝ ██╔══██╗██╔══██╗"
    echo "██║  ██║██║   ██║██║  ███╗███████║██████╔╝"
    echo "██║  ██║██║   ██║██║   ██║██╔══██║██╔══██╗"
    echo "██████╔╝╚██████╔╝╚██████╔╝██║  ██║██║  ██║"
    echo "╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝"
    echo -e "${NC}"
    sleep 1
}

# Function to install required packages
install_packages() {
    echo -e "${YELLOW}[*] Updating system and installing required packages...${NC}"
    sudo apt-get update
    sudo apt-get install -y aircrack-ng
}

# Function to show monitor mode options
show_monitor_options() {
    while true; do
        clear
        echo -e "${BLUE}${BOLD}-------------------------------"
        echo "MONITOR MODE OPTIONS:"
        echo "-------------------------------"
        echo "1. Monitor Mode ON"
        echo "2. BACK"
        echo -e "-------------------------------${NC}"
        echo -e "Please choose an option: "
        read choice

        case $choice in
            1)
                sudo airmon-ng start wlan0
                select_interface
                ;;
            2)
                return
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                sleep 1
                ;;
        esac
    done
}

# Function to select interface
select_interface() {
    while true; do
        clear
        echo -e "${BLUE}${BOLD}-------------------------------"
        echo "INTERFACE SELECTION:"
        echo "-------------------------------"
        echo "1. wlan0"
        echo "2. wlan0mon"
        echo "3. BACK"
        echo -e "-------------------------------${NC}"
        echo -e "Please choose an option: "
        read interface_choice

        case $interface_choice in
            1)
                run_airodump "wlan0"
                ;;
            2)
                run_airodump "wlan0mon"
                ;;
            3)
                return
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                sleep 1
                ;;
        esac
    done
}

# Function to run airodump-ng
run_airodump() {
    interface=$1
    echo -e "${YELLOW}[*] Starting airodump-ng on $interface...${NC}"
    sudo airodump-ng $interface &
    airodump_pid=$!
    
    sleep 5  # Give some time for networks to appear
    
    # Kill airodump-ng
    kill $airodump_pid 2>/dev/null
    
    echo -e "${BLUE}${BOLD}-------------------------------"
    echo "NETWORK OPTIONS:"
    echo "-------------------------------"
    echo "Enter BSSID: "
    read bssid
    echo "Enter Channel Number: "
    read channel
    
    echo -e "${YELLOW}[*] Starting targeted capture...${NC}"
    # Open new terminal with targeted capture
    xterm -e "sudo airodump-ng --bssid $bssid --channel $channel --write capture $interface" &
}

# Main function
main() {
    show_startup_animation
    install_packages
    show_monitor_options
}

# Start the script
main
