#!/bin/bash

#=======================================================
# Author:      Yasaman Gharagozlou
# Created:     2026-04-06
# Description: Menu to show options to the user and ask  
#              an input, then run the the related script 
#=======================================================
# Infinite loop to keep showing Menu
while true
do
    clear
    echo "___Yasaman_Gharagozlou__________________________W0522396___"
    echo "                           Menu"
    echo "==========================================================="
    echo "1. Drives Health Check (recommended before Repair)"
    echo "2. Repair Partition Table/File System"
    echo "3. Recover Files/Directories"
    echo "4. Image Backup (recommended if a drive is failing)"
    echo "5. Virus Scan (recommended before opening recovered files)" 
    echo "6. Text Editor"
    echo "7. Test Netwrok Connectivity"
    echo "8. Hardware Information"
    echo "9. Exit"
    echo "==========================================================="

    # Get user input
    read -p "Choose an option [1-9]: " choice

    # Run related script 
    case $choice in
        1)
            echo "Running drive-health.sh script..."
            sleep 3 
            /opt/rescue-scripts/drive-health.sh
            ;;
        2)
            echo "Running repair.sh script..."
            sleep 3 
            /opt/rescue-scripts/repair.sh
            ;;
        3)
            echo "Running file-backup.sh script..."
            sleep 3 
            /opt/rescue-scripts/file-backup.sh
            ;;
        4)
            echo "Running image-backup.sh script..."
            sleep 3
            /opt/rescue-scripts/image-backup.sh 
            ;; 
        5)
            echo "Running virus-scan.sh script..."
            sleep 3
            /opt/rescue-scripts/virus-scan.sh
            ;; 
        6)
            echo "Running create-save.sh script..."
            sleep 3
            /opt/rescue-scripts/create-save.sh
            ;; 
        7)
            echo "Running network-connection.sh..."
            sleep 3
            /opt/rescue-scripts/network-connection.sh
            ;;
        8)
            echo "Running hardware-info.sh script..."
            sleep 3
            /opt/rescue-scripts/hardware-info.sh
            ;; 
        9)
            read -p "You can run 'menu.sh' to see Menu again. (Press Enter)"
            break
            ;;
        *)
            echo "Invalid option!"
            ;;
    esac

    # Pause before showing menu again
    echo ""
    read -p "Press Enter to return to Menu..."
done
