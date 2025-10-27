#!/bin/bash
# Script to ensure Swift source files are part of the Xcode project

PROJECT_FILE="ios/Runner.xcodeproj/project.pbxproj"

for FILE in "BroadcastManager.swift" "PiPManager.swift"; do
  if ! grep -q "$FILE" "$PROJECT_FILE"; then
    echo "Adding $FILE to project.pbxproj"
    UUID=$(uuidgen | tr '[:lower:]' '[:upper:]')
    echo "/* $UUID */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = $FILE; sourceTree = \"<group>\"; };" >> "$PROJECT_FILE"
  fi
done
