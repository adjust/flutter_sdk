#!/usr/bin/env bash

# Exit if any errors occur
#set -e

# Get the current directory (/scripts/ directory)
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Traverse up to get to the root directory
SDK_DIR="$(dirname "$SCRIPTS_DIR")"
cd example

RED='\033[0;31m' # Red color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No Color

echo -e "${GREEN}>>> building Flutter Java APK... ${NC}"
flutter build apk

echo -e "${GREEN}>>> building Flutter Java APK... ${NC}"
flutter run
