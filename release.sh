#!/bin/bash

# Release Script for ZeotapCollect
# Usage: ./release.sh <version>
# Example: ./release.sh 1.3.3

set -e  # Exit on any error

# Check if version argument is provided
if [ $# -eq 0 ]; then
    echo "Error: Please provide a version number"
    echo "Usage: $0 <version>"
    echo "Example: $0 1.3.3"
    exit 1
fi

VERSION=$1

echo "Starting release process for version $VERSION..."

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Check if ZeotapCollect.podspec exists
if [ ! -f "ZeotapCollect.podspec" ]; then
    echo "Error: ZeotapCollect.podspec not found in current directory"
    exit 1
fi

# Create git tag
echo "Creating git tag: $VERSION"
if git tag -a "$VERSION" -m "Release version $VERSION"; then
    echo "✅ Git tag '$VERSION' created successfully"
else
    echo "Error: Failed to create git tag '$VERSION'"
    exit 1
fi

# Push tag to origin
echo "Pushing tag to origin..."
if git push origin "$VERSION"; then
    echo "✅ Tag '$VERSION' pushed to origin successfully"
else
    echo "Error: Failed to push tag '$VERSION' to origin"
    exit 1
fi

# Publish to CocoaPods
echo "Publishing to CocoaPods..."
if pod trunk push ZeotapCollect.podspec; then
    echo "✅ Successfully published ZeotapCollect.podspec to CocoaPods"
else
    echo "Error: Failed to publish to CocoaPods"
    exit 1
fi

echo "🎉 Release $VERSION completed successfully!"
echo "- Git tag '$VERSION' created and pushed"
echo "- Pod published to CocoaPods trunk"