#!/usr/bin/env bash
set -e

COMMIT="e974f7a9c4d816e2b69df86774bee63747e865d0"
REPOSITORY_ORG="ArduPilot"          # or your fork (see step 5)
REPOSITORY_NAME="WebTools"
PROJECT_NAME="webtools"
REPOSITORY_URL="https://github.com/Vexy-AA/WebTools.git"

echo "Installing project $PROJECT_NAME @ $COMMIT"

INSTALL_FOLDER="/var/www/html/$PROJECT_NAME"
mkdir -p "$INSTALL_FOLDER"

git clone --recurse-submodules "$REPOSITORY_URL" "$INSTALL_FOLDER"
git -C "$INSTALL_FOLDER" checkout "$COMMIT"
git -C "$INSTALL_FOLDER" submodule update --init --recursive

# strip git metadata to shrink the image
find "$INSTALL_FOLDER" -name ".git*" -prune -exec rm -rf {} +

echo "Finished installing $PROJECT_NAME"