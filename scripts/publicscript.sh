#!/bin/bash

# George miller
# 6-10-2022
# If you do not have permission to run, try: chmod u+x publicscript.sh
#
# The purpose of this script is to update the file locations of certain files in an xcode project
# by their status as public or private.
# a Ruby script exists for the facebook project.  We want a more robust script, for SDL_IOS

# "Ensure that all files marked public in the project.pbxproj file are in
# the public folder and the same for non-public files (in the private folder). 
# Public files should also be referenced in SmartDeviceLink.h"


project_directory="../sdl_ios/"
project_file="SmartDeviceLink-iOS.xcodeproj/project.pbxproj"
path_pre="SmartDeviceLink/"
#public_dir=$path_pre"/public"
#private_dir=$path_pre"/private"


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

# Pick out the lines that have "Public" in them, and filters everything down to get the fileref
public_fileref_list=$(sed -n '/Public/{s/^.*fileRef//;s/^[[:space:]]*//;s/\/.*//;s/=//;p;}' $project_file)

# TODO - this loop is very slow compared to sed or cat.  Is there a faster way to do this?
for public_fileref in $public_fileref_list
do
    # Pick out the lines with the file reference
    publicref_lines="$(sed -n "/$public_fileref/{p;}" $project_file)"
    # Trim everything before "path", then trim "=", " ", and quotes
    publicref_path=$(sed -n '/path/{s/^.*path//;s/=//;s/\"//g;s/^[[:space:]]*//g;p;}' <<< "$publicref_lines")
    # Trim after the ";"
    publicref_path=$(sed -n 's/\;.*//p;' <<< "$publicref_path")
    
    # Test to see if the file is at that path
    # Some of the paths already have the pre on them
    test_path=$publicref_path
    if [[ "$publicref_path" != *$path_pre* ]]; then
        test_path=$path_pre$publicref_path
    fi
    if [ ! -f $test_path ]; then 
        echo $publicref_path
        echo $test_path
        echo "ALERT"
    fi
done





