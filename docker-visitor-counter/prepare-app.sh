#!/usr/bin/env bash
set -e

APP_IMAGE="visitor-counter-web"
NETWORK_NAME="visitor-counter-network"
VOLUME_NAME="visitor-counter-data"

echo "Preparing app ..."

echo "Pulling Redis image ..."
docker pull redis:7-alpine

echo "Building Flask web image ..."
docker build -t "$APP_IMAGE" .

if ! docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
    echo "Creating Docker network ..."
    docker network create "$NETWORK_NAME"
else
    echo "Network already exists."
fi

if ! docker volume inspect "$VOLUME_NAME" >/dev/null 2>&1; then
    echo "Creating persistent Docker volume ..."
    docker volume create "$VOLUME_NAME"
else
    echo "Volume already exists."
fi

echo "Application resources are ready."
