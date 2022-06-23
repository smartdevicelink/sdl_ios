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
project_header=$target_path"public/SmartDeviceLink.h"


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
        public_file_list+=$header_filepath
    else
        header_type="private"
    fi
    

    # Only look at entries where the attributes line is not empty.
    if [ ! -z "$attributes" ]; then
        # Find the real location of the file.
        file_found_location=$(find "$target_path" -name "$(basename "$header_filepath")" -maxdepth 2)
        
        # If file is found.
        if [ ! -z "$file_found_location" ]; then
            
            # Test to see if the file is where it should be. (Does the path contain the correct folder)
            if [[ ! $file_found_location == *"/$header_type/"* ]]; then

                # add the file to the list of files that are in the wrong location.
                broken_file_list+=$header_filepath"=="$header_type

            fi
        fi
    fi
done


# If the file list is not empty.
if [ ! -z "$broken_file_list" ]; then
    
    # List the files found for the user.
    for header_file in $broken_file_list
    do
        echo $header_file
    done
    
    # Prompt the user to move the files.
    prompt_user "These files were found to be out of place.  Would you like to move them"
    if [[ $? == 1 ]]; then
        for header_file in $broken_file_list
        do
            echo $header_file
            header_filepath="${header_file%%==*}"
            header_type="${header_file##*==}"
            #echo $header_filepath"  "$header_type

            # Figure otu where the file should be located
            destiny=$target_path$header_type"/"
        
            # Move the file to the correct destination
            #mv -f $file_found_location $destiny
            echo "File "$header_filepath" moved to "$destiny"."
            
            # Figure out the opposite of the type
            if [[ $header_type == "public" ]]; then
                header_opp="private"
            else
                header_opp="public"
            fi

            # Fix path in the project file.
            # Output to a second file, then overwrite the first with the second.
            # This is done because sed does not like writing to the file it is currently reading.
            #sed '/'$fileref'/{s/'$header_opp'/'$header_type'/;}' $project_file > $project_file"2"
            #mv -f $project_file"2" $project_file

            # Identify associated code.
            code_file=$(sed -n 's/\.h/\.m/p' <<< "$header_filepath")
            
            code_file_basename=$(basename "$code_file")
            code_file_found_location=$(find "$target_path" -name "$code_file_basename" -maxdepth 2)
            if [ ! -z "$code_file_found_location" ]; then
                # Move associated code file.
                #mv -f $code_file_found_location $destiny
                echo "File "$code_file" moved to "$destiny"."

                # Fix path in the project file.
                # Output to a second file, then overwrite the first with the second.
                # This is done because sed does not like writing to the file it is currently reading.
                #sed '/'$code_file_basename'/{s/'$header_opp'/'$header_type'/;}' $project_file > $project_file"2"
                #mv -f $project_file"2" $project_file
            fi
        done
    fi

else
    echo "file list empty"
fi

echo

#then do a separate loop through of public header files and make sure they are all referenced in the project header
#prompt user to add an entry

# If the file list is not empty.
if [ ! -z "$public_file_list" ]; then
    
    for header_file in $public_file_list
    do
        echo $header_file
        file_basename=$(basename "$header_file")

        # Check to see if the file is in the project header
        # Use sed to find the line
        found=$(sed -n '/'$file_basename'/{p;}' $project_header)
        if [ ! -z "$found" ]; then
            echo $file_basename" not found in "$project_header

            #TODO - prompt use to add entry
            # Add entry to Project Header

        else
            echo $file_basename
        fi
    done
fi