#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "docker-compose is not installed. Please install docker-compose first."
    exit 1
fi

# Stop and remove existing containers
echo "Stopping and removing existing containers..."
docker-compose down || true

# Start the application
echo "Starting the application..."
docker-compose up -d

echo "Deployment completed successfully."
