#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Build Docker image
echo "Building Docker image..."
docker build -t devops-build-app .

# Tag the image
echo "Tagging image..."
docker tag devops-build-app <your-dockerhub-username>/dev:latest

echo "Build completed successfully."
