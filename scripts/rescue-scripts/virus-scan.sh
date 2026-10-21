#!/bin/bash

# =============================================================================
# Author:      Yasaman Gharagozlou
# Created:     2026-04-05
# Description: Shows available drives, asks for user input and mounts the
#              selected drive, scans files for malware, shows infected files,
#              and optionally deletes them
# =============================================================================
echo ""
echo "===== AVAILABLE DRIVES ====="
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT
echo "============================"

read -p "Press Enter to continue..."


# Ask for destination  drive
echo ""
read -p "Enter FULL path of destination drive (e.g., /dev/sdb1), DO NOT enter an already mounted drive: " DEST_DRIVE


# Create mount point
MOUNT_POINT="/mnt/recovery_dest"
sudo mkdir -p $MOUNT_POINT

# Mount the drive
echo ""
echo "Mounting $DEST_DRIVE ..."
sudo mount $DEST_DRIVE $MOUNT_POINT

if [ $? -ne 0 ]; then
    echo "Mount failed. Exiting."
    exit 1
fi

echo "Mounted at $MOUNT_POINT"
echo "Top level directories and files"
sudo ls -ah "$MOUNT_POINT"
read -p "Press Enter to continue..."


# Ask for exact recovery folder (optional)
echo ""
read -p "Enter folder inside drive to scan (or press Enter to scan all): " SUB_PATH

if [ -z "$SUB_PATH" ]; then
    TARGET_PATH="$MOUNT_POINT"
else
    TARGET_PATH="$MOUNT_POINT/$SUB_PATH"
fi

# update virus database
echo ""
echo "Updating virus database (this can take a few seconds)..."
if systemctl is-active --quiet clamav-freshclam; then
    echo "Update service already running, skipping manual update."
else
    sudo freshclam
fi
read -p "Press Enter to start scanning..."

#scan for malware
echo ""
echo "Scanning for malware..."

INFECTED_LIST="/tmp/infected_files.txt"
 
clamscan -r --infected "$TARGET_PATH" | tee "$INFECTED_LIST"

# Check if infections found
if ! grep -q "FOUND" "$INFECTED_LIST"; then
    echo ""
    echo "No infected files found."
    echo "It is safe to use files on this drive."

    read -p "Press Enter to unmount and clean up..."
    sudo umount $MOUNT_POINT
    sudo rmdir $MOUNT_POINT
    exit 0
fi


# Show infected files
echo ""
echo "===== INFECTED FILES ====="
grep "FOUND" "$INFECTED_LIST"
echo "=========================="

read -p "Press Enter to continue..."


# Ask user to delete infected files
echo ""
read -p "Do you want to DELETE all infected files? (y/n): " choice

if [[ "$choice" == "y" || "$choice" == "Y" ]]; then

    echo ""
    echo "Deleting infected files..."

    grep "FOUND" "$INFECTED_LIST" | cut -d: -f1 | while read file; do
        sudo rm -f "$file"
        echo "Deleted: $file"
    done

    echo ""
    echo "All infected files have been removed."
else
    echo ""
    echo "No files were deleted."
fi


# cleanup
echo ""
echo "Unmounting and cleaning up..."
sudo umount $MOUNT_POINT
sudo rmdir $MOUNT_POINT
echo "Scan complete. It is now safer to use files on this drive."
read -p "Press Enter to exit..."
