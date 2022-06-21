#!/bin/bash

# George miller
# 6-10-2022
# If you do not have permission to run, try: chmod u+x publicscript.sh
#
# The purpose of this script is to update the location of header files in an xcode project by their public attribute.
# It goes backwards, finding the paths to the header files first, then backtracking to find the attributes for file.
# This was more reliable because files marked private/project have a path, but do not always have attributes.
# This script also identifies and moves any associated code files for the headers

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


# Find the lines in the project file with "path".
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
    # Save off the opposite for the file path change later.
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
                #echo "Header path from Project File: "$header_filepath
                #echo "file found Location: "$file_found_location
                
                # Move the file to the correct destination
                destiny=$target_path$header_type"/"
                mv -f $file_found_location $destiny
                
                # Fix path in the project file.
                # TODO - this works by swapping "public" and "private".  Sed was not workign with full paths.  There should be a better way.
                sed '/'$fileref'/{s/'$header_opp'/'$header_type'/;}' $project_file > $project_file"2"
                mv -f $project_file"2" $project_file

                # Identify associated code.
                code_file=$(sed -n 's/\.h/\.m/p' <<< "$header_filepath")
                #echo "code: "$code_file

                code_file_basename=$(basename "$code_file")
                code_file_found_location=$(find "$target_path" -name "$code_file_basename" -maxdepth 2)
                if [ ! -z "$code_file_found_location" ]; then
                    # Move associated code file.
                    mv -f $code_file_found_location $destiny

                    # Fix path in the project file.
                    # TODO - this works by swapping "public" and "private".  Sed was not workign with full paths.  There should be a better way.
                    sed '/'$code_file_basename'/{s/'$header_opp'/'$header_type'/;}' $project_file > $project_file"2"
                    mv -f $project_file"2" $project_file
                fi

                #TODO - do we need to change the attributes of the .m line to match the .h?
            fi
        fi
    fi
done

