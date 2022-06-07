#!/bin/bash

# the purpose here is to remove some files that may be created during testing of the framework script

#process is that for each file, we check if it exists, and if it does, we nuke it

# If we are running from the scripts directory, we want to pop back to the project root to do everything.
if [[ $PWD == *"scripts" ]]; then
    cd ..
fi
# If, for some reason, we are not now in the correct working directory, exit
if [[ $PWD != *"sdl_ios" ]]; then
    echo "Please run this from the sdl_ios project root or the sdl_ios/scripts directory"
    exit 0
fi

# these show in finder as files, but show in Fork as folders
# bash aparently also sees them as folders
#SmartDeviceLink-Device.xcarchive
#SmartDeviceLink-Simulator.xcarchive

#folders
folder="SmartDeviceLink-Device.xcarchive"
if [ -d "$folder" ]; then rm -r $folder; fi

folder="SmartDeviceLink-Simulator.xcarchive"
if [ -d "$folder" ]; then rm -r $folder; fi

# this one shouldn't exist, but just in case
folder="SmartDeviceLink.xcframework"
if [ -d "$folder" ]; then rm -r $folder; fi


# this is a file, but finder can open it like a folder
# also, the version in the middle changes.  SO we'll use wildcard chars
#SmartDeviceLink-7.4.2.xcframework.zip

#files
file_name="SmartDeviceLink-?.?.?.xcframework.zip"
if [ -f $file_name ]; then rm $file_name; fi
