#!/bin/bash

STACK_DIR="/opt/home-media"

echo "Navigating to stack directory: $STACK_DIR"
cd "$STACK_DIR" || exit

echo "Pulling latest Docker images..."
docker compose pull

echo "Applying updates and recreating containers..."
docker compose up -d

echo "Pruning old unused Docker images..."
docker image prune -af

echo "Arr stack update complete."
