#!/bin/bash

# Check if the script is run with root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root!" 1>&2
    exit 1
fi

# Enable wlan0 in monitor mode
echo "Setting wlan0 to monitor mode..."
ip link set wlan0 down
iw dev wlan0 set type monitor
ip link set wlan0 up

# Enable Ethernet (eth0) interface
echo "Enabling Ethernet interface..."
ip link set eth0 up

# Enable IP forwarding for internet sharing
echo "Enabling IP forwarding..."
sysctl -w net.ipv4.ip_forward=1

# Set up NAT to allow Ethernet interface to share internet
echo "Setting up NAT for internet sharing..."
iptables --table nat -A POSTROUTING -o eth0 -j MASQUERADE

echo "Monitor mode enabled on wlan0, and Ethernet is active for internet."

# Trap Ctrl+C to stop the script and revert changes
trap ctrl_c INT

# Function to stop the script and revert changes
ctrl_c() {
    echo "Ctrl+C detected. Reverting changes..."
    ip link set wlan0 down
    iw dev wlan0 set type managed
    ip link set wlan0 up
    ip link set eth0 down
    sysctl -w net.ipv4.ip_forward=0
    iptables --table nat -D POSTROUTING -o eth0 -j MASQUERADE
    echo "System reverted to normal mode."
    exit 0
}

# Keep the script running until Ctrl+C is pressed
while true; do
    sleep 1
done
