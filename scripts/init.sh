#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define variables
BASE_DIR="/opt/media"
TARGET_UID="1000"
TARGET_GID="1000"

echo "========================================"
echo "  Initializing Arr Stack Infrastructure "
echo "========================================"

# Check if script is run as root (needed for /opt)
if [ "$EUID" -ne 0 ]; then 
  echo "❌ Please run this script with sudo."
  exit 1
fi

echo "1. Creating Base Directories..."
# Data & Media paths (for hardlinks)
mkdir -p "$BASE_DIR/data/torrents/tv"
mkdir -p "$BASE_DIR/data/torrents/movies"
mkdir -p "$BASE_DIR/data/media/tv"
mkdir -p "$BASE_DIR/data/media/movies"

# Config paths
mkdir -p "$BASE_DIR/config/gluetun"
mkdir -p "$BASE_DIR/config/qbittorrent"
mkdir -p "$BASE_DIR/config/prowlarr"
mkdir -p "$BASE_DIR/config/sonarr"
mkdir -p "$BASE_DIR/config/radarr"
mkdir -p "$BASE_DIR/config/jellyfin"
mkdir -p "$BASE_DIR/config/plex"
mkdir -p "$BASE_DIR/config/jellyseerr"

# Utilities paths
mkdir -p "$BASE_DIR/scripts"
mkdir -p "$BASE_DIR/backups"

echo "2. Setting Ownership to $TARGET_UID:$TARGET_GID..."
chown -R $TARGET_UID:$TARGET_GID "$BASE_DIR"

echo "3. Setting Permissions (775)..."
chmod -R 775 "$BASE_DIR"

echo "========================================"
echo "✅ Infrastructure provisioned successfully."
echo "Your environment at $BASE_DIR is ready."
echo "========================================"
