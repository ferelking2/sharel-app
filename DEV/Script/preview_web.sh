#!/usr/bin/env bash
set -euo pipefail

# dev/preview_web.sh
# Usage: ./dev/preview_web.sh
# Builds Flutter web and serves build/web on 0.0.0.0:8000 (Python3 preferred, falls back to npx serve)

echo "Building Flutter web (release)..."
flutter build web --release

if command -v python3 >/dev/null 2>&1; then
  echo "Serving build/web with python3 HTTP server on http://0.0.0.0:8000"
  cd build/web
  python3 -m http.server 8000 --bind 0.0.0.0
elif command -v python >/dev/null 2>&1; then
  echo "Serving build/web with python HTTP server on http://0.0.0.0:8000"
  cd build/web
  python -m http.server 8000 --bind 0.0.0.0
elif command -v npx >/dev/null 2>&1; then
  echo "Serving build/web with npx serve on http://0.0.0.0:8000"
  npx serve build/web -l 8000
else
  echo "ERROR: neither python nor npx found. Install python3 or npx (node) to serve build/web." >&2
  exit 1
fi
