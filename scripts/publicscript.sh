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
public_dir=$path_pre"/public"
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
    
    # Most of the paths in the project file do not have the full path from the project root.
    # So we prepend the missing part if needed
    test_path=$publicref_path
    if [[ "$publicref_path" != *$path_pre* ]]; then
        
        # add the public folder if necessary
        if [[ "$publicref_path" != *public* ]]; then
            test_path="public/"$test_path
        fi
        test_path=$path_pre$test_path
    fi
    
    # this is excessively verbose
    #echo
    #echo "file "$publicref_path
    #echo "should be located at "$test_path

    # Test to see if the file is in the public folder (does the file exist at the specified path)
    if [ ! -f $test_path ]; then 
        echo "ALERT"

        # If we did not find the file, lets see where it actually is.
        file_found_location=$(find . -name "$publicref_path" -maxdepth 2)
        if [ ! -z "$file_found_location" ]; then
            echo "File found: "$file_found_location

            # Move the file to the correct destination
            echo "Copying file to correct destination"
            cp -f $file_found_location $public_dir
            # mv -f $file_found_location $test_path #DEBUG - copy is safer for testing.

        else
            echo "File could not be found in $PWD"
        fi
    fi
done





