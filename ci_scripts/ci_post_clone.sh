#!/bin/bash
# Xcode Cloud post-clone setup for Flutter + CocoaPods
set -euo pipefail

FLUTTER_VERSION="${FLUTTER_VERSION:-stable}"
FLUTTER_ROOT="$HOME/flutter"

if [ ! -d "$FLUTTER_ROOT" ]; then
  echo "Cloning Flutter ($FLUTTER_VERSION) into $FLUTTER_ROOT..."
  git clone --filter=blob:none --depth 1 --branch "$FLUTTER_VERSION" https://github.com/flutter/flutter.git "$FLUTTER_ROOT"
fi

export PATH="$FLUTTER_ROOT/bin:$PATH"

REPO_PATH="${CI_PRIMARY_REPOSITORY_PATH:-$(cd "$(dirname "$0")/.." && pwd)}"

echo "Using repository path: $REPO_PATH"

cd "$REPO_PATH"

echo "Running flutter config..."
flutter config --no-analytics

echo "Pre-caching Flutter artifacts..."
flutter precache --ios

echo "Fetching Dart/Flutter dependencies..."
flutter pub get

echo "Repairing Flutter pub cache (ensures dependencies exist in CI)..."
flutter pub cache repair

echo "Generating iOS build configuration..."
flutter build ios --config-only --no-codesign

echo "Installing CocoaPods dependencies..."
cd "$REPO_PATH/ios"
pod install --repo-update

