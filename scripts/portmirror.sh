#!/bin/bash

set -e

TARGET_NETWORK="earl-infrastructure_mock_internet"
ZEEK_CONTAINER_IP="192.168.150.9"


# Function to remove rules from a specific chain
function cleanup_rules() {
    local chain=$1
    local rules=$(sudo iptables -t mangle -L $chain -v -n --line-numbers | grep "$ZEEK_CONTAINER_IP" | awk '{print $1}' | tac)

    for rule_num in $rules; do
        echo "Removing rule $rule_num from $chain"
        sudo iptables -t mangle -D $chain $rule_num
    done
}

# Cleanup iptables
function cleanup_iptables {
    echo "Cleaning up iptables..."
    cleanup_rules PREROUTING
    cleanup_rules POSTROUTING
    echo "iptables cleanup complete."
    sudo iptables -t mangle -L PREROUTING -v -n --line-numbers
    sudo iptables -t mangle -L POSTROUTING -v -n --line-numbers 
}

# Check for cleanup flag
if [[ "$1" == "--cleanup" ]]; then
    cleanup_iptables
    exit 0
fi

# Continue with setup if not cleanup
NETWORK_ID=$(docker network inspect -f '{{.Id}}' $TARGET_NETWORK)
if [[ -z "$NETWORK_ID" ]]; then
    echo "Network $TARGET_NETWORK does not exist. Exiting."
    exit 1
fi

echo "Setting up port mirroring on the '$TARGET_NETWORK'($NETWORK_ID) network to Zeek at $ZEEK_CONTAINER_IP"

# Extract the first 12 characters of the network ID to form the bridge name
bridge_id="${NETWORK_ID:0:12}"
bridge_name="br-$bridge_id"
echo "Detected $TARGET_NETWORK bridge name: $bridge_name"
echo "Using Zeek container IP: $ZEEK_CONTAINER_IP"

# Setup port mirroring
sudo iptables -A PREROUTING -t mangle -i $bridge_name -j TEE --gateway $ZEEK_CONTAINER_IP
sudo iptables -A POSTROUTING -t mangle -o $bridge_name -j TEE --gateway $ZEEK_CONTAINER_IP
sudo iptables -t mangle -L PREROUTING -v -n --line-numbers
sudo iptables -t mangle -L POSTROUTING -v -n --line-numbers

echo "Setup complete. Use '--cleanup' to remove configurations."
