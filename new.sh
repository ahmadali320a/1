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
                echo -e "${YELLOW}[*] Starting monitor mode...${NC}"
                sudo airmon-ng check kill >/dev/null 2>&1
                sudo airmon-ng start wlan0 >/dev/null 2>&1
                echo -e "${GREEN}[+] Monitor mode activated${NC}"
                sleep 2
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

# Temporary file for network information
TEMP_FILE="/tmp/network_scan.txt"

# Function to run airodump-ng and capture network information
run_airodump() {
    interface=$1
    echo -e "${YELLOW}[*] Scanning for networks...${NC}"
    
    # Run airodump-ng and save output to temporary file
    sudo airodump-ng $interface -w $TEMP_FILE --output-format csv &
    airodump_pid=$!
    
    # Wait for some data to be collected
    sleep 10
    
    # Kill airodump-ng
    kill $airodump_pid 2>/dev/null
    
    # Read and display networks
    clear
    echo -e "${BLUE}${BOLD}-------------------------------"
    echo "AVAILABLE NETWORKS:"
    echo -e "-------------------------------${NC}"
    
    # Parse CSV file and display networks
    awk -F, 'NR > 2 {print NR-2 ") BSSID: " $1 " | SSID: " $14 " | Channel: " $4}' "${TEMP_FILE}-01.csv" | grep -v "SSID: "
    
    echo -e "${BLUE}${BOLD}-------------------------------${NC}"
    echo "Enter the number of the network to target: "
    read network_number
    
    # Get selected network details
    selected_network=$(awk -F, -v num=$network_number 'NR == num+2 {print $1","$4","$14}' "${TEMP_FILE}-01.csv")
    bssid=$(echo $selected_network | cut -d',' -f1)
    channel=$(echo $selected_network | cut -d',' -f2)
    ssid=$(echo $selected_network | cut -d',' -f3)
    
    echo -e "${GREEN}[+] Selected Network:${NC}"
    echo "BSSID: $bssid"
    echo "Channel: $channel"
    echo "SSID: $ssid"
    
    echo -e "${YELLOW}[*] Starting targeted capture...${NC}"
    # Start targeted capture
    sudo airodump-ng --bssid $bssid --channel $channel --write capture $interface
    
    # Cleanup
    rm -f "${TEMP_FILE}"*
}

# Main function
main() {
    show_startup_animation
    install_packages
    show_monitor_options
}

# Start the script
main
