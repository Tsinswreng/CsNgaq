#!/usr/bin/env sh
set -eu

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
BROWSER_PROJ_DIR="$ROOT_DIR/Ngaq.Frontend/proj/Ngaq.Browser"
SERVER_WWWROOT_DIR="$ROOT_DIR/Ngaq.Server/proj/Ngaq.Server.Http/wwwroot"

SRC_DEFAULT="$BROWSER_PROJ_DIR/bin/Release/net10.0-browser/publish/wwwroot"

if [ -d "$SRC_DEFAULT" ]; then
  SRC_DIR="$SRC_DEFAULT"
else
  SRC_DIR="$(find "$BROWSER_PROJ_DIR/bin/Release" -type d -path '*/publish/wwwroot' 2>/dev/null | head -n 1 || true)"
fi

if [ -z "${SRC_DIR:-}" ] || [ ! -d "$SRC_DIR" ]; then
  echo "error: could not find browser publish output."
  echo "hint: run 'dotnet publish -c Release' in Ngaq.Browser first."
  exit 1
fi

mkdir -p "$SERVER_WWWROOT_DIR"

if command -v rsync >/dev/null 2>&1; then
  rsync -a --delete "$SRC_DIR"/ "$SERVER_WWWROOT_DIR"/
else
  rm -rf "$SERVER_WWWROOT_DIR"/*
  cp -a "$SRC_DIR"/. "$SERVER_WWWROOT_DIR"/
fi

echo "synced:"
echo "  from: $SRC_DIR"
echo "    to: $SERVER_WWWROOT_DIR"
