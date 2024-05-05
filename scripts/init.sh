#!/bin/bash

set -e

# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (sudo)" 1>&2
   exit 1
fi

# EMUX setup
echo "[EARL-Init] Initializing EMUX Volume"
cd ../emux
./build-emux-volume

echo "[EARL-Init] Initializing EMUX Container"
./build-emux-docker

cd ../

# Docker-ELK setup
echo "[EARL-Init] Initializing Docker-ELK"
docker compose up setup

echo "[EARL-Init] Setting up packet forwarding for Zeek sniffing"
cd ./scripts
./portmirror.sh

echo "[EARL-Init] DONE"