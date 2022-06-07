#!/bin/bash

# George Miller
# 06-03-2022
# If you don't have permission to run, try: chmod u+x create_framework.sh

# a utility function for prompting the user Y/N
# takes in a string promt for the input
# returns 1 for yes/true or 0 for no/false
prompt_user() {
    user_input="g"
    echo
    echo $1" (Y/N)"
    read user_input
    while [[ ! $user_input == [YyNn] ]]; do
        echo $1" (Y/N)?"
        read user_input
    done
    if [[ ! $user_input == [Nn] ]]; then
        return 1
    else
        return 0
    fi
}

# 1 make sure we are in teh correct directory
# If we are running from the scripts directory, we want to pop back to the project root to do everything.
if [[ $PWD == *"scripts" ]]; then
    cd ..
fi
# If, for some reason, we are not now in the correct working directory, exit
if [[ $PWD != *"sdl_ios" ]]; then
    echo "Please run this from the sdl_ios project root or the sdl_ios/scripts directory"
    exit 0
fi

# 2 get the verison number
# get the verison number
# at this point the version in the project file should be correct, so use it.
project_file="./SmartDeviceLink-iOS.xcodeproj/project.pbxproj"
current_version_number=$(sed -n '/MARKETING_VERSION/{s/MARKETING_VERSION = //;s/;//;s/^[[:space:]]*//;p;q;}' $project_file)
if [ -z $current_version_number ]; then current_version_number="1.0.0"; fi
echo "Current Version: "$current_version_number

# todo - we can streamline this by trusting the project file to always have the correct version (bail out if project file missing)
prompt_user "Is this version correct"
if [[ $? == 0 ]]; then
    # Prompt user for new version
    echo "Enter the new version number (semantic versioning x.x.x format) or blank to skip: "
    read new_version_number

    # If blank or the same, then skip. Otherwise change the version number
    if [ -z $new_version_number ]; then
        echo "No version number entered. Skipping..."
        new_version_number=$current_version_number
    fi
fi

# 3 Add a binary xcframework archive for manual installation with the following commands
echo
echo "Creating a binary xcframework for manual installation"
# this builds the framework
xcodebuild archive -project 'SmartDeviceLink-iOS.xcodeproj/' -scheme 'SmartDeviceLink' -configuration Release -destination 'generic/platform=iOS' -archivePath './SmartDeviceLink-Device.xcarchive' SKIP_INSTALL=NO
xcodebuild archive -project 'SmartDeviceLink-iOS.xcodeproj/' -scheme 'SmartDeviceLink' -configuration Release -destination 'generic/platform=iOS Simulator' -archivePath './SmartDeviceLink-Simulator.xcarchive' SKIP_INSTALL=NO
xcodebuild -create-xcframework -framework './SmartDeviceLink-Device.xcarchive/Products/Library/Frameworks/SmartDeviceLink.framework/' -framework './SmartDeviceLink-Simulator.xcarchive/Products/Library/Frameworks/SmartDeviceLink.framework/' -output './SmartDeviceLink.xcframework'

# todo - is there a way we can test that the build was successful.

folder="SmartDeviceLink.xcframework"
zip_file_name="SmartDeviceLink-$new_version_number.xcframework.zip"
read user_input
# kill the old zip if present.  Useful for re-running the script
if [ -f $zip_file_name ]; then rm $zip_file_name; fi
read user_input
# verify file exists before acting on it.
if [ -d "$folder" ]; then zip $zip_file_name $folder; fi
read user_input
# Check to see if the zip exists, and then remove old files.
if [ -f "$zip_file_name" ]; then rm -r $folder; fi
read user_input

echo
echo "The xcframework zip file was created at $zip_file_name. Please add it to the Github Release, then press enter..."
read user_input

# 14 Rename the docset and pack it
prompt_user "Would you like to create a the docset"
if [[ $? == 1 ]]; then
    # SmartDeviceLink-$new_version_number-docset.tgz
    docset_directory="docs/docsets/"
    docset_tar_file_name="SmartDeviceLink-$new_version_number-docset.tgz"
    tar -czf $docset_tar_file_name $docset_directory

    echo 
    echo "Please add the docset at $docset_tar_file_name to the Github release, then press enter..."
    read user_input
    #todo - phase 4 - adding the docset to the release shoudl also be automatic
fi