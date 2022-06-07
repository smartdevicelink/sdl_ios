#!/bin/bash

# George Miller
# 05-17-2022
# If you don't have permission to run, try: chmod u+x release.sh
# numbering follows this document: https://github.com/smartdevicelink/sdl_ios/wiki/Release-Steps
# The numbering does restart halfway because the document does.

# a utility function for prompting the user Y/N
# takes in a string promt for the input
# returns 1 for yes/true or 0 for no/false
prompt_user() {
    user_input="g"
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

# TODO - phase 4 - github cli "gh" needs to be installed before we can use those commands.
#  gh commands are commented for now.


# script start
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

# setup branch variables
develop_branch="develop"
main_branch="master"

# Checkout develop
git checkout $develop_branch

# 1 bump version in projectFile
echo
echo "Step 1: Update version in Project File"

# 1.1) get the current version and build from the podspec file
project_file="./SmartDeviceLink-iOS.xcodeproj/project.pbxproj"
new_file="./SmartDeviceLink-iOS.xcodeproj/new.pbxproj"
current_version_number=$(sed -n '/MARKETING_VERSION/{s/MARKETING_VERSION = //;s/;//;s/^[[:space:]]*//;p;q;}' $project_file)
current_build_number=$(sed -n '/CURRENT_PROJECT_VERSION/{s/CURRENT_PROJECT_VERSION = //;s/;//;s/^[[:space:]]*//;p;q;}' $project_file)
echo "Current Version: "$current_version_number
echo "Current Build: "$current_build_number

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

# Step 2: Update RPC and protocol versions in /SmartDeviceLink/private/SDLGlobals.m
echo 
echo "Step 2: Checking SDLGlobals.m for RPC and Protocol versions"
file="SmartDeviceLink/private/SDLGlobals.m"
current_rpc_version=$(sed -n '/SDLMaxProxyProtocolVersion/{s/^.*@//;s/[\;]//;s/[\"]//g;p;q;}' $file)
current_protocol_version=$(sed -n '/SDLMaxProxyRPCVersion/{s/^.*@//;s/[\;]//;s/[\"]//g;p;q;}' $file)
echo "Current RPC Version: "$current_rpc_version
echo "Current Protocol Version: "$current_protocol_version
echo "If these are not correct, please update protocol versions in /SmartDeviceLink/private/SDLGlobals.m. Then press enter..."
read user_input

# 3 Update to the newest BSON submodule. Update Package.swift and CocoaPods dependency files to point to latest if necessary.
# extract version and link from Package.swift
package_file="Package.swift"
package_dependency_info="$(sed -n '/.package/{s/let package = Package(//;s/.package(//;s/)//;s/^[[:space:]]*//g;p;}' $package_file)"
if [ ! -z "$submodule_info" ]; then
    #loop through the dependencies 
    while IFS= read -r dependency_record ;
    do
        # if the dependency_record in the dependancies is not empty (the first one usually is due to string interpretation of a list)
        if [ ! -z "$dependency_record" ]; then
            # identify the fields of the record
            record_info="$(sed 's/,/\n/g' <<< $dependency_record)"
            record_name=$(sed -n '/name:/{s/name://g;s/^[[:space:]]*//g;s/"//g;p;}' <<< "$record_info")
            record_url=$(sed -n '/url:/{s/url://g;s/^[[:space:]]*//g;s/"//g;p;}' <<< "$record_info")
            record_version=$(sed -n '/from:/{s/from://g;s/^[[:space:]]*//g;s/"//g;p;}' <<< "$record_info")
            
            # figure out latest version (visit link?)
            #dependency_latest_version=$(gh repo view $record_url --json latestRelease -q .latestRelease.tagName)

            # compare versions
            #if [ $record_version != $dependency_latest_version ]; then
                echo
                echo "Current version of $record_name: "$record_version
                #echo "Latest version of $record_name: "$dependency_latest_version
            #fi
        fi
    done <<< "$submodule_info"
    echo
    echo "Please update the dependencies in Package.swift, SmartDeviceLink.podspec, and SmartDeviceLink-iOS.podspec appropriately, then press enter..."
    read user_input 
fi

# 4 update changelog
# TODO - insert a template into the changelog that includes the version the users have selected above.
#echo "A template for this release has been inserted into the changelog.  Please update it."
echo 
echo "Please update CHANGELOG.md, then return here and press enter..."
read user_input
# TODO - check modified info before and after so we can detect if the user failed to update the file.


# 5 generate documentation
echo 
prompt_user "Would you like to automatically generate documentation with Jazzy"
if [[ $? == 1 ]]; then
    # Check if Jazzy is already installed, and if not then install jazzy
    if [ -z "$(mdfind -name 'Jazzy')" ]; then
        echo "Jazzy is not installed, attempting to install (may require your password)..."
        sudo gem install jazzy
    fi

    # this runs Jazzy to generate the documentation
    echo "Running Jazzy to generate documentation..."
    jazzy --clean --objc --framework-root SmartDeviceLink --sdk iphonesimulator --umbrella-header SmartDeviceLink/public/SmartDeviceLink.h --theme theme --output docs
fi

# 6 Ensure that the RPC_SPEC has released to the master branch and update the submodule to point to the new release tag (or to the HEAD of master, if no release of the RPC_SPEC is occurring).
echo 
echo "Please check if there is a new release of the RPC_SPEC on https://www.github.com/smartdevicelink/rpc_spec"
echo "If there is, please update the rpc_spec submodule to point to the newest commit on the master branch. Press enter to continue..."
read user_input
#TODO - phase ? - can this be automated.  Check version here.  Check version at site.
#record_url=https://www.github.com/smartdevicelink/rpc_spec
#submodule_latest_version=$(gh repo view $record_url --json latestRelease -q .latestRelease.tagName)

echo
echo "Please perform the following steps to set up the Github release."

# git commands
# 7 commit release to develop
prompt_user "Would you like to commit and push these changes to the develop branch"
if [[ $? == 1 ]]; then
    # Add, commit, and push changes
    git add -A
    git commit -m "Update for release $new_version_number"
    git push --set-upstream origin $develop_branch
fi

echo
# 8 merge release to master
prompt_user "Would you like to merge this release to master? (This will not push to master)"
if [[ $? == 1 ]]; then
    # checkout master
    git checkout $main_branch

    # merge develop with master
    git merge $main_branch $develop_branch

    echo "Please check that everything is correct. Then, assuming you have permissions, push to master, then press enter..."
fi

echo
# 9 tag it
prompt_user "Would you like to tag this release with $new_version_number? (This will not push the tag)"
if [[ $? == 1 ]]; then
    echo "Tag with version from above"
    git tag $new_version_number
    # IDEA - else condition that allows the user to enter a different tag
fi

echo
# 10 merge master back to develop
prompt_user "Would you like to merge master back into develop (This will not push the branch)"
if [[ $? == 1 ]]; then
    git merge $develop_branch $main_branch
fi

echo
# 11 Create new release for tag
prompt_user "Would you like to open to the Github releases page to create a release"
if [[ $? == 1 ]]; then
    open "https://github.com/smartdevicelink/sdl_ios/releases"

    # TODO - phase 4 - this can be automated with gh
    # https://cli.github.com/manual/gh_release_create
    # TODO - can we pull the list of changes from Changelog.md and automatically add those to the release (so we do not type the same things twice)
    # TODO - if/when we automate this, make sure to open the releases page so the user can review it.
fi

echo
# 12 push new release to primary and secondary cocoapod using command line:
prompt_user "Would you like to push the release to CocoaPods"
if [[ $? == 1 ]]; then
    pod trunk push SmartDeviceLink.podspec --allow-warnings
    pod trunk push SmartDeviceLink-iOS.podspec --allow-warnings
fi

echo
prompt_user "Would you like to create a binary xcframework for manual installation"
if [[ $? == 1 ]]; then
    # create framework
    # we pass in the version so that the framework script does not need to ask
    # remember the user will need to ahve permissions for the framework script
    chmod u+x ./scripts/create_framework.sh #I don't know if this works?
    ./scripts/create_framework.sh $new_version_number
fi

# 14 Rename the docset and pack it
echo
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
echo
echo "Release complete."