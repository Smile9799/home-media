#!/bin/bash

# Define the data path
DATA_DIR="/opt/media/data"
TARGET_UID="1000"
TARGET_GID="1000"

echo "Enforcing ownership ($TARGET_UID:$TARGET_GID) on $DATA_DIR..."
chown -R $TARGET_UID:$TARGET_GID "$DATA_DIR"

echo "Setting standard directory permissions (775)..."
find "$DATA_DIR" -type d -exec chmod 775 {} \;

echo "Setting standard file permissions (664)..."
find "$DATA_DIR" -type f -exec chmod 664 {} \;

echo "Permissions fixed successfully."
