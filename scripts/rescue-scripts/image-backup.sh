#!/bin/bash

# ============================================
# Author:      Yasaman Gharagozlou
# Created:     2026-04-05
# Description: Shows available drives, allows the user to select a drive,
#              creates a full disk/partition image backup to a destination drive,
#              and displays progress
# ============================================
echo ""
echo "===== Available Drives ====="
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT
echo "==========================="

read -p "Press Enter to continue..."


#Ask user for source drive
read -p "Enter FULL path of drive/partition to back up (e.g., /dev/sda): " SOURCE_DRIVE

# Ask for destination drive
echo "===== Available Drives (Destination) ====="
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT
echo "=========================================="
read -p "Enter FULL path of destination drive (e.g., /dev/sdb1). " DEST_DRIVE

# Mount destination drive
DEST_MOUNT="/mnt/backup_dest"
sudo mkdir -p $DEST_MOUNT

echo "Mounting destination..."
sudo mount $DEST_DRIVE $DEST_MOUNT

if [ $? -ne 0 ]; then
    echo "Failed to mount destination. Exiting."
    exit 1
fi

echo "Mounted at $DEST_MOUNT"

read -p "Press Enter to continue..."


# Ask for image file name
read -p "Enter name for backup image (e.g., backup.img): " IMAGE_NAME

IMAGE_PATH="$DEST_MOUNT/$IMAGE_NAME"


# Create image backup
echo "Starting image backup..."
echo "This may take a while..."

# Using dd with progress
sudo dd if=$SOURCE_DRIVE of=$IMAGE_PATH bs=4M status=progress | gzip > "$IMAGE_PATH.gz"

if [ $? -eq 0 ]; then
    echo "Image backup completed successfully!"
    echo "Saved at: $IMAGE_PATH"
else
    echo "Backup failed."
fi

read -p "Press Enter to finish..."


# Cleanup
echo "Unnmounting and clean up..."
sudo umount $DEST_MOUNT
sudo rmdir $DEST_MOUNT
echo "Done."
