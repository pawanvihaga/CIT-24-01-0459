#!/usr/bin/env bash
set -e

APP_IMAGE="visitor-counter-web"
NETWORK_NAME="visitor-counter-network"
VOLUME_NAME="visitor-counter-data"
WEB_CONTAINER="visitor-counter-web"
REDIS_CONTAINER="visitor-counter-redis"

echo "Removing application resources ..."

docker rm -f "$WEB_CONTAINER" >/dev/null 2>&1 || true
docker rm -f "$REDIS_CONTAINER" >/dev/null 2>&1 || true

docker network rm "$NETWORK_NAME" >/dev/null 2>&1 || true
docker volume rm "$VOLUME_NAME" >/dev/null 2>&1 || true
docker image rm "$APP_IMAGE" >/dev/null 2>&1 || true

echo "Removed app."
