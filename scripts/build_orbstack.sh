#!/usr/bin/env bash
set -euo pipefail

IMAGE="${1:-ghcr.io/natmurad/seqworkflows:1.0.0}"
PLATFORM="${SEQWORKFLOWS_DOCKER_PLATFORM:-linux/amd64}"

if command -v docker >/dev/null 2>&1; then
  DOCKER_BIN="$(command -v docker)"
elif [ -x /Applications/OrbStack.app/Contents/MacOS/xbin/docker ]; then
  DOCKER_BIN="/Applications/OrbStack.app/Contents/MacOS/xbin/docker"
else
  echo "Docker CLI not found. Start/install OrbStack, then try again." >&2
  exit 1
fi

"${DOCKER_BIN}" build \
  --platform "${PLATFORM}" \
  -f containers/seqworkflows.Dockerfile \
  -t "${IMAGE}" \
  .
