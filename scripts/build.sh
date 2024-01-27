#!/bin/zsh

PROJECT_NAME=$1
TARGET_NAME=$2

if [[ "$#" -ne 2 ]]; then
    echo "Illegal number of parameters. Usage: build.sh project_name target_name"
    exit 1
fi

echo "Building target $2 from project $1"

cmake -S . -B build_iOS -GXcode -DCMAKE_SYSTEM_NAME=iOS
xcodebuild archive \
    -project build_iOS/${PROJECT_NAME}.xcodeproj \
    -scheme $TARGET_NAME \
    -archivePath "install/archives/${TARGET_NAME}-iOS" \
    -destination "generic/platform=iOS"

cmake -S . -B build_iOS_Simulator -GXcode -DCMAKE_SYSTEM_NAME=iOS
xcodebuild archive \
    -project build_iOS_Simulator/${PROJECT_NAME}.xcodeproj \
    -scheme $TARGET_NAME \
    -archivePath "install/archives/${TARGET_NAME}-iOS_Simulator" \
    -destination "generic/platform=iOS Simulator"

cmake -S . -B build_macOS -GXcode -DCMAKE_SYSTEM_NAME=Darwin
xcodebuild archive \
    -project build_macOS/${PROJECT_NAME}.xcodeproj \
    -scheme $TARGET_NAME \
    -archivePath "install/archives/${TARGET_NAME}-macOS" \
    -destination "generic/platform=macOS"

xcodebuild -create-xcframework \
    -archive install/archives/${TARGET_NAME}-iOS.xcarchive -framework ${TARGET_NAME}.framework \
    -archive install/archives/${TARGET_NAME}-iOS_Simulator.xcarchive -framework ${TARGET_NAME}.framework \
    -archive install/archives/${TARGET_NAME}-macOS.xcarchive -framework ${TARGET_NAME}.framework \
    -output install/xcframeworks/${TARGET_NAME}.xcframework
