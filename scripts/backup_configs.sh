#!/bin/bash

# Define paths
BACKUP_DIR="/opt/home-media/backups"
SOURCE_DIR="/opt/home-media/config"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/arr_configs_$DATE.tar.gz"

echo "Starting backup of Arr stack configurations..."

# Compress the config directory
tar -czf "$BACKUP_FILE" -C /opt/home-media config

# Verify if the backup was successful
if [ $? -eq 0 ]; then
    echo "Backup successful: $BACKUP_FILE"
    
    # Delete backups older than 7 days to save space
    echo "Cleaning up old backups..."
    find "$BACKUP_DIR" -name "arr_configs_*.tar.gz" -type f -mtime +7 -exec rm {} \;
    echo "Cleanup complete."
else
    echo "Error: Backup failed!" >&2
    exit 1
fi
