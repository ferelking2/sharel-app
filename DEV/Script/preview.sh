#!/usr/bin/env bash
set -euo pipefail

# dev/preview.sh
# Quick preview for Flutter Web (prebuild) + lightweight static server
# Usage: ./dev/preview.sh [--port PORT] [--no-build]

PORT=8000
DO_BUILD=true

while [[ $# -gt 0 ]]; do
  case "$1" in
    --port)
      PORT="$2"; shift 2;;
    --no-build)
      DO_BUILD=false; shift;;
    -h|--help)
      echo "Usage: $0 [--port PORT] [--no-build]"; exit 0;;
    *) echo "Unknown arg: $1"; exit 1;;
  esac
done

echo "Preview script starting — port=$PORT, build=$DO_BUILD"

if [ "$DO_BUILD" = true ]; then
  echo "Running: flutter build web"
  flutter build web || { echo "flutter build web failed"; exit 2; }
fi

cd build/web || { echo "build/web not found — run with --no-build if you already built"; exit 3; }

# Prefer python simple server if available
if command -v python3 >/dev/null 2>&1; then
  echo "Serving build/web with python3 -m http.server $PORT"
  # Run in foreground — user can CTRL+C to stop
  python3 -m http.server "$PORT"
elif command -v python >/dev/null 2>&1; then
  echo "Serving build/web with python -m http.server $PORT"
  python -m http.server "$PORT"
elif command -v npx >/dev/null 2>&1 && command -v serve >/dev/null 2>&1; then
  echo "Serving build/web with npx serve -l $PORT"
  npx serve build/web -l "$PORT"
elif command -v npx >/dev/null 2>&1; then
  echo "Using npx to install serve and run it"
  npx serve build/web -l "$PORT"
else
  echo "No python or npx available to serve files. Install Python 3 or npm (npx)."; exit 4
fi
