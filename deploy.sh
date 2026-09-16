#!/usr/bin/env bash

set -euo pipefail

IMAGE_NAME="${1:?Image name required}"
IMAGE_TAG="${2:?Image tag required}"

export IMAGE_NAME
export IMAGE_TAG

cd /opt/devops-build

echo "Deploying ${IMAGE_NAME}:${IMAGE_TAG}"

echo "Pulling production image..."
docker compose pull

echo "Starting application..."
docker compose up -d --remove-orphans

echo "Waiting for application health..."

for i in {1..20}; do
    if curl -fsS http://127.0.0.1/health >/dev/null; then
        echo "Application is healthy."
        docker compose ps
        exit 0
    fi

    echo "Health check attempt ${i}/20 failed. Retrying..."
    sleep 3
done

echo "Application did not become healthy."

docker compose ps
docker compose logs --tail=100 web

exit 1
