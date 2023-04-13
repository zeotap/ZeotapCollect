#!/bin/bash

#TAG_NAME = "${BRANCH_NAME#release-}"

# Create the tag
git tag -a "$BRANCH_NAME#release-" -m "Release Version "${BRANCH_NAME#release-}""

# Push the tag to the remote repository
git push origin "$BRANCH_NAME#release-"
