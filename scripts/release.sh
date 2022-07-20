#!/bin/bash

# George Miller
# 05-17-2022
# If you do not have permission to run, try: chmod u+x release.sh

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

# Script start
echo 
echo "Starting SDL release script..."

# If we are running from the scripts directory, we want to pop back to the project root to do everything.
if [[ $PWD == *"scripts" ]]; then
    cd ..
fi
# If, for some reason, we are not now in the correct working directory, exit
if [[ $PWD != *"sdl_ios" ]]; then
    echo "Please run this from the sdl_ios project root or the sdl_ios/scripts directory"
    exit 0
fi

# Setup branch variables
develop_branch="develop"
main_branch="master"



# Checkout develop - so we can update versions.
# We need to checkout the branch before we start modifying files.
current_branch=$(git branch --show-current)
if [ $current_branch == $develop_branch ]; then
    echo
    echo "$develop_branch is already checked out."
else
    echo
    echo "Checkout of $develop_branch is required for some steps"
    prompt_user "Would you like to automatically checkout $develop_branch"
    if [[ $? == 1 ]]; then

        # Stash any local changes to avoid errors during checkout
        changes=$(git diff-files)
        if [ ! -z "$changes" ]; then   
            #git status
            echo "There are unstaged changes in these files"
            echo $changes
            prompt_user "Would you like to stash these local changes before checkout of $develop_branch"
            if [[ $? == 1 ]]; then
                # Stash local changes to prevent issues with checkout
                git stash
                echo "use \"git stash pop\" when this script is complete to restore your changes"
            else
                # Dump local changes to prevent issues with checkout
                git reset --hard
            fi
        fi
        
        # Do a fetch to make sure we are up to date.
        git fetch -ff
        
        # Now do the checkout
        git checkout $develop_branch
        
        # check if the checkout was successful
        current_branch=$(git branch --show-current)
        if [ $current_branch == $develop_branch ]; then
            develop_checked_out=1
        else
            echo "Automatic checkout has failed. Abort."
            exit 0
        fi
    fi
fi

echo
echo "Updating the version"

# Get the current version and build from the podspec file
project_file="./SmartDeviceLink-iOS.xcodeproj/project.pbxproj"
new_file="./SmartDeviceLink-iOS.xcodeproj/new.pbxproj"
current_version_number=$(sed -n '/MARKETING_VERSION/{s/MARKETING_VERSION = //;s/;//;s/^[[:space:]]*//;p;q;}' $project_file)
echo "Current Version: "$current_version_number

# Prompt user for new version
echo "Enter the new version number (semantic versioning x.x.x format) or blank to skip: "
read new_version_number

# If blank or the same, then skip. Otherwise change the version number
if [ -z $new_version_number ]; then
    echo "No version number entered. Skipping..."
    new_version_number=$current_version_number
else
    if [ $current_version_number != $new_version_number ]; then
        echo "Changing Version Number in $project_file"
        # Swap new version in to file
        sed '/MARKETING_VERSION/{s/'$current_version_number'/'$new_version_number'/;}' $project_file > $new_file
        mv -f $new_file $project_file
    else
        echo "No project file change needed for version"
    fi
fi

# Get the current version from the podspec file
pod_spec_file="SmartDeviceLink-iOS.podspec"
pod_spec_new_file="NewFile.podspec"
current_version=$(sed -n '/s.version/{s/s.version//;s/=//;s/[\"]//g;s/^[[:space:]]*//g;p;q;}' $pod_spec_file)

# Use new version number from above. If new version is different from current, change it.
if [ $current_version != $new_version_number ]; then
    echo "changing version in $pod_spec_file to $new_version_number"
    # Swap new version in to file
    sed '/s.version/{s/'$current_version'/'$new_version_number'/;}' $pod_spec_file > $pod_spec_new_file
    mv -f $pod_spec_new_file $pod_spec_file
fi

# Update RPC and protocol versions in /SmartDeviceLink/private/SDLGlobals.m
echo 
echo "Checking SDLGlobals.m for RPC and Protocol versions"
file="SmartDeviceLink/private/SDLGlobals.m"
current_rpc_version=$(sed -n '/SDLMaxProxyRPCVersion/{s/^.*@//;s/[\;]//;s/[\"]//g;p;q;}' $file)
current_protocol_version=$(sed -n '/SDLMaxProxyProtocolVersion/{s/^.*@//;s/[\;]//;s/[\"]//g;p;q;}' $file)
echo "Current RPC Version: "$current_rpc_version
echo "Current Protocol Version: "$current_protocol_version
echo "If these are not correct, please update versions in /SmartDeviceLink/private/SDLGlobals.m. Then press enter..."
read user_input

# Update to the newest BSON submodule. Update Package.swift and CocoaPods dependency files to point to latest if necessary.
# Extract version and link from Package.swift
package_file="Package.swift"
package_dependency_info="$(sed -n '/.package/{s/let package = Package(//;s/.package(//;s/)//;s/^[[:space:]]*//g;p;}' $package_file)"
if [ ! -z "$submodule_info" ]; then
    # Loop through the dependencies 
    while IFS= read -r dependency_record ;
    do
        # If the dependency_record in the dependancies is not empty (the first one usually is due to string interpretation of a list)
        if [ ! -z "$dependency_record" ]; then
            # Identify the fields of the record
            record_info="$(sed 's/,/\n/g' <<< $dependency_record)"
            record_name=$(sed -n '/name:/{s/name://g;s/^[[:space:]]*//g;s/"//g;p;}' <<< "$record_info")
            record_url=$(sed -n '/url:/{s/url://g;s/^[[:space:]]*//g;s/"//g;p;}' <<< "$record_info")
            record_version=$(sed -n '/from:/{s/from://g;s/^[[:space:]]*//g;s/"//g;p;}' <<< "$record_info")
            echo
            echo "Current version of $record_name: "$record_version
        fi
    done <<< "$submodule_info"
    echo
    echo "Please update the dependencies in Package.swift, SmartDeviceLink.podspec, and SmartDeviceLink-iOS.podspec appropriately, then press enter..."
    read user_input 
fi

# Update changelog
# TODO - we could insert a template into the changelog that includes the version the users have selected above.
echo 
echo "Please update CHANGELOG.md, then return here and press enter..."
read user_input
# TODO - check modified info before and after so we can detect if the user did update the file.

# Generate documentation
prompt_user "Would you like to automatically generate documentation with Jazzy"
if [[ $? == 1 ]]; then
    # Check if Jazzy is already installed, and if not then install jazzy
    if [ -z "$(mdfind -name 'Jazzy')" ]; then
        echo "Jazzy is not installed, attempting to install (may require your password)..."
        sudo gem install jazzy
    fi

    # This runs Jazzy to generate the documentation.
    echo "Running Jazzy to generate documentation..."
    # TODO - I do not know if this will work as intended.
    if [ $(uname -m) == "x86_64" ]; then
        jazzy --clean --objc --framework-root SmartDeviceLink --sdk iphonesimulator --umbrella-header SmartDeviceLink/public/SmartDeviceLink.h --theme theme --output docs
    else
        arch -x86_64 jazzy --clean --objc --framework-root SmartDeviceLink --sdk iphonesimulator --umbrella-header SmartDeviceLink/public/SmartDeviceLink.h --theme theme --output docs
    fi
fi

# Ensure that the RPC_SPEC has released to the master branch and update the submodule to point to the new release tag (or to the HEAD of master, if no release of the RPC_SPEC is occurring).
echo 
echo "Please check if there is a new release of the RPC_SPEC on https://www.github.com/smartdevicelink/rpc_spec"
echo "If there is, please update the rpc_spec submodule to point to the newest commit on the master branch. Press enter to continue..."
read user_input

# Git commands
# Check to make sure the correct branch is checked out.
current_branch=$(git branch --show-current)
if [ $current_branch == $develop_branch ]; then
    echo
    echo "$develop_branch has already been checked out for you."

    prompt_user "Would you like to walk through the git commands for this release"
    if [[ $? == 1 ]]; then
        
        prompt_user "Would you like to commit and push the changes made so far to the develop branch"
        if [[ $? == 1 ]]; then
            # Add, commit, and push changes to develop
            git add -A
            git commit -m "Update for release $new_version_number"
            git push --set-upstream origin $develop_branch
        else
            echo "Aborting script!"
            exit 0
        fi


        # Merge release to master (update master from)
        prompt_user "Would you like to merge this release to master? (This will not push to master)"
        if [[ $? == 1 ]]; then
            # Checkout master
            git checkout $main_branch

            # Merge develop with master.
            # This updates the checked out master with the contents of develop
            git merge $develop_branch $main_branch

            echo "Please check that everything is correct. "
        
            # Tag it
            prompt_user "Would you like to tag this release with $new_version_number? (This will not push the tag)"
            if [[ $? == 1 ]]; then
                git tag $new_version_number
                # git push --set-upstream origin $main_branch
            fi
            

            echo "If these changes are correct, please commit them manually and then push them to master..."
            read user_input
            # TODO - here are the commands if we decide to automate this.
            # git commit -m "commit message here "
            # git push --set-upstream origin $main_branch

        else
            echo "Aborting script!"
            exit 0
        fi

        # Merge master back to develop
        prompt_user "Would you like to merge master back into develop (This will not push the branch)"
        if [[ $? == 1 ]]; then
            git checkout $develop_branch
            git merge $main_branch $develop_branch
        else
            echo "Aborting script!"
            exit 0
        fi
    fi

else
    echo "You do not have $develop_branch currently checked out."
fi

# TODO - can we provide templates for the release based on the changelog?
# TODO - can we open directories for drag and drop to the release?
# Create new release for tag
prompt_user "Would you like to open to the Github releases page to create a release"
if [[ $? == 1 ]]; then
    open "https://github.com/smartdevicelink/sdl_ios/releases"
fi

echo
# Push new release to primary and secondary cocoapod using command line:
prompt_user "Would you like to push the release to CocoaPods"
if [[ $? == 1 ]]; then
    pod trunk push SmartDeviceLink.podspec --allow-warnings
    pod trunk push SmartDeviceLink-iOS.podspec --allow-warnings
fi

prompt_user "Would you like to create a binary xcframework for adding to a Github release"
if [[ $? == 1 ]]; then
    # Create framework
    # We pass in the version so that the framework script does not need to ask
    # Give the user permissions to the framework script, then run the script.
    chmod u+x ./scripts/create_framework.sh
    if [ $(uname -m) == "x86_64" ]; then
        ./scripts/create_framework.sh $new_version_number
    else
        arch -x86_64 /bin/bash ./scripts/create_framework.sh $new_version_number
    fi
    
    echo 
    zip_file_name="SmartDeviceLink-$new_version_number.xcframework.zip"
    echo "Please add the framework at $zip_file_name to the Github release, then press enter..."
    read user_input
fi

# Rename the docset and pack it
prompt_user "Would you like to create the documentation docset for adding to a Github release"
if [[ $? == 1 ]]; then
    docset_directory="docs/docsets/"
    docset_tar_file_name="SmartDeviceLink-$new_version_number-docset.tgz"
    tar -czf $docset_tar_file_name $docset_directory

    echo 
    echo "Please add the docset at $docset_tar_file_name to the Github release, then press enter..."
    read user_input
fi
echo
echo "Release complete."