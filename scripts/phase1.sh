#!/bin/bash

# George Miller
# 05-17-2022
# If you don't have permission to run, try: chmod u+x phase1.sh
# numbering in comments is per https://github.com/smartdevicelink/sdl_ios/wiki/Release-Steps

echo "Zug Zug"

# 2 push new release to primary cocoapod
echo "2 push new release to primary Cocoapod"
pod trunk push SmartDeviceLink.podspec --allow-warnings

# 3 Push the new release to the secondary cocoapod using command line:
echo "3 Push the new release to the secondary cocoapod using command line:"
pod trunk push SmartDeviceLink-iOS.podspec --allow-warnings.

# 4 add binary xcframework archive for manual installation
echo "4 add binary xcframework archive for manual installation"
# i
echo "4.i"
xcodebuild archive -project 'SmartDeviceLink-iOS.xcodeproj/' -scheme 'SmartDeviceLink' -configuration Release -destination 'generic/platform=iOS' -archivePath './SmartDeviceLink-Device.xcarchive' SKIP_INSTALL=NO

# ii
echo "4.ii"
xcodebuild archive -project 'SmartDeviceLink-iOS.xcodeproj/' -scheme 'SmartDeviceLink' -configuration Release -destination 'generic/platform=iOS Simulator' -archivePath './SmartDeviceLink-Simulator.xcarchive' SKIP_INSTALL=NO

# iii
echo "4.iii"
xcodebuild -create-xcframework -framework './SmartDeviceLink-Device.xcarchive/Products/Library/Frameworks/SmartDeviceLink.framework/' -framework './SmartDeviceLink-Simulator.xcarchive/Products/Library/Frameworks/SmartDeviceLink.framework/' -output './SmartDeviceLink.xcframework'

echo "Work Complete"