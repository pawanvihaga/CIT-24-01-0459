#!/usr/bin/env bash
set -e

WEB_CONTAINER="visitor-counter-web"
REDIS_CONTAINER="visitor-counter-redis"

echo "Stopping app ..."

docker stop "$WEB_CONTAINER" >/dev/null 2>&1 || true
docker stop "$REDIS_CONTAINER" >/dev/null 2>&1 || true

echo "Application stopped."
echo "Persistent Redis data has been preserved."
