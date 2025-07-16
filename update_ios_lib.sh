#!/bin/bash

# iOS Library Update Script
# Usage: ./update_ios_lib.sh <version>
# Example: ./update_ios_lib.sh 1.3.3

set -e  # Exit on any error

# Check if version argument is provided
if [ $# -eq 0 ]; then
    echo "Error: Please provide a version number"
    echo "Usage: $0 <version>"
    echo "Example: $0 1.3.3"
    exit 1
fi

VERSION=$1
BRANCH_NAME="upgrading-to-$VERSION"
SDK_URL="https://content.zeotap.com/ios-sdk/v$VERSION/ios-collect-sdk.zip"
ZIP_FILE="ios-collect-sdk.zip"

echo "Starting iOS library update to version $VERSION..."

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Create and switch to new branch
echo "Creating and switching to branch: $BRANCH_NAME"
git checkout -b "$BRANCH_NAME"

# Download the library zip file
echo "Downloading iOS SDK from: $SDK_URL"
if ! curl -L -o "$ZIP_FILE" "$SDK_URL"; then
    echo "Error: Failed to download the SDK from $SDK_URL"
    exit 1
fi

# Verify the file was downloaded
if [ ! -f "$ZIP_FILE" ]; then
    echo "Error: Downloaded file not found"
    exit 1
fi

# Calculate checksum
echo "Calculating checksum for $ZIP_FILE"
CHECKSUM=$(shasum -a 256 "$ZIP_FILE" | cut -d' ' -f1)
echo "New checksum: $CHECKSUM"

# Update Package.swift with new URL and checksum
echo "Updating Package.swift..."
sed -i.bak "s|url: \"https://content.zeotap.com/ios-sdk/[^\"]*\"|url: \"$SDK_URL\"|g" Package.swift
sed -i.bak "s|checksum: \"[^\"]*\"|checksum: \"$CHECKSUM\"|g" Package.swift

# Remove backup file
rm Package.swift.bak

# Extract the downloaded zip file
echo "Extracting $ZIP_FILE"
if ! unzip -q "$ZIP_FILE"; then
    echo "Error: Failed to extract $ZIP_FILE"
    exit 1
fi

# Check if ZeotapCollect.xcframework exists in extracted files
if [ ! -d "ZeotapCollect.xcframework" ]; then
    echo "Error: ZeotapCollect.xcframework not found in extracted files"
    exit 1
fi

# Remove old xcframework if it exists and replace with new one
if [ -d "ZeotapCollect.xcframework.old" ]; then
    rm -rf "ZeotapCollect.xcframework.old"
fi

# Backup existing framework
if [ -d "ZeotapCollect.xcframework" ]; then
    echo "Backing up existing ZeotapCollect.xcframework"
    mv "ZeotapCollect.xcframework" "ZeotapCollect.xcframework.old"
fi

# Move the new framework from extracted files
echo "Installing new ZeotapCollect.xcframework"
if [ -d "ZeotapCollect.xcframework" ]; then
    # Framework is already in the right place from extraction
    echo "New framework installed successfully"
else
    echo "Error: New ZeotapCollect.xcframework not found after extraction"
    exit 1
fi

# Clean up downloaded zip file and any extracted folders
echo "Cleaning up downloaded files..."
rm "$ZIP_FILE"

# Remove any other extracted files/folders (if any exist besides the framework)
for item in *; do
    if [ "$item" != "ZeotapCollect.xcframework" ] && [ "$item" != "ZeotapCollect.xcframework.old" ] && [ -d "$item" ] && [[ "$item" == *"ios-collect-sdk"* || "$item" == *"ZeotapCollect"* ]]; then
        echo "Removing extracted folder: $item"
        rm -rf "$item"
    fi
done

# Remove old backup
if [ -d "ZeotapCollect.xcframework.old" ]; then
    rm -rf "ZeotapCollect.xcframework.old"
fi

# Update ZeotapCollect.podspec version
echo "Updating ZeotapCollect.podspec version..."
sed -i.bak "s|s.version.*=.*\"[^\"]*\"|s.version      = \"$VERSION\"|g" ZeotapCollect.podspec

# Remove backup file
rm ZeotapCollect.podspec.bak

# Stage all changes
echo "Staging changes..."
git add .

# Commit changes
echo "Committing changes..."
git commit -m "Updated ZeotapCollect version to $VERSION"

# Push to remote
echo "Pushing to remote..."
git push origin "$BRANCH_NAME"

echo "✅ Successfully updated ZeotapCollect to version $VERSION"
echo "Branch '$BRANCH_NAME' has been created and pushed to remote"
echo "You can now create a pull request to merge these changes"