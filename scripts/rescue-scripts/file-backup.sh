#!/bin/bash

# ============================================
# Author:      Yasaman Gharagozlou
# Created:     2026-04-05
# Description: Shows available drives, mounts a selected drive,
#              allows user to recover specific files/folders
#              to a destination drive
# ============================================
echo ""
echo "===== Available Drives ====="
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT
echo "==========================="

read -p "Press Enter to continue..."

# Ask user for source drive
read -p "Enter FULL path of the drive/partition to mount (e.g., /dev/sda1)" SOURCE_DRIVE

# Create mount point
MOUNT_POINT="/mnt/recovery_source"
sudo mkdir -p $MOUNT_POINT

# Mount the drive
echo "Mounting $SOURCE_DRIVE..."
sudo mount $SOURCE_DRIVE $MOUNT_POINT

if [ $? -ne 0 ]; then
    echo "Mount failed. Exiting."
    exit 1
fi

echo "Mounted successfully at $MOUNT_POINT"

read -p "Press Enter to view contents..."


# Show user first-level directories
echo "===== Top-level contents ====="
sudo ls -ah $MOUNT_POINT
echo "=============================="

read -p "Press Enter to continue..."

# Ask what to recover
read -p "Enter FULL path of file/directory to recover (e.g., /mnt/recovery_source/Documents/file.txt): " RECOVER_PATH

# Check if path exists
if [ ! -e "$RECOVER_PATH" ]; then
    echo "Path does not exist. Exiting."
    exit 1
fi


# Ask destination drive
echo "===== Available Drives (Destination) ====="
sudo lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT
echo "=========================================="

read -p "Enter FULL path of destination drive/partition (e.g., /dev/sdb1)" DEST_DRIVE

# Create mount point for destination
DEST_MOUNT="/mnt/recovery_dest"
sudo mkdir -p $DEST_MOUNT

# Mount destination
echo "Mounting destination..."
sudo mount $DEST_DRIVE $DEST_MOUNT

if [ $? -ne 0 ]; then
    echo "Destination mount failed. Exiting."
    exit 1
fi

echo "Mounted destination at $DEST_MOUNT"

read -p "Press Enter to start recovery..."


# Copy (Recover) data
echo "Copying data..."
sudo rsync -av --ignore-errors "$RECOVER_PATH" "$DEST_MOUNT/"
echo ""
echo "Operation completed (Some files may have been skipped due to filesystem limitations.)"
echo ""


# Unmount and cleanup
read -p "Press Enter for unmounting drives and cleaning up..."
sudo umount $MOUNT_POINT
sudo umount $DEST_MOUNT
sudo rmdir $MOUNT_POINT
sudo rmdir $DEST_MOUNT
echo "Done."
