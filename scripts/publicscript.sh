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
# Clarrification: If, for example, you change a headers target membership from "public" to "private" in xcode, it will change the project file but not move the physical header file.
# so this script should identify these anomalies and repair them by moving the header file, and any associated code (.m file) into the correct directory.
# We are not responsible for changign the project file.  let xcode do that.
# if the anomaly is a file outside of the project target folder, don't worry about it.
# to test, you can go into xcode and just change the target membership of a file, then run the script and see that the file was identified and moved.
# use Fork to undo changes as needed.

#TODO - rename this script


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



project_file="SmartDeviceLink-iOS.xcodeproj/project.pbxproj"
target_path="SmartDeviceLink/"


# Make sure we are in the correct directory.
# If we are running from the scripts directory, we want to pop back to the project root to do everything.
if [[ $PWD == *"scripts" ]]; then
    cd ..
fi
# If, for some reason, we are not now in the correct working directory, exit.
if [[ $PWD != *"sdl_ios" ]]; then
    echo "Please run this from the sdl_ios project root or the sdl_ios/scripts directory"
    exit 0
fi


# Find the lines with "path".
path_lines=$(sed -n '/path/{s/[[:space:]]*//;s/\/\*.*\*\///g;s/{.*path//;p;}' $project_file)
# Filter to get only the lines with the header_filepath and fileref.
header_files=$(sed -n '/\.h/{s/[[:space:]]*//g;s/\"//g;s/\;.*//g;s/==/=/;p;}' <<< "$path_lines")

for line in $header_files
do
    # Pick out the fileref and the header_filepath.
    fileref=$(sed -n 's/=.*//;p;' <<< $line)
    header_filepath=$(sed -n 's/.*=//;p;' <<< $line)
    
    # Use the fileref to get the attributes.
    attributes=$(sed -n '/fileRef[[:space:]]*=[[:space:]]*'$fileref'/{s/.*fileRef[[:space:]]*=[[:space:]]*'$fileref'//;s/\/\*.*\*\///g;p;};' $project_file)
    
    # Determine public or private.
    if [[ $attributes == *"Public"* ]]; then
        header_type="public"
        header_opp="private"
    else
        header_type="private"
        header_opp="public"
    fi
    
    # Only look at entries where the attributes line is not empty.
    if [ ! -z "$attributes" ]; then
        # Find the real location of the file.
        file_found_location=$(find "$target_path" -name "$(basename "$header_filepath")" -maxdepth 2)
        
        # If file is found.
        if [ ! -z "$file_found_location" ]; then
            
            # Test to see if the file is where it should be.
            if [[ ! $file_found_location == *"/$header_type/"* ]]; then
                
                # The file is not where it should be: Alert the user.
                echo "ALERT"
                echo "Fileref: "$fileref
                echo "line: "$line
                echo "Attributes: "$attributes
                echo "Path from Project File: "$header_filepath
                echo "Type: "$header_type
                echo "file found Location: "$file_found_location
                
                # Move the file to the correct destination
                echo "Moving file to correct destination"
                destiny=$target_path$header_type"/"
                echo "Destiny: "$destiny
                mv -f $file_found_location $destiny
                echo

                # Fix path in the project file.
                sed '/'$fileref'/{s/'$header_opp'/'$header_type'/;}' $project_file > $project_file"2"
                mv -f $project_file"2" $project_file

                # Identify associated code.
                codefile=$(sed -n 's/\.h/\.m/p' <<< "$header_filepath")
                echo "code: "$codefile
                codefile_basename=$(basename "$codefile")
                code_file_found_location=$(find "$target_path" -name "$codefile_basename" -maxdepth 2)
                echo "code loc: "$code_file_found_location
                if [ ! -z "$code_file_found_location" ]; then
                    # Move associated code
                    mv -f $code_file_found_location $destiny

                    # Fix path in the project file.
                    sed '/'$codefile_basename'/{s/'$header_opp'/'$header_type'/;}' $project_file > $project_file"2"
                    mv -f $project_file"2" $project_file
                fi

                #TODO - do we need to change the attributes of the .m line to match the .h?
            fi
        fi
    fi
done

