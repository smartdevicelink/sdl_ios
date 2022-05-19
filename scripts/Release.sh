#!/bin/bash

# George Miller
# 05-17-2022
# If you don't have permission to run, try: chmod u+x Release.sh
# numbering follows this document: https://github.com/smartdevicelink/sdl_ios/wiki/Release-Steps
# The numbering does restart halfway because the document does.

# script start
echo "Zug Zug"

# do some directory shenanigans to get us to the correct working directory.
echo $PWD
if [[ $PWD == *"scripts" ]]; then
    cd ..
fi

# 1 bump version in projectFile
echo
echo "Step 1: Update version in Project File"

# 1.1) get the current version and build from the podspec file
ProjFile=./SmartDeviceLink-iOS.xcodeproj/project.pbxproj
NewFile=./SmartDeviceLink-iOS.xcodeproj/new.pbxproj
Current_version_number=$(sed -n '/MARKETING_VERSION/{s/MARKETING_VERSION = //;s/;//;s/^[[:space:]]*//;p;q;}' $ProjFile)
Current_build_number=$(sed -n '/CURRENT_PROJECT_VERSION/{s/CURRENT_PROJECT_VERSION = //;s/;//;s/^[[:space:]]*//;p;q;}' $ProjFile)
echo "Current Version "$Current_version_number
echo "Current Build "$Current_build_number

# 1.2) prompt user for new version
echo "Enter the new version number (semantic versioning x.x.x format) or blank to skip: "
read NewVersionNumber
echo "New Build?"
read NewBuildNumber

# 1.3) if not blank, or not the same
if [ -z $NewVersionNumber ]; then
    echo "No version number entered. Skipping..."
else
    if [ $Current_version_number != $NewVersionNumber ]; then
        echo "Changed Version Number"
        # 1.4) swap new version in to file
        sed '/MARKETING_VERSION/{s/'$Current_version_number'/'$NewVersionNumber'/;}' $ProjFile > $NewFile
        mv -f $NewFile $ProjFile
    else
        echo No file change needed for version
    fi
fi
if [ -z $NewBuildNumber ]; then
    echo No file change needed for build
else
    if [ $Current_build_number != $NewBuildNumber ]; then
        echo make the change
        # 1.4) swap new version in to file
        sed '/CURRENT_PROJECT_VERSION/{s/'$Current_build_number'/'$NewBuildNumber'/;}' $ProjFile > $NewFile
        mv -f $NewFile $ProjFile
    else
        echo No file change needed for build
    fi
fi


# 2 update version in podspec
# SmartDeviceLink-iOS.podspec
echo
echo "Step 2: Update version in podspec File"

# 2.1) get the current version from the podspec file
PodSpecFile=SmartDeviceLink-iOS.podspec
PodSpecNewFile=NewFile.podspec
CurrentVersion=$(sed -n '/s.version/{s/s.version//;s/=//;s/[\"]//g;s/^[[:space:]]*//g;p;q;}' $PodSpecFile)
echo "Current Version="$CurrentVersion

# 2.2) prompt user for new version
echo "New Version?"
read NewVersion

# 2.3) if not blank, or not the same
if [ -z $NewVersion ]; then
    echo No file change needed
else
    if [ $CurrentVersion != $NewVersion ]; then
        echo make the change
        # 2.4) swap new version in to file
        sed '/s.version/{s/'$CurrentVersion'/'$NewVersion'/;}' $PodSpecFile > $PodSpecNewFile
        mv -f $PodSpecNewFile $PodSpecFile
    else
        echo No file change needed for version
    fi
fi


# 3 update RPC versions
# file?

# 3 update protocol versions
# file?

# 4 update to newest bson
# file?

# 4 update package.swift
# ?

# 4 update CocoaPods dependancy
# ?

# 5 update changelog
# ?

# 6 Install Jazzy
echo "6 Install Jazzy"
sudo gem install jazzy

# 6 generate documentation
echo "6 generate documentation"
#bash generate-documentation.sh


# 7 ensure RPC_SPEC has released to master

# 7 update the submodule to point to new release


# git commands
# 8 commit release to develop
# git checkout <branch>
# git add -A
# git commit -m <message here>
# git push --set-upstream origin <branchname>

# 8 merge release to master
# git merge <branch> <master>

# 8 tag it
# git tag <something>

# 8 merge master back to develop
# git merge <branch> <master>



# 1 Create new release for tag
# ?

# 1 add highlights of changes
# ?


# 2 push new release to primary cocoapod
echo "2 push new release to primary Cocoapod"
#pod trunk push SmartDeviceLink.podspec --allow-warnings

# 3 Push the new release to the secondary cocoapod using command line:
echo "3 Push the new release to the secondary cocoapod using command line:"
#pod trunk push SmartDeviceLink-iOS.podspec --allow-warnings.

# 4 add binary xcframework archive for manual installation
echo "Creating .xcframework for manual installation, to be added to the release."
# i
echo "4.i"
xcodebuild archive -project 'SmartDeviceLink-iOS.xcodeproj/' -scheme 'SmartDeviceLink' -configuration Release -destination 'generic/platform=iOS' -archivePath './SmartDeviceLink-Device.xcarchive' SKIP_INSTALL=NO

# ii
echo "4.ii"
xcodebuild archive -project 'SmartDeviceLink-iOS.xcodeproj/' -scheme 'SmartDeviceLink' -configuration Release -destination 'generic/platform=iOS Simulator' -archivePath './SmartDeviceLink-Simulator.xcarchive' SKIP_INSTALL=NO

# iii
echo "4.iii"
xcodebuild -create-xcframework -framework './SmartDeviceLink-Device.xcarchive/Products/Library/Frameworks/SmartDeviceLink.framework/' -framework './SmartDeviceLink-Simulator.xcarchive/Products/Library/Frameworks/SmartDeviceLink.framework/' -output './SmartDeviceLink.xcframework'

# iv Compress the .xcframework and add the it to the release.
echo "4.iv Compress the .xcframework and add the it to the release."
# SmartDeviceLink.xcframework

# 5 add docset to release (docs/docsets/)
# ?

# 6 rename docset similar to old releases
# ?

# 6 rename framework similar to old releases
# ?

# script end
echo "Work Complete"
