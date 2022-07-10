#! /bin/sh

docker buildx build \
    --push \
    --platform=linux/amd64,linux/arm/v7,linux/arm64 \
    --label 'org.opencontainers.image.source=https://github.com/BorisWilhelms/azure-dns-updater' \
    -t ghcr.io/boriswilhelms/azure-dns-updater:latest \
    .