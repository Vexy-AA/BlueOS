#!/usr/bin/env bash
set -e

VERSION="v1.0.0"
REPOSITORY_ORG="Vexy-AA"
REPOSITORY_NAME="WebTools"
PROJECT_NAME="webtools"
REPOSITORY_URL="https://github.com/$REPOSITORY_ORG/$REPOSITORY_NAME"

echo "Installing project $PROJECT_NAME version $VERSION"

ARTIFACT_NAME="$PROJECT_NAME.tar.gz"
REMOTE_URL="$REPOSITORY_URL/releases/download/$VERSION/$ARTIFACT_NAME"
echo "Remote URL is $REMOTE_URL"

INSTALL_FOLDER="/var/www/html/$PROJECT_NAME"
mkdir -p "$INSTALL_FOLDER"
echo "Installing to $INSTALL_FOLDER"

wget -q "$REMOTE_URL" -O - | tar -zxf - -C "$INSTALL_FOLDER"

echo "Finished installing $PROJECT_NAME"