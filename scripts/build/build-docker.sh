#!/bin/bash

# Multi-stage Docker build script with caching optimization
# Usage: ./build-docker.sh [options]

set -e

# Default values
BASE_IMAGE="python:3.11-slim"
TARGET_BOARD="generic"
USER_ID=$(id -u)
GROUP_ID=$(id -g)
TAG="lifi-dev"
CACHE_REGISTRY=""
PUSH_CACHE=false
ARCHITECTURE=""
DEBUG_PROGRESS=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print usage
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "OPTIONS:"
    echo "  -b, --base-image IMAGE     Base image (default: python:3.11-slim)"
    echo "  -t, --target-board BOARD   Target board (default: generic)" 
    echo "  -u, --user-id ID          User ID (default: current user)"
    echo "  -g, --group-id ID         Group ID (default: current group)"
    echo "  -n, --tag TAG             Docker image tag (default: lifi-dev)"
    echo "  -c, --cache-registry URL  Registry for cache (e.g., registry.example.com/cache)"
    echo "  -p, --push-cache          Push cache to registry"
    echo "  -a, --arch ARCH           Target architecture (e.g., linux/amd64, linux/arm64)"
    echo "  -d, --debug               Enable debug output with --progress=plain"
    echo "  -h, --help                Show this help message"
    echo ""
    echo "EXAMPLES:"
    echo "  # Build for ARM64 architecture"
    echo "  $0 --base-image arm64v8/python:3.11-slim --arch linux/arm64"
    echo ""
    echo "  # Build with cache registry"
    echo "  $0 --cache-registry registry.example.com/cache --push-cache"
    echo ""
    echo "  # Build for specific target board"
    echo "  $0 --target-board esp32 --tag lifi-esp32"
    echo ""
    echo "  # Build with debug output"
    echo "  $0 --debug"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -b|--base-image)
            BASE_IMAGE="$2"
            shift 2
            ;;
        -t|--target-board)
            TARGET_BOARD="$2"
            shift 2
            ;;
        -u|--user-id)
            USER_ID="$2"
            shift 2
            ;;
        -g|--group-id)
            GROUP_ID="$2"
            shift 2
            ;;
        -n|--tag)
            TAG="$2"
            shift 2
            ;;
        -c|--cache-registry)
            CACHE_REGISTRY="$2"
            shift 2
            ;;
        -p|--push-cache)
            PUSH_CACHE=true
            shift
            ;;
        -a|--arch)
            ARCHITECTURE="$2"
            shift 2
            ;;
        -d|--debug)
            DEBUG_PROGRESS=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Print build configuration
echo -e "${BLUE}=== Docker Build Configuration ===${NC}"
echo -e "${YELLOW}Base Image:${NC} $BASE_IMAGE"
echo -e "${YELLOW}Target Board:${NC} $TARGET_BOARD"
echo -e "${YELLOW}User ID:${NC} $USER_ID"
echo -e "${YELLOW}Group ID:${NC} $GROUP_ID"
echo -e "${YELLOW}Tag:${NC} $TAG"
if [[ -n "$CACHE_REGISTRY" ]]; then
    echo -e "${YELLOW}Cache Registry:${NC} $CACHE_REGISTRY"
fi
if [[ -n "$ARCHITECTURE" ]]; then
    echo -e "${YELLOW}Architecture:${NC} $ARCHITECTURE"
fi
if [[ "$DEBUG_PROGRESS" == "true" ]]; then
    echo -e "${YELLOW}Debug Progress:${NC} enabled"
fi
echo ""

# Build Docker buildx command
BUILDX_CMD="docker buildx build"

# Add platform if specified
if [[ -n "$ARCHITECTURE" ]]; then
    BUILDX_CMD="$BUILDX_CMD --platform $ARCHITECTURE"
fi

# Add cache options if registry is specified
if [[ -n "$CACHE_REGISTRY" ]]; then
    BUILDX_CMD="$BUILDX_CMD --cache-from=type=registry,ref=$CACHE_REGISTRY:buildcache"
    if [[ "$PUSH_CACHE" == "true" ]]; then
        BUILDX_CMD="$BUILDX_CMD --cache-to=type=registry,ref=$CACHE_REGISTRY:buildcache,mode=max"
    fi
fi

# Add build arguments
BUILDX_CMD="$BUILDX_CMD --build-arg BASE_IMAGE=$BASE_IMAGE"
BUILDX_CMD="$BUILDX_CMD --build-arg USER_ID=$USER_ID"
BUILDX_CMD="$BUILDX_CMD --build-arg GROUP_ID=$GROUP_ID"
BUILDX_CMD="$BUILDX_CMD --build-arg TARGET_BOARD=$TARGET_BOARD"

# Add tag and target
# Note: Removed --target dev as Dockerfile doesn't have multi-stage builds
BUILDX_CMD="$BUILDX_CMD --tag $TAG"
BUILDX_CMD="$BUILDX_CMD --load"

# Add debug progress if requested
if [[ "$DEBUG_PROGRESS" == "true" ]]; then
    BUILDX_CMD="$BUILDX_CMD --progress=plain"
fi

BUILDX_CMD="$BUILDX_CMD ."

echo -e "${BLUE}=== Building Docker Image ===${NC}"
echo -e "${YELLOW}Command:${NC} $BUILDX_CMD"
echo ""

# Execute the build
eval $BUILDX_CMD

if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}=== Build Successful ===${NC}"
    echo -e "${GREEN}Image built:${NC} $TAG"
    echo ""
    echo -e "${BLUE}=== Build Cache Information ===${NC}"
    docker system df
    echo ""
    echo -e "${BLUE}=== Next Steps ===${NC}"
    echo -e "${YELLOW}Run the container:${NC}"
    echo "  docker run -it --rm --privileged -v \$(pwd):/workspace $TAG"
    echo ""
    echo -e "${YELLOW}Run with serial device access:${NC}"
    echo "  docker run -it --rm --privileged --device=/dev/ttyUSB0 -v \$(pwd):/workspace $TAG"
else
    echo -e "${RED}=== Build Failed ===${NC}"
    exit 1
fi
