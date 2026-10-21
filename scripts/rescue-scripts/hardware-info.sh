#!/bin/bash

#=========================================================================
# Author: Yasaman Gharagozlou
# Created: 2026-04-05
# Description: System information report are shown with optional details.
#=========================================================================
echo "=== System Information ==="

# Full overview with inxi
echo "General system overview:"
inxi -Fxz | less

# Ask if user wants detailed hardware info
read -p "Show detailed hardware info (lshw -short)? [y/N] " ans
if [[ "$ans" = "y" || "$ans" = "Y" ]]; then
   sudo lshw -short | less
fi

# Ask for CPU info
read -p "Show CPU info (lscpu)? [y/N] " ans
if [[ "$ans" = "y" || "$ans" = "Y" ]]; then
   lscpu | less
fi

# Ask for memory info
read -p "Show memory info (free -h)? [y/N] " ans
if [[ "$ans" = "y" || "$ans" = "Y" ]]; then
   free -h
fi

# Ask for storage info
read -p "Show block devices (lsblk)? [y/N] " ans
if [[ "$ans" = "y" || "$ans" = "Y" ]]; then
    lsblk
    read -p "Press Enter to continue..."
fi

echo "=== System Info Check Complete ==="
