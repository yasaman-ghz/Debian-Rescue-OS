#!/bin/bash

#===========================================================
# Author: Yasaman Gharagozlou
# Created: 2026-04-05
# Description: Network connectivity test providing a report.
#===========================================================
echo ""
echo "=== Network Connectivity Test ==="

# Test loopback interface
echo "Testing loopback at 127.0.0.1... "
if ping -c 4 127.0.0.1 &> /dev/null; then
    echo "OK"
else
    echo "Failed"
fi

# Test local network connectivity (default gateway)
GATEWAY=$(ip route | grep default | awk '{print $3}')
if [ -n "$GATEWAY" ]; then
    echo "Pinging local gateway $GATEWAY... "
    if ping -c 4 $GATEWAY &> /dev/null; then
        echo "Reachable"
    else
        echo "Cannot reach gateway"
    fi
else
    echo "No gateway found"
fi

# Testing internet connectivity by pinging Google DNS
echo "Pinging 8.8.8.8 (Google DNS Server)..."
if ping -c 4 8.8.8.8 &> /dev/null; then
    echo "Online"
else
    echo "Cannot reach 8.8.8.8" 
fi

# Test internet connectivity by resolving google.com
echo "Resolving google.com... "
if nslookup google.com &> /dev/null; then
   echo "Done"
else
    echo "Cannot resolve Google domain name"
fi


echo "=== Test Complete ==="

