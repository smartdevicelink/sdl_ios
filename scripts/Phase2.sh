#!/bin/bash

# George Miller
# 05-17-2022
# If you don't have permission to run, try: chmod u+x phase1.sh
# numbering in comments is per https://github.com/smartdevicelink/sdl_ios/wiki/Release-Steps

echo "Hello World"

# 1 bump version in projectFile
# sed stream edit.  It's fast, and can make changes.
version_number=$(sed -n '/MARKETING_VERSION/{s/MARKETING_VERSION = //;s/;//;s/^[[:space:]]*//;p;q;}' ./SmartDeviceLink-iOS.xcodeproj/project.pbxproj)
build_number=$(sed -n '/CURRENT_PROJECT_VERSION/{s/CURRENT_PROJECT_VERSION = //;s/;//;s/^[[:space:]]*//;p;q;}' ./SmartDeviceLink-iOS.xcodeproj/project.pbxproj)
echo "Version "$version_number
echo "build "$build_number

# 2 update version in podspec
# SmartDeviceLink-iOS.podspec

