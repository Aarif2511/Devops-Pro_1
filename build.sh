#!/usr/bin/env bash

set -euo pipefail

REGISTRY_USER="${DOCKERHUB_USERNAME:?Set DOCKERHUB_USERNAME first}"
REPO="${1:-dev}"
TAG="${2:-local}"

IMAGE="${REGISTRY_USER}/${REPO}:${TAG}"

echo "Building ${IMAGE}"

docker build --pull -t "${IMAGE}" .

if [[ "${REPO}" == "dev" ]]; then
    docker tag "${IMAGE}" "${REGISTRY_USER}/${REPO}:latest-dev"
else
    docker tag "${IMAGE}" "${REGISTRY_USER}/${REPO}:latest"
fi

echo "Build completed:"
docker images "${REGISTRY_USER}/${REPO}"