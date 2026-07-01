#!/usr/bin/env bash
#
# Build the Windows (NSIS .exe) installer on macOS WITHOUT internet access to
# GitHub. It serves the prebuilt binaries you placed in offline-deps/ from a
# local HTTP server and points electron-builder at it via the mirror env vars.
#
# Prerequisite: put these 3 files in place (see offline-deps/README.md):
#   offline-deps/22.3.27/electron-v22.3.27-win32-x64.zip
#   offline-deps/nsis-3.0.4.1/nsis-3.0.4.1.7z
#   offline-deps/nsis-resources-3.4.1/nsis-resources-3.4.1.7z
#
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEPS="$ROOT/offline-deps"
PORT="${OFFLINE_MIRROR_PORT:-8099}"

need() {
  if [ ! -f "$1" ]; then
    echo "ERROR: missing required file:" >&2
    echo "  $1" >&2
    echo "See offline-deps/README.md for the download URL." >&2
    exit 1
  fi
}

need "$DEPS/22.3.27/electron-v22.3.27-win32-x64.zip"
need "$DEPS/nsis-3.0.4.1/nsis-3.0.4.1.7z"
need "$DEPS/nsis-resources-3.4.1/nsis-resources-3.4.1.7z"

echo "Starting local mirror on http://127.0.0.1:$PORT/ ..."
( cd "$DEPS" && exec python3 -m http.server "$PORT" --bind 127.0.0.1 ) >/tmp/offline-mirror.log 2>&1 &
SRV=$!
cleanup() { kill "$SRV" 2>/dev/null || true; }
trap cleanup EXIT
sleep 1

export ELECTRON_MIRROR="http://127.0.0.1:$PORT/"
export ELECTRON_BUILDER_BINARIES_MIRROR="http://127.0.0.1:$PORT/"

echo "Building Windows NSIS x64 installer (offline)..."
cd "$ROOT"
npx electron-builder --win nsis --x64

echo
echo "Done. Installer(s):"
find "$ROOT/dist" -maxdepth 1 -iname "*.exe" -exec ls -lh {} \;
