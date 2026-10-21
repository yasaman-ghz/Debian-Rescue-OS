#!/bin/bash
# ==============================================================
# Author:      Yasaman Gharagozlou
# Created:     2026-04-05
# Description: Shows available Text Editors and lets user choose
#              which one to open.
# ==============================================================
echo ""
echo "=== Text Editors ==="
# Choose editor
echo ""
echo "Choose editor:"
echo "1. nano"
echo "2. vim"
echo "3. micro"
read -p "Enter choice [1-3]: " choice

case $choice in
    1)
        editor="nano"
        echo "Opening nano..."
        sleep 2
        ;;
    2)
        editor="vim"
        echo "Opening vim..."
        sleep 2
        ;;
    3)
        editor="micro"
        echo "Opening micro..."
        sleep 2
        ;;

    *)
        #Invalid choices
        echo "Invalid option."
        exit 1
esac

# Open selected editor
$editor
