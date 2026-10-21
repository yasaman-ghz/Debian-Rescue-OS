#!/bin/bash

# ============================================
# Author:      Yasaman Gharagozlou
# Created:     2026-04-05
# Description: Shows available drives, allows user to select a drive,
#              performs a SMART health check, and gives a clear result
#              with recommended next steps
# ============================================
echo ""
echo "===== AVAILABLE DRIVES ====="
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
echo "============================"

read -p "Press Enter to continue..."


# Ask user for drive
echo ""
read -p "Enter FULL drive path (e.g., /dev/sda), choose one that supports SMART tools: " DRIVE

# Validate input
if [ ! -b "$DRIVE" ]; then
    echo "Invalid device. Exiting."
    exit 1
fi

# Enable SMART (if needed)
echo ""
echo "Preparing SMART check..."
sudo smartctl -s on "$DRIVE"

read -p "Press Enter to run health check..."

# Run SMART check
echo ""
echo "===== DRIVE HEALTH CHECK RESULT ====="
sudo smartctl -H "$DRIVE"
echo "====================================="

echo ""
echo "===== FEEDBACK ================================================================="

echo "If your drive is healthy, you can proceed with repairing and recovering next."
echo "If your drive is unhealthy, create an image backup before anything else."

echo "================================================================================"

#Final pause
read -p "Press Enter to exit..."
