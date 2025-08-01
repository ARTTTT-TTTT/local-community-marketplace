#!/bin/bash

# * chmod +x scripts/linux/clean-packages.sh
# * ./scripts/linux/clean-packages.sh

echo "Cleaning workspaces"

ROOT_DIR=$(pwd)
CLIENT_DIR="$ROOT_DIR/client"
MOBILE_DIR="$ROOT_DIR/mobile"
SERVER_DIR="$ROOT_DIR/server"

clean_workspace() {
  TARGET="$1"
  echo "Cleaning: $TARGET"

  # 1️⃣ Node.js / JS / TS
  rm -rf "$TARGET/node_modules"
  rm -rf "$TARGET/.next" "$TARGET/.turbo" "$TARGET/.cache" "$TARGET/dist"
  rm -f "$TARGET/pnpm-lock.yaml" "$TARGET/yarn.lock" "$TARGET/package-lock.json"

  # 2️⃣ Python / Poetry
  rm -rf "$TARGET/.venv" "$TARGET/venv"
  rm -f "$TARGET/poetry.lock" "$TARGET/Pipfile.lock"

  # 3️⃣ Flutter / Dart
  if [ -f "$TARGET/pubspec.yaml" ]; then
    echo "→ Detected Flutter project in $TARGET"
    if command -v flutter &> /dev/null; then
      (cd "$TARGET" && flutter clean)
    fi
    rm -rf "$TARGET/.dart_tool"
    rm -rf "$TARGET/build"
    rm -rf "$TARGET/ios/Pods" "$TARGET/ios/Podfile.lock"
    rm -rf "$TARGET/android/.gradle"
    rm -f "$TARGET/pubspec.lock"
  fi

  echo "Done: $TARGET"
  echo
}

# Clean all workspaces
clean_workspace "$ROOT_DIR"
clean_workspace "$CLIENT_DIR"
clean_workspace "$SERVER_DIR"
clean_workspace "$MOBILE_DIR"

echo "All clean completed."
