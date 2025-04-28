#!/bin/bash
set -e

IMAGE=$1

if [ -z "$IMAGE" ]; then
  echo "❌ IMAGE must be provided as arguments."
  exit 1
fi

echo "🔐 Logging in to Docker Hub..."
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

echo "🚀 Pushing image: $IMAGE"
docker push "$IMAGE"

echo "✅ Docker image pushed successfully: $IMAGE"