#!/bin/bash
set -e
set -o pipefail

echo "--- [CI/CD Flutter Setup - Native] START ---"

# --- Definicja Ścieżek ---
FLUTTER_HOME="$CI_WORKSPACE_PATH/flutter"

# Ścieżki względne, skoro skrypt jest w ios/ci_scripts/
REPO_ROOT="../.." # Katalog główny repozytorium
IOS_DIR="../" # Katalog ios/

echo "Ścieżki robocze:"
echo "Repozytorium (Root): $REPO_ROOT"
echo "Katalog iOS: $IOS_DIR"

# 1. Klonowanie i instalacja Flutter SDK (OK)
echo "1. Klonowanie i instalacja Flutter SDK (stable)..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$FLUTTER_HOME"
export PATH="$PATH:$FLUTTER_HOME/bin"
flutter --version

# 2. Pub Get
echo "2. Uruchamianie 'flutter pub get' w katalogu repozytorium..."
cd "$REPO_ROOT" # Z ios/ci_scripts -> do katalogu głównego
flutter pub get

# 3. Pod Install
echo "3. Uruchamianie 'pod install' w folderze iOS..."
# Jesteśmy w katalogu głównym (np. /Volumes/workspace/repository). 
# Musimy wejść do folderu ios.
cd ios 
xcrun pod install

echo "--- [CI/CD Flutter Setup - Native] COMPLETED ---"