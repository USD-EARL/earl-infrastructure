#!/bin/bash

set -e

PROJECT_NAME="earl-infrastructure"
EMUX_SUFFIX="emux"

./portmirror.sh --cleanup
wait

echo "Stopping all containers associated with $PROJECT_NAME and suffix $EMUX_SUFFIX..."
docker ps -a --filter "name=$PROJECT_NAME" --format "{{.ID}}" | xargs -r docker stop
docker ps -a --filter "name=$EMUX_SUFFIX" --format "{{.ID}}" | xargs -r docker stop

echo "Removing all containers associated with $PROJECT_NAME and suffix $EMUX_SUFFIX..."
docker ps -a --filter "name=$PROJECT_NAME" --format "{{.ID}}" | xargs -r docker rm
docker ps -a --filter "name=$EMUX_SUFFIX" --format "{{.ID}}" | xargs -r docker rm
wait

echo "Removing all images associated with $PROJECT_NAME containers and suffix $EMUX_SUFFIX..."
docker images --filter "reference=$PROJECT_NAME*" --format "{{.Repository}}:{{.Tag}}" | xargs -r docker rmi -f
docker images --filter "reference=*:$EMUX_SUFFIX" --format "{{.Repository}}:{{.Tag}}" | xargs -r docker rmi -f
wait

echo "Removing all networks associated with $PROJECT_NAME..."
docker network ls --filter "name=$PROJECT_NAME" --format "{{.Name}}" | grep -vE "^(bridge|host|none)$" | xargs -r docker network rm
wait

echo "Ensuring all containers are fully removed before removing volumes..."
sleep 10  # Wait for 10 seconds to allow Docker to update its internal state

echo "Removing all volumes associated with $PROJECT_NAME..."
docker volume ls --filter "name=$PROJECT_NAME" --format "{{.Name}}" | xargs -r docker volume rm
wait

echo "Cleanup complete."
