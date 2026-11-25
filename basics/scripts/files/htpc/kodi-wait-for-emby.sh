#!/bin/bash

function usage() {
    echo "Usage: $0"
    echo ""
    echo "Waits for the Emby container and its API to come up (60s timeout), then starts Kodi. Takes no options."
}

while [ $# -ge 1 ]; do
  case "$1" in
    --help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: unknown parameter \"$1\""
      usage
      exit 1
      ;;
  esac
  shift
done

# Config
CONTAINER_NAME=emby
API_URL="http://localhost:8096/emby/System/Info/Public"
TIMEOUT=60  # seconds
INTERVAL=2
WAITED=0

# Step 1: Wait for Docker container to be running
while ! docker inspect -f '{{.State.Running}}' "$CONTAINER_NAME" 2>/dev/null | grep -q true; do
    echo "Waiting for Emby container to start..."
    sleep $INTERVAL
    WAITED=$((WAITED + INTERVAL))
    if [ $WAITED -ge $TIMEOUT ]; then
        echo "ERROR: Timeout waiting for Emby container to start."
        exit 1
    fi
done

# Step 2: Wait for Emby API to respond
DEADLINE=$((SECONDS + TIMEOUT))
while ! curl -fs --max-time 5 "$API_URL" >/dev/null; do
    echo "Waiting for Emby API to respond..."
    sleep $INTERVAL
    if [ $SECONDS -ge $DEADLINE ]; then
        echo "ERROR: Timeout waiting for Emby REST API."
        exit 1
    fi
done

RESPONSE=$(curl -fsS --max-time 5 "$API_URL")
if ! echo "${RESPONSE}" | jq -e '.LocalAddresses' >/dev/null 2>&1; then
    echo "ERROR: Emby API returned unexpected response"
    exit 1
fi

echo "Sleeping for a bit to get things settle..."
sleep 60

echo "Emby is ready. Launching Kodi..."
flatpak run --branch=stable --arch=x86_64 --command=kodi tv.kodi.Kodi --standalone -fs
