#!/bin/bash

# George Miller
# 05-17-2022
# If you don't have permission to run, try: chmod u+x Release.sh
# numbering follows this document: https://github.com/smartdevicelink/sdl_ios/wiki/Release-Steps
# The numbering does restart halfway because the document does.

# script start
echo "Zug Zug"
# echo "Starting SDL release script..."

# do some directory shenanigans to get us to the correct working directory.
# echo $PWD #debug
if [[ $PWD == *"scripts" ]]; then
    cd ..
fi

# 1 bump version in projectFile
echo
echo "Step 1: Update version in Project File"

# 1.1) get the current version and build from the podspec file
project_file=./SmartDeviceLink-iOS.xcodeproj/project.pbxproj
new_file=./SmartDeviceLink-iOS.xcodeproj/new.pbxproj
current_version_number=$(sed -n '/MARKETING_VERSION/{s/MARKETING_VERSION = //;s/;//;s/^[[:space:]]*//;p;q;}' $project_file)
current_build_number=$(sed -n '/CURRENT_PROJECT_VERSION/{s/CURRENT_PROJECT_VERSION = //;s/;//;s/^[[:space:]]*//;p;q;}' $project_file)
echo "Current Version "$current_version_number
echo "Current Build "$current_build_number

# 1.2) prompt user for new version
echo "Enter the new version number (semantic versioning x.x.x format) or blank to skip: "
read new_version_number

# 1.3) if not blank, or not the same
if [ -z $new_version_number ]; then
    echo "No version number entered. Skipping..."
else
    if [ $current_version_number != $new_version_number ]; then
        echo "Changed Version Number"
        # 1.4) swap new version in to file
        sed '/MARKETING_VERSION/{s/'$current_version_number'/'$new_version_number'/;}' $project_file > $new_file
        mv -f $new_file $project_file
    else
        echo "No project file change needed for version"
    fi
fi

# in the event that the build number somehow is not what it shoudl be, we have code to fix it.
#echo "New Build?"
#read new_build_number
# per review, the new build number will always be 1
new_build_number=1
if [ -z $new_build_number ]; then
    echo "No project file change needed for build number"
else
    if [ $current_build_number != $new_build_number ]; then
        echo make the change
        # 1.4) swap new version in to file
        sed '/CURRENT_PROJECT_VERSION/{s/'$current_build_number'/'$new_build_number'/;}' $project_file > $new_file
        mv -f $new_file $project_file
    else
        echo "No project file change needed for build number"
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
#echo "New Version?"
#read new_version
# per review, the new version should be the same as above, but we should check with the user.
echo "Enter the new version number for podfile (semantic versioning x.x.x format) or blank to set to match project file ("$new_version_number"): "
read new_version

# 2.3) If blank, use new version number from above.  If new version is different from current, change it.
if [ -z $new_version ]; then
    new_version=$new_version_number
fi
if [ $CurrentVersion != $new_version ]; then
    echo make the change
    # 2.4) swap new version in to file
    sed '/s.version/{s/'$CurrentVersion'/'$new_version'/;}' $PodSpecFile > $PodSpecNewFile
    mv -f $PodSpecNewFile $PodSpecFile
fi


# 3 update RPC versions
# SDLGlobals.h
# TODO

# 3 update protocol versions
# SDLGlobals.h
# TODO

# 4 update to newest bson
# git submodule ... commands
# TODO

# Update Package.swift and CocoaPods dependency files to point to latest if necessary.

# 5 update changelog
# TODO - prompt user to make changes to this file:
# Changelog.md

# 6 Install Jazzy
# TODO - we may want to check if Jazzy is already installed, and only run this if not.
echo "6 Install Jazzy"
#sudo gem install jazzy

# 6 generate documentation
echo "6 generate documentation"
# TODO - prompt user to ask if they want to do this.
# bash generate-documentation.sh
# TODO - before bringing code over, evaluate what code does and make sure it will work here.  That code already does the cd ..



# 7 ensure RPC_SPEC has released to master
# TODO - prompt user to do this.
# maybe provide links to assist?

# 7 update the submodule to point to new release
# TODO - prompt user to do this and wait for confirmation


# TODO - prompt the user for this.
# and every step of this process, the user needs complete control.
# that means we tell them what we want to do, ask them if they want us to do it, report the results, and gracefully handle exits.

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
# TODO - Zip the .xcframework and name it based on the naming scheme in the releases. Then delete the old intermediate files.

# 5 add docset to release (docs/docsets/)
# ?

# 6 rename docset similar to old releases
# ?

# 6 rename framework similar to old releases
# ?

# script end
echo "Work Complete"
# echo "Release complete. Time to party 🍾"