#!/bin/bash

# George Miller
# 05-17-2022
# If you don't have permission to run, try: chmod u+x Release.sh
# numbering follows this document: https://github.com/smartdevicelink/sdl_ios/wiki/Release-Steps
# The numbering does restart halfway because the document does.

# script start
echo 
#echo "Zug Zug"
echo "Starting SDL release script..."

# If we are running from the scripts directory, we want to pop back to the project root to do everything.
if [[ $PWD == *"scripts" ]]; then
    cd ..
fi
# If, for soem reason, we are not now in the correct working directory, exit
if [[ $PWD != *"sdl_ios" ]]; then
    echo "Please run this from the sdl_ios project root or the sdl_ios/scripts directory"
    exit 0
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

# in the event that the build number somehow is not what it should be, we have code to fix it.
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
# /SmartDeviceLink/private/SDLGlobals.h
# TODO - extract version, prompt user to fix it if necessary.
echo "Step 3: Please update RPC version in /SmartDeviceLink/private/SDLGlobals.h"

# 3 update protocol versions
# /SmartDeviceLink/private/SDLGlobals.h
# TODO - extract version, prompt user to fix it if necessary.
echo "Step 3: Please update protocol versions in /SmartDeviceLink/private/SDLGlobals.h"

# 4 update to newest bson
# git submodule ... commands
# 4.1 Update Package.swift and CocoaPods dependency files to point to latest if necessary.
# TODO - what needs to be done for this?

# 5 update changelog
# IDEA - I should record the timestamp of the changelog, and then check after the user returns to see that they did touch the file.
# IDEA - we could also insert a template into the changelog that includes the version the users have selected above.
echo 
echo "Please go update Changelog.md, then return here and press enter."
read user_input
# Changelog.md

# 6 generate documentation
echo "6 generate documentation"
echo "Would you like to automatically generate documentation with Jazzy (Y/n)?"
read user_input
if [[ ! $user_input == [Nn] ]]; then    
    # 6 Install Jazzy
    # Check if Jazzy is already installed, and if not then install jazzy
    echo "Check if Jazzy is already installed, and install if necessary (may require password)"
    if [ -z "$(mdfind -name 'Jazzy')" ]; then
        echo "6 Install Jazzy"
        sudo gem install jazzy
    fi

    # this runs Jazzy to generate the documentation
    echo "Run Jazzy to generate documentation"
    jazzy --clean --objc --framework-root SmartDeviceLink --sdk iphonesimulator --umbrella-header SmartDeviceLink/public/SmartDeviceLink.h --theme theme --output docs
#then
#    echo "not Jazzy..."
fi

# 7 ensure RPC_SPEC has released to master
echo "Step 7: ensure RPC_SPEC has released to master"
# TODO - cleanup wording
# IDEA - maybe provide links to assist?
echo "Please ensure RPC_SPEC has released to master and return here"
read user_input

# 7 update the submodule to point to new release
#echo "update the submodule to point to new release"
# TODO - cleanup wording
# IDEA - maybe provide links to assist?
echo "Please update the submodule to point to new release and return here"
read user_input


echo "Please perform the following steps"
# and every step of this process, the user needs complete control.
# that means we tell them what we want to do, ask them if they want us to do it, report the results, and gracefully handle exits.

# git commands
#todo - I don't like any of how this section is handled.
# 8 commit release to develop
echo "step 8: commit release to develop"
# git checkout <branch>
# git add -A
# git commit -m <message here>
# git push --set-upstream origin <branchname>

# 8 merge release to master
echo "8.1 merge release to master"
# git merge <branch> <master>

# 8 tag it
echo "8.2 tag the release"
# git tag <something>

# 8 merge master back to develop
echo "8.3 merge master back to develop"
# git merge <branch> <master>

# 1 Create new release for tag
echo "1.0 Create new release for tag"
# ?

# 1 add highlights of changes
echo "1.1 add highlights of changes"
# ?

# 2 push new release to primary cocoapod
echo "2 push new release to primary Cocoapod"
#pod trunk push SmartDeviceLink.podspec --allow-warnings

# 3 Push the new release to the secondary cocoapod using command line:
echo "3 Push the new release to the secondary cocoapod using command line:"
#pod trunk push SmartDeviceLink-iOS.podspec --allow-warnings.
read user_input

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