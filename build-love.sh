#!/bin/bash

## Love2d directory
LOVE2D_DIR="love2d"
ARTIFACT_NAME="love.app"

# Clean up any remaining artifacts
rm -rf $LOVE2D_DIR
rm -rf $ARTIFACT_NAME

# Clone love2d github repository
## Love2d repository
LOVE2D_REPOSITORY="git@github.com:love2d/love.git"
## Clone love2d repository
GIT_TERMINAL_PROMPT=0 git clone $LOVE2D_REPOSITORY $LOVE2D_DIR
if [ $? -ne 0 ]; then { echo "Failed to clone love2d repository $LOVE2D_REPOSITORY" ; exit 1; } fi
## Enter Love2d directory
cd $LOVE2D_DIR

# Clone love2d apple dependencies
## Apple dependecies repository
APPLE_DEPENDENCIES_REPOSITORY="https://github.com/love2d/love-apple-dependencies"
## Apple dependecies directory
APPLE_DEPENDENCIES_DIR="love-apple-dependencies"
## Clone apple dependecies repository
GIT_TERMINAL_PROMPT=0 git clone $APPLE_DEPENDENCIES_REPOSITORY $APPLE_DEPENDENCIES_DIR
if [ $? -ne 0 ]; then 
	### Print error message
	echo "Failed to fetch apple dependecies for love2d: $APPLE_DEPENDENCIES_REPOSITORY"
	### Perform clean up
	rm -rf ../$LOVE2D_DIR
	### Script fails
	exit 1
fi

# Move apple dependecies to build xcode love2d project
FRAMEWORKS_DIR="macOS/Frameworks"
FRAMEWORKS_DEST="platform/xcode/macosx"
SHARED_LIB_DIR="shared"
SHARED_LIB_DEST="platform/xcode/shared"

mv "$APPLE_DEPENDENCIES_DIR/$FRAMEWORKS_DIR" $FRAMEWORKS_DEST
mv "$APPLE_DEPENDENCIES_DIR/$SHARED_LIB_DIR" $SHARED_LIB_DEST


# Build xcode project archive
xcodebuild clean archive -project platform/xcode/love.xcodeproj -scheme love-macosx -configuration Release -archivePath love-macos.xcarchive MACOSX_DEPLOYMENT_TARGET=15.0 >/dev/null
if [ $? -ne 0 ]; then { echo "Xcode build failed." ; exit 1; } fi

# Export xcode proeject archive as love.app
xcodebuild -exportArchive -archivePath love-macos.xcarchive -exportPath love-macos -exportOptionsPlist platform/xcode/macosx/macos-copy-app.plist >/dev/null
if [ $? -ne 0 ]; then { echo "Xcode export failed." ; exit 1; } fi

# Exit love2d directory
cd ..

# Extract love.app artifact
ARTIFACT_PATH="$LOVE2D_DIR/love-macos/love.app"
mv $ARTIFACT_PATH $ARTIFACT_NAME
rm -rf $LOVE2D_DIR

# Replace love2d artifact
rm -rf /Applications/$ARTIFACT_NAME
cp -r $ARTIFACT_NAME /Applications

