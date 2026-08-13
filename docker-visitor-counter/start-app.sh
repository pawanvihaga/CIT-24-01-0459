#!/usr/bin/env bash
set -e

APP_IMAGE="visitor-counter-web"
NETWORK_NAME="visitor-counter-network"
VOLUME_NAME="visitor-counter-data"
WEB_CONTAINER="visitor-counter-web"
REDIS_CONTAINER="visitor-counter-redis"

echo "Running app ..."

if ! docker image inspect "$APP_IMAGE" >/dev/null 2>&1; then
    echo "Web image not found. Run ./prepare-app.sh first."
    exit 1
fi

if ! docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
    echo "Network not found. Run ./prepare-app.sh first."
    exit 1
fi

if ! docker volume inspect "$VOLUME_NAME" >/dev/null 2>&1; then
    echo "Volume not found. Run ./prepare-app.sh first."
    exit 1
fi

# Recreate containers so updated configuration/images can be applied.
# The Redis named volume is preserved, so the visitor count is not reset.
docker rm -f "$WEB_CONTAINER" >/dev/null 2>&1 || true
docker rm -f "$REDIS_CONTAINER" >/dev/null 2>&1 || true

echo "Starting Redis service ..."
docker run -d \
    --name "$REDIS_CONTAINER" \
    --network "$NETWORK_NAME" \
    --restart unless-stopped \
    -p 6379:6379 \
    -v "$VOLUME_NAME":/data \
    redis:7-alpine \
    redis-server --appendonly yes

echo "Starting Flask web service ..."
docker run -d \
    --name "$WEB_CONTAINER" \
    --network "$NETWORK_NAME" \
    --restart unless-stopped \
    -p 5000:5000 \
    -e REDIS_HOST="$REDIS_CONTAINER" \
    -e REDIS_PORT=6379 \
    "$APP_IMAGE"

echo "The app is available at http://localhost:5000"
echo "Redis is available on localhost:6379"
