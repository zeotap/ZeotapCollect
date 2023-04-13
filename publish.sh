#!/bin/bash

TAG_NAME = "${BRANCH_NAME#release-}"

# Create the tag
git tag -a $TAG_NAME -m "Release Version $TAG_NAME"

# Push the tag to the remote repository
git push origin $TAG_NAME
