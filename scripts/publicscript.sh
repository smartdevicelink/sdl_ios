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

# Cd into the correct project directory
cd $project_directory

# Pick out the lines that have "Public" in them, and filters everything down to get the fileref
public_fileref_list=$(sed -n '/Public/{s/^.*fileRef//;s/^[[:space:]]*//;s/\/.*//;s/=//;p;}' $project_file)

# Loop through list of fileref and use sed on the project file to find the file path
public_filepaths=()
#other_filepaths=()

for public_fileref in $public_fileref_list
do
    # Pick out the lines with the file reference
    publicref_lines="$(sed -n "/$public_fileref/{p;}" $project_file)"
    # Trim everything before "path", then eliminate "=", " ", and quotes
    publicref_path=$(sed -n '/path/{s/^.*path//;s/=//;s/\"//g;s/^[[:space:]]*//g;p;}' <<< "$publicref_lines")
    # Eliminate everything after the ";"
    publicref_path=$(sed -n 's/\;.*//p;' <<< "$publicref_path")
    # All of these have the attribute "public"
    public_filepaths+=$publicref_path
    
    # Identify lines that do not have "public" in the path
    #if [[ "$publicref_path" != *"public"* ]]; then
    #    echo $publicref_path
    #    other_filepaths+=$publicref_path
    #fi
    #echo $publicref_path

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





