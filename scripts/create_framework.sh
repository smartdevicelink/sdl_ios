#!/bin/bash

# George Miller
# 06-07-2022
# If you do not have permission to run, try: chmod u+x create_framework.sh


# A utility function for prompting the user Y/N
# This takes in a string prompt for the input
# This returns 1 for yes/true or 0 for no/false
prompt_user() {
    user_input="g"
    echo
    echo $1" (Y/N)?"
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

# 1 Make sure we are in the correct directory
# If we are running from the scripts directory, we want to pop back to the project root to do everything.
if [[ $PWD == *"scripts" ]]; then
    cd ..
fi
# If, for some reason, we are not now in the correct working directory, exit
if [[ $PWD != *"sdl_ios" ]]; then
    echo "Please run this from the sdl_ios project root or the sdl_ios/scripts directory"
    exit 0
fi


# If there is no command line ask for a version number
if [ -z $1  ]; then
    # Get the version number
    # At this point the version in the project file should be correct, so use it.
    project_file="./SmartDeviceLink-iOS.xcodeproj/project.pbxproj"
    current_version_number=$(sed -n '/MARKETING_VERSION/{s/MARKETING_VERSION = //;s/;//;s/^[[:space:]]*//;p;q;}' $project_file)
    if [ -z $current_version_number ]; then current_version_number="1.0.0"; fi
    echo "Current Version: "$current_version_number

    # TODO - we can streamline this by trusting the project file to always have the correct version (bail out if project file missing)
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
else
    new_version_number=$1
fi
# Add a binary xcframework archive for manual installation with the following commands
echo
echo "Creating a binary xcframework for manual installation"
# This builds the framework
xcodebuild archive -project 'SmartDeviceLink-iOS.xcodeproj/' -scheme 'SmartDeviceLink' -configuration Release -destination 'generic/platform=iOS' -archivePath './SmartDeviceLink-Device.xcarchive' SKIP_INSTALL=NO
xcodebuild archive -project 'SmartDeviceLink-iOS.xcodeproj/' -scheme 'SmartDeviceLink' -configuration Release -destination 'generic/platform=iOS Simulator' -archivePath './SmartDeviceLink-Simulator.xcarchive' SKIP_INSTALL=NO
xcodebuild -create-xcframework -framework './SmartDeviceLink-Device.xcarchive/Products/Library/Frameworks/SmartDeviceLink.framework/' -framework './SmartDeviceLink-Simulator.xcarchive/Products/Library/Frameworks/SmartDeviceLink.framework/' -output './SmartDeviceLink.xcframework'

# TODO - is there a way we can test that the build was successful.

folder="SmartDeviceLink.xcframework"
zip_file_name="SmartDeviceLink-$new_version_number.xcframework.zip"
# Kill the old zip if present. Useful for re-running the script
if [ -f $zip_file_name ]; then rm $zip_file_name; fi
# Verify folder exists before acting on it.
if [ -d "$folder" ]; then 
    zip $zip_file_name $folder"/*"
    # Check to see if the zip exists, and then remove old files.
    #if [ -f "$zip_file_name" ]; then rm -r $folder; fi
fi

# Cleanup artifacts
folder="SmartDeviceLink-Device.xcarchive"
if [ -d "$folder" ]; then rm -r $folder; fi

folder="SmartDeviceLink-Simulator.xcarchive"
if [ -d "$folder" ]; then rm -r $folder; fi

echo
echo "The xcframework zip file was created at $zip_file_name."