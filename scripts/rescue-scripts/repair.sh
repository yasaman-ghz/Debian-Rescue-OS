#!/bin/bash
# ============================================
# Author:      Yasaman Gharagozlou
# Created:     2026-04-05
# Description: Shows all drives and partitions,
#              allows partition table or file system repair
# ============================================
# Show all drives and partitions
echo ""
echo "=== DRIVES & PARTITIONS ==="
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
echo ""

# Pause so user can read the disk list
read -p "Press Enter to continue..."

# Show repair options
echo ""
echo "Choose an option:"
echo "1) Repair Partition Table (uses testdisk)"
echo "2) Repair File System (uses fsck)"
echo ""

# Get user's choice
read -p "Enter choice (1 or 2): " choice

# Ask for the target device (example: /dev/sda)
echo ""
read -p "Enter full device path (e.g. /dev/sda), DO NOT Enter drives currently in-use: " dev

# Handle user choice
case $choice in

  1)
    # Partition Table Repair Section
    # Uses testdisk to recover partitions
    echo ""
    read -p "Launching TestDisk for $dev... (Press Enter)"
    sudo testdisk "$dev"
    ;;

  2)
    # File System Repair Section
    # Runs fsck on each partition
    echo ""
    read -p "Scanning partitions on $dev... (Press Enter)"

    # Loop through all partitions of the disk
    for p in $(sudo lsblk -ln -o NAME "$dev" | tail -n +2); do
      echo ""
      echo "Repairing /dev/$p ..."
      
      # Run file system check and auto-fix
      sudo fsck -y "/dev/$p"

      # Pause after each partition repair
      read -p "Press Enter to continue to next partition..."
    done
    ;;

  *)
    # Invalid input handling
    echo "Invalid option selected."
    ;;
esac

# Final pause so user can see results
echo ""
echo "=== OPERATION COMPLETE ==="
read -p "Press Enter to exit..."
