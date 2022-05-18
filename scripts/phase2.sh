#!/bin/bash

# George Miller
# 05-17-2022
# If you don't have permission to run, try: chmod u+x phase1.sh

clear

echo "zug zug"

# 0 do some directory shenanigans to get us to the correct working directory.
echo $PWD
if [[ $PWD == *"scripts" ]]; then
    cd ..
fi

# 1 bump version in projectFile
echo
echo "Step 1: Update version in Project File"

# 1.1) get the current version and build from the podspec file
ProjFile=./SmartDeviceLink-iOS.xcodeproj/project.pbxproj
NewFile=./SmartDeviceLink-iOS.xcodeproj/new.pbxproj
Current_version_number=$(sed -n '/MARKETING_VERSION/{s/MARKETING_VERSION = //;s/;//;s/^[[:space:]]*//;p;q;}' $ProjFile)
Current_build_number=$(sed -n '/CURRENT_PROJECT_VERSION/{s/CURRENT_PROJECT_VERSION = //;s/;//;s/^[[:space:]]*//;p;q;}' $ProjFile)
echo "Current Version "$Current_version_number
echo "Current Build "$Current_build_number

# 1.2) prompt user for new version
echo "New Version?"
read NewVersionNumber
echo "New Build?"
read NewBuildNumber

# 1.3) if not blank, or not the same
if [ -z $NewVersionNumber ]; then
    echo No file change needed for version
else
    if [ $Current_version_number != $NewVersionNumber ]; then
        echo make the change
        # 1.4) swap new version in to file
        sed '/MARKETING_VERSION/{s/'$Current_version_number'/'$NewVersionNumber'/;}' $ProjFile > $NewFile
        mv -f $NewFile $ProjFile
    else
        echo No file change needed for version
    fi
fi
if [ -z $NewBuildNumber ]; then
    echo No file change needed for build
else
    if [ $Current_build_number != $NewBuildNumber ]; then
        echo make the change
        # 1.4) swap new version in to file
        sed '/CURRENT_PROJECT_VERSION/{s/'$Current_build_number'/'$NewBuildNumber'/;}' $ProjFile > $NewFile
        mv -f $NewFile $ProjFile
    else
        echo No file change needed for build
    fi
fi


# 2 update version in podspec
# SmartDeviceLink-iOS.podspec

echo
echo "Step 2: Update version in podspec File"

# 2.1) get the current version from the podspec file
PodSpecFile=SmartDeviceLink-iOS.podspec
PodSpecNewFile=NewFile.podspec
CurrentVersion=$(sed -n '/s.version/{s/s.version//;s/=//;s/[\"]//g;s/^[[:space:]]*//g;p;q;}' $PodSpecFile)
echo "Current Version="$CurrentVersion

# 2.2) prompt user for new version
echo "New Version?"
read NewVersion

# 2.3) if not blank, or not the same
if [ -z $NewVersion ]; then
    echo No file change needed
else
    if [ $CurrentVersion != $NewVersion ]; then
        echo make the change
        # 2.4) swap new version in to file
        sed '/s.version/{s/'$CurrentVersion'/'$NewVersion'/;}' $PodSpecFile > $PodSpecNewFile
        mv -f $PodSpecNewFile $PodSpecFile
    else
        echo No file change needed for version
    fi
fi

echo "work complete"