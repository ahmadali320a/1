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

# Hacking animation frames
declare -a HACK_FRAMES=(
    " [▱▱▱▱▱▱▱▱▱▱] 0% Initializing Attack Vectors..."
    " [▰▱▱▱▱▱▱▱▱▱] 10% Bypassing Firewall..."
    " [▰▰▱▱▱▱▱▱▱▱] 20% Scanning Network Protocols..."
    " [▰▰▰▱▱▱▱▱▱▱] 30% Injecting Payload..."
    " [▰▰▰▰▱▱▱▱▱▱] 40% Breaching Security..."
    " [▰▰▰▰▰▱▱▱▱▱] 50% Extracting Network Data..."
    " [▰▰▰▰▰▰▱▱▱▱] 60% Decrypting Packets..."
    " [▰▰▰▰▰▰▰▱▱▱] 70% Analyzing Traffic..."
    " [▰▰▰▰▰▰▰▰▱▱] 80% Establishing Connection..."
    " [▰▰▰▰▰▰▰▰▰▱] 90% Finalizing Process..."
    " [▰▰▰▰▰▰▰▰▰▰] 100% Access Granted!"
)

# Binary rain effect
binary_rain() {
    local lines=15
    local cols=80
    for ((i=0; i<$lines; i++)); do
        for ((j=0; j<$cols; j++)); do
            if [ $((RANDOM % 2)) -eq 0 ]; then
                echo -ne "${GREEN}$(($RANDOM % 2))${NC}"
            else
                echo -n " "
            fi
        done
        echo
        sleep 0.02
    done
}

# Hacking animation
show_hacking_animation() {
    local message="$1"
    echo -e "\n${CYAN}${BOLD} INITIALIZING CYBER ATTACK ${NC}"
    for frame in "${HACK_FRAMES[@]}"; do
        echo -ne "\r${YELLOW}$frame${NC}"
        sleep 0.2
    done
    echo -e "\n${CYAN}${BOLD} CYBER ATTACK COMPLETE ${NC}"
}

# Matrix effect with custom characters
matrix_effect() {
    local lines=20
    local cols=80
    local chars=('ﾊ' 'ﾐ' 'ﾋ' 'ｰ' 'ｳ' 'ｼ' 'ﾅ' 'ﾓ' 'ﾆ' 'ｻ' 'ﾜ' 'ﾂ' 'ｵ' 'ﾘ' 'ｱ' 'ﾎ' 'ﾃ' 'ﾏ' 'ｹ' 'ﾒ' 'ｴ' 'ｶ' 'ｷ' 'ﾑ' 'ﾕ' 'ﾗ' 'ｾ' 'ﾈ' 'ｽ' 'ﾀ' 'ﾇ' 'ﾍ' '1' '0')
    
    for ((i=0; i<$lines; i++)); do
        for ((j=0; j<$cols; j++)); do
            if [ $((RANDOM % 3)) -eq 0 ]; then
                echo -ne "${GREEN}${chars[$((RANDOM % ${#chars[@]}))]}"
            else
                echo -n " "
            fi
        done
        echo
        sleep 0.03
    done
}

# Typing effect with glitch
type_text() {
    local text="$1"
    for ((i=0; i<${#text}; i++)); do
        if [ $((RANDOM % 10)) -eq 0 ]; then
            # Glitch effect
            echo -ne "${RED}$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c1)${NC}"
            sleep 0.02
            echo -ne "\b${CYAN}${text:$i:1}${NC}"
        else
            echo -ne "${CYAN}${text:$i:1}${NC}"
        fi
        sleep 0.03
    done
    echo
}

# Loading bar with percentage and hacking messages
show_loading_bar() {
    local width=50
    local percent=0
    local messages=(
        "Bypassing security..."
        "Cracking encryption..."
        "Injecting payload..."
        "Scanning ports..."
        "Analyzing packets..."
        "Breaking firewall..."
        "Extracting data..."
        "Establishing connection..."
    )
    
    while [ $percent -le 100 ]; do
        local filled=$((width * percent / 100))
        local empty=$((width - filled))
        printf "\r${CYAN}["
        printf "%${filled}s" | tr ' ' '█'
        printf "%${empty}s" | tr ' ' '▒'
        printf "] %3d%% " $percent
        echo -ne "${GREEN}${messages[$((RANDOM % ${#messages[@]}))]}"
        printf "\033[K"
        percent=$((percent + 2))
        sleep 0.05
    done
    echo -e "${NC}"
}

# Cool startup animation
show_startup_animation() {
    clear
    binary_rain
    matrix_effect
    clear
    
    show_hacking_animation "INITIALIZING SYSTEM"
    
    echo -e "${CYAN}${BOLD}"
    type_text "[ DOGAR SYSTEM v2.0 - ADVANCED NETWORK INFILTRATION TOOL ]"
    show_loading_bar
    
    # Animated DOGAR logo with glitch effect
    for i in {1..3}; do
        clear
        if [ $((RANDOM % 2)) -eq 0 ]; then
            echo -e "${RED}${BOLD}"
        else
            echo -e "${PURPLE}${BOLD}"
        fi
        echo "██████╗  ██████╗  ██████╗  █████╗ ██████╗ "
        echo "██╔══██╗██╔═══██╗██╔════╝ ██╔══██╗██╔══██╗"
        echo "██║  ██║██║   ██║██║  ███╗███████║██████╔╝"
        echo "██║  ██║██║   ██║██║   ██║██╔══██║██╔══██╗"
        echo "██████╔╝╚██████╔╝╚██████╔╝██║  ██║██║  ██║"
        echo "╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝"
        if [ $((RANDOM % 2)) -eq 0 ]; then
            echo -ne "${RED}ERR0R: SYST3M C0MPROM1S3D${NC}"
            sleep 0.1
            echo -ne "\r${GREEN}SYSTEM SECURE - ACCESS GRANTED${NC}"
        fi
        sleep 0.2
        clear
        sleep 0.1
    done
    
    echo -e "${PURPLE}${BOLD}"
    echo "██████╗  ██████╗  ██████╗  █████╗ ██████╗ "
    echo "██╔══██╗██╔═══██╗██╔════╝ ██╔══██╗██╔══██╗"
    echo "██║  ██║██║   ██║██║  ███╗███████║██████╔╝"
    echo "██║  ██║██║   ██║██║   ██║██╔══██║██╔══██╗"
    echo "██████╔╝╚██████╔╝╚██████╔╝██║  ██║██║  ██║"
    echo "╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝"
    echo -e "${NC}"
    
    type_text "${GREEN}[+] System initialized - Ready for network penetration${NC}"
    sleep 1
}

# Show animated banner with glitch effect
show_banner() {
    clear
    if [ $((RANDOM % 5)) -eq 0 ]; then
        echo -e "${RED}${BOLD} SYST3M BR3ACH3D ${NC}"
        sleep 0.1
        clear
    fi
    echo -e "${CYAN}${BOLD} WIRELESS ATTACK SUITE ${NC}"
    type_text "${YELLOW}     ADVANCED NETWORK EXPLOITATION TOOL${NC}"
    echo -e "${CYAN}${BOLD} ${NC}"
}

# Function to install required packages
install_packages() {
    show_banner
    echo -e "${YELLOW}[*] Initializing System Update...${NC}"
    show_loading_bar
    sudo apt-get update >/dev/null 2>&1
    echo -e "${YELLOW}[*] Installing Required Packages...${NC}"
    show_loading_bar
    sudo apt-get install -y aircrack-ng >/dev/null 2>&1
    echo -e "${GREEN}[+] Installation Complete!${NC}"
    sleep 1
}

# Animated menu with glitch effect
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
                if [ $((RANDOM % 10)) -eq 0 ]; then
                    echo -e "${RED}${BOLD} ERR0R: MENU C0RRUPT3D ${NC}"
                    sleep 0.1
                fi
                echo -e "${GREEN}${BOLD} ${options[$i]} ${NC}"
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
        local options=("ACTIVATE MONITOR MODE" "RETURN TO BASE")
        show_animated_menu "${options[@]}"
        local choice=$?
        
        case $choice in
            0)
                show_hacking_animation "ACTIVATING MONITOR MODE"
                sudo airmon-ng check kill >/dev/null 2>&1
                sudo airmon-ng start wlan0 >/dev/null 2>&1
                echo -e "${GREEN}[+] Monitor Mode Successfully Activated${NC}"
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
        local options=("ATTACK INTERFACE: wlan0" "ATTACK INTERFACE: wlan0mon" "ABORT MISSION")
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

# Function to show scanning animation with more intense effects
show_scanning_animation() {
    local pid=$1
    local chars="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
    local messages=(
        "SCANNING NETWORK PERIMETER"
        "ANALYZING WIRELESS TRAFFIC"
        "DETECTING ACCESS POINTS"
        "CAPTURING PACKETS"
        "PROCESSING NETWORK DATA"
        "IDENTIFYING TARGETS"
    )
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i + 1) % 10 ))
        local msg=${messages[$((RANDOM % ${#messages[@]}))]}
        printf "\r${CYAN}[%c] ${GREEN}%s${NC}" "${chars:$i:1}" "$msg"
        sleep 0.1
    done
    echo
}

# Function to run airodump-ng and capture network information
run_airodump() {
    interface=$1
    echo -e "${YELLOW}[*] Initializing Network Scan...${NC}"
    show_hacking_animation "PREPARING NETWORK SCAN"
    
    # Run airodump-ng with more options for better detection
    sudo airodump-ng $interface -w $TEMP_FILE --output-format csv,kismet --band abg >/dev/null 2>&1 &
    airodump_pid=$!
    
    show_scanning_animation $airodump_pid &
    animation_pid=$!
    
    sleep 15  # Longer scan time for better results
    kill $airodump_pid 2>/dev/null
    wait $airodump_pid 2>/dev/null
    kill $animation_pid 2>/dev/null
    
    clear
    show_banner
    echo -e "\n${CYAN}${BOLD}[+] Network Targets Identified:${NC}\n"
    echo -e "${BLUE}${BOLD} ${NC}"
    
    # Enhanced network display with more information
    awk -F, 'NR > 2 {
        if (length($14) > 0 && $14 != " ") {
            printf " %2d) %-18s | Ch: %2s | Strength: %3s | Encryption: %s | %s\n", 
            NR-2, $14, $4, $3, $6, $1
        }
    }' "${TEMP_FILE}-01.csv" | while read line; do
        if [ $((RANDOM % 5)) -eq 0 ]; then
            echo -ne "${RED}$line${NC}"
            sleep 0.1
            echo -ne "\r${YELLOW}$line${NC}"
        else
            echo -e "${YELLOW}$line${NC}"
        fi
        sleep 0.05
    done
    
    echo -e "${BLUE}${BOLD} ${NC}"
    
    echo -ne "\n${GREEN}Select target number for exploitation: ${NC}"
    read network_number
    
    # Get selected network details with error checking
    selected_network=$(awk -F, -v num=$network_number 'NR == num+2 {print $1","$4","$14","$6}' "${TEMP_FILE}-01.csv")
    if [ -z "$selected_network" ]; then
        echo -e "${RED}[!] Invalid target selection. Retrying...${NC}"
        sleep 2
        return
    fi
    
    bssid=$(echo $selected_network | cut -d',' -f1)
    channel=$(echo $selected_network | cut -d',' -f2)
    ssid=$(echo $selected_network | cut -d',' -f3)
    encryption=$(echo $selected_network | cut -d',' -f4)
    
    clear
    show_banner
    echo -e "\n${GREEN}[+] Target Acquired:${NC}"
    echo -e "${CYAN} ${NC}"
    echo -e "${CYAN} SSID     : ${YELLOW}$ssid${NC}"
    echo -e "${CYAN} BSSID    : ${YELLOW}$bssid${NC}"
    echo -e "${CYAN} Channel  : ${YELLOW}$channel${NC}"
    echo -e "${CYAN} Security : ${YELLOW}$encryption${NC}"
    echo -e "${CYAN} ${NC}"
    
    echo -e "\n${YELLOW}[*] Initiating Advanced Capture...${NC}"
    show_hacking_animation "STARTING TARGETED ATTACK"
    
    # Start targeted capture with enhanced visuals
    echo -e "${BLUE}${BOLD} ${NC}"
    sudo airodump-ng --bssid $bssid --channel $channel --write capture $interface
    echo -e "${BLUE}${BOLD} ${NC}"
    
    # Cleanup
    rm -f "${TEMP_FILE}"*
}

# Main function
main() {
    show_startup_animation
    install_packages
    show_monitor_options
}

# Trap Ctrl+C with style
trap 'echo -e "\n${RED}[!] EMERGENCY SHUTDOWN INITIATED...${NC}"; sleep 1; echo -e "${GREEN}[+] System Exit Complete${NC}"; exit' INT

# Start the script
main
