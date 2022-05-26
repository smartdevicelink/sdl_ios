#!/bin/bash

# George Miller
# 05-17-2022
# If you don't have permission to run, try: chmod u+x Release.sh
# numbering follows this document: https://github.com/smartdevicelink/sdl_ios/wiki/Release-Steps
# The numbering does restart halfway because the document does.

# script start
echo 
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

# TODO - For Phase3, this is probably the correct place to checkout develop
# git checkout develop

# 1 bump version in projectFile
echo
echo "Step 1: Update version in Project File"

# 1.1) get the current version and build from the podspec file
project_file="./SmartDeviceLink-iOS.xcodeproj/project.pbxproj"
new_file="./SmartDeviceLink-iOS.xcodeproj/new.pbxproj"
current_version_number=$(sed -n '/MARKETING_VERSION/{s/MARKETING_VERSION = //;s/;//;s/^[[:space:]]*//;p;q;}' $project_file)
current_build_number=$(sed -n '/CURRENT_PROJECT_VERSION/{s/CURRENT_PROJECT_VERSION = //;s/;//;s/^[[:space:]]*//;p;q;}' $project_file)
echo "Current Version: "$current_version_number
echo "Current Build: "$current_build_number

# 1.2) prompt user for new version
echo "Enter the new version number (semantic versioning x.x.x format) or blank to skip: "
read new_version_number

# 1.3) if not blank, or not the same, skip, otherwise change the version number
if [ -z $new_version_number ]; then
    echo "No version number entered. Skipping..."
else
    if [ $current_version_number != $new_version_number ]; then
        echo "Changing Version Number in $project_file"
        # 1.4) swap new version in to file
        sed '/MARKETING_VERSION/{s/'$current_version_number'/'$new_version_number'/;}' $project_file > $new_file
        mv -f $new_file $project_file
    else
        echo "No project file change needed for version"
    fi
fi

# 2 update version in podspec
# SmartDeviceLink-iOS.podspec
echo
echo "Step 2: Update version in podspec File"

# 2.1) get the current version from the podspec file
pod_spec_file="SmartDeviceLink-iOS.podspec"
pod_spec_new_file="NewFile.podspec"
current_version=$(sed -n '/s.version/{s/s.version//;s/=//;s/[\"]//g;s/^[[:space:]]*//g;p;q;}' $pod_spec_file)
echo "Current Version: "$current_version

# 2.2) Use new version number from above.  If new version is different from current, change it.
if [ $current_version != $new_version_number ]; then
    echo "changing version in $pod_spec_file to $new_version_number"
    # 2.3) swap new version in to file
    sed '/s.version/{s/'$current_version'/'$new_version_number'/;}' $pod_spec_file > $pod_spec_new_file
    mv -f $pod_spec_new_file $pod_spec_file
fi

# 3 update RPC and protocol versions
# /SmartDeviceLink/private/SDLGlobals.m
# extract versions and prompt user to fix it if necessary.
echo 
echo "Step 3: Please update RPC version in /SmartDeviceLink/private/SDLGlobals.h"
file="SmartDeviceLink/private/SDLGlobals.m"
current_rpc_version=$(sed -n '/SDLMaxProxyProtocolVersion/{s/^.*@//;s/[\;]//;s/[\"]//g;p;q;}' $file)
current_protocol_version=$(sed -n '/SDLMaxProxyRPCVersion/{s/^.*@//;s/[\;]//;s/[\"]//g;p;q;}' $file)
echo "Current RPC Version: "$current_rpc_version
echo "Current Protocol Version: "$current_protocol_version
echo "Step 3: If these are not correct, please update protocol versions in /SmartDeviceLink/private/SDLGlobals.m"
read user_input


# 4 Update to the newest BSON submodule. Update Package.swift and CocoaPods dependency files to point to latest if necessary.
# extract version and link from Package.swift
dependency_file="Package.swift"
submodule_info=$(sed -n '/.package/{s/let package = Package(//;s/.package(//;s/)//;p;}' $dependency_file)
submodule_name=$(jq -n "{$submodule_info}" | jq -r .name)
submodule_url=$(jq -n "{$submodule_info}" | jq -r .url)
submodule_current_version=$(jq -n "{$submodule_info}" | jq -r .from)

# figure out latest version (visit link?)
submodule_latest_version=$(gh repo view $submodule_url --json latestRelease -q .latestRelease.tagName)

# compare versions
if [ $submodule_current_version != $submodule_latest_version ]; then
    echo
    echo "Current version of $submodule_name: "$submodule_current_version
    echo "Latest version of $submodule_name: "$submodule_latest_version
    echo "Please update the submodule $submodule_name before continuing with the release."
    echo
    echo "You must also edit the dependancy information in SmartDeviceLink-iOS.podspec"
    read user_input
fi

# 5 update changelog
# TODO - insert a template into the changelog that includes the version the users have selected above.
#echo "A template for this release has been inserted into the changelog.  Please update it."
echo 
echo "Please update Changelog.md, then return here and press enter."
read user_input
# Changelog.md

# 6 generate documentation
echo 
echo "Would you like to automatically generate documentation with Jazzy (Y/n)?"
read user_input
if [[ ! $user_input == [Nn] ]]; then    
    # 6 Install Jazzy
    # Check if Jazzy is already installed, and if not then install jazzy
    if [ -z "$(mdfind -name 'Jazzy')" ]; then
        echo "Jazzy is not installed, attempting to install (may require your password)..."
        sudo gem install jazzy
    fi

    # this runs Jazzy to generate the documentation
    echo "Running Jazzy to generate documentation..."
    jazzy --clean --objc --framework-root SmartDeviceLink --sdk iphonesimulator --umbrella-header SmartDeviceLink/public/SmartDeviceLink.h --theme theme --output docs
fi

# 7 Ensure that the RPC_SPEC has released to the master branch and update the submodule to point to the new release tag (or to the HEAD of master, if no release of the RPC_SPEC is occurring).
echo 
echo "The rpc spec site will be opened for you"
echo "https://github.com/smartdevicelink/rpc_spec"
echo "Please check if there is a new release of the RPC_SPEC to master."
echo "If there is, please update the rpc_spec submodule to point to the new master, then press enter."
read user_input
open "https://github.com/smartdevicelink/rpc_spec"
read user_input
#TODO - phase ? - can this be automated.  Check version.  Check version at site.

echo
echo "Please perform the following steps to push the release to master:"
# and every step of this process, the user needs complete control.
# that means we tell them what we want to do, ask them if they want us to do it, report the results, and gracefully handle exits.

# git commands
# 8 commit release to develop
echo "Would you like to commit these changes to the develop branch? Y/n"
read user_input
#if [[ ! $user_input == [Nn] ]]; then
#todo - phase 3 - run the commands automatically
echo "Please Commit and push the changes to develop"

# 8 merge release to master
echo "Would you like to merge this release to master? (This will not push to master) Y/n"
read user_input
#if [[ ! $user_input == [Nn] ]]; then
#todo - phase 3 - run the commands automatically
echo "Please push to master, then press enter"
read user_input

# 8 tag it
echo "Would you like to tag this release? (This will not push the tag) Y/n"
read user_input
#if [[ ! $user_input == [Nn] ]]; then
#todo - phase 3 - run the commands automatically

# 8 merge master back to develop
echo "Would you like to merge master back into develop? (This will not push the branch) Y/n"
# git merge develop <master>
read user_input
#if [[ ! $user_input == [Nn] ]]; then
#todo - phase 3 - run the commands automatically

echo
echo "Please perform the following steps"
# 1 Create new release for tag
echo "Would you like to go to the Github releases page to create a release? Y/n"
read user_input
if [[ ! $user_input == [Nn] ]]; then  
    open "https://github.com/smartdevicelink/sdl_ios/releases"

    # TODO - phase 3 - this can be automated with gh
    # https://cli.github.com/manual/gh_release_create
    # TODO - can we pull the list of changes from Changelog.md and automatically add those to the release (so we do not type the same things twice)
    # TODO - if/when we automate this, make sure to open the releases page so the user can review it.
fi



# 2 push new release to primary cocoapod
# 3 Push the new release to the secondary cocoapod using command line:
echo "Would you like to push the release to CocoaPods? Y/N"
read user_input
if [[ ! $user_input == [Nn] ]]; then  
    pod trunk push SmartDeviceLink.podspec --allow-warnings
    pod trunk push SmartDeviceLink-iOS.podspec --allow-warnings.
else
    # commands for manual
    echo "pod trunk push SmartDeviceLink.podspec --allow-warnings"
    echo "pod trunk push SmartDeviceLink-iOS.podspec --allow-warnings."
fi



# 4 Add a binary xcframework archive for manual installation with the following commands
echo
echo "Would you like to create a binary xcframework for manual installation? Y/N"
read user_input
if [[ ! $user_input == [Nn] ]]; then  
    xcodebuild archive -project 'SmartDeviceLink-iOS.xcodeproj/' -scheme 'SmartDeviceLink' -configuration Release -destination 'generic/platform=iOS' -archivePath './SmartDeviceLink-Device.xcarchive' SKIP_INSTALL=NO
    xcodebuild archive -project 'SmartDeviceLink-iOS.xcodeproj/' -scheme 'SmartDeviceLink' -configuration Release -destination 'generic/platform=iOS Simulator' -archivePath './SmartDeviceLink-Simulator.xcarchive' SKIP_INSTALL=NO
    xcodebuild -create-xcframework -framework './SmartDeviceLink-Device.xcarchive/Products/Library/Frameworks/SmartDeviceLink.framework/' -framework './SmartDeviceLink-Simulator.xcarchive/Products/Library/Frameworks/SmartDeviceLink.framework/' -output './SmartDeviceLink.xcframework'

    folder="SmartDeviceLink.xcframework"
    zip_file_name="SmartDeviceLink-$new_version_number.xcframework.zip"
    if [ -f $zip_file_name ]; then
        #kill the old zip if present.  Useful for re-running the script
        rm $zip_file_name 
    fi
    #verify file exists before acting on it.
    if [ -d "$folder" ]; then
        zip $zip_file_name $folder
    fi
    #Check to see if the zip exists, and then remove old files.
    if [ -f "$zip_file_name" ]; then
        rm -r $folder
    fi
fi

echo
echo "The xcframework zip file was created at $zip_file_name. Please add it to the Github Release, then press enter..."
read user_input
#TODO - phase 3 - automate adding to release

# Rename the docset and pack it
# SmartDeviceLink-$new_version_number-docset.tgz
docset_directory="docs/docsets/"
docset_tar_file_name="SmartDeviceLink-$new_version_number-docset.tgz"
tar -czf $docset_tar_file_name $docset_directory
echo 
echo "Please add the docset at $docset_tar_file_name to the Github release, then press enter..."
read user_input
# TODO - phase 3 - automate adding to release



echo
echo "Release complete."