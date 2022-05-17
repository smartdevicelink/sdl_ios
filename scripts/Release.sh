#!/bin/bash

# George Miller
# 05-17-2022
# If you don't have permission to run, try: chmod u+x Release.sh

echo "Start"

# Phase 2: Script changes build numbers automatically in pbxproj and podspecs


# 1 bump version in projectFile
# sed stream edit.  It's fast, and can make changes.
bash Phase2.sh

# 2 update version in podspec
# SmartDeviceLink-iOS.podspec

# 3 update RPC versions

# 3 update protocol versions

# 4 update to newest bson

# 4 update package.swift

# 4 update CocoaPods dependancy

# 5 update changelog

# 6 Install Jazzy
echo "6 Install Jazzy"
sudo gem install jazzy

# 6 generate documentation
echo "6 generate documentation"
#bash generate-documentation.sh

# 7 ensure RPC_SPEC has released to master

# 7 update the submodule to poitn to new release

# 8 commit release to develop

# 8 merge release to master

# 8 tag it

# 8 merge master back to develop



# Phase 1: Script runs pod trunk pushes, builds xcframework, builds documentation


# 1 Create new release for tag
# ?

# 1 add highlights of changes
# ?

bash phase1.sh

# iv Compress the .xcframework and add the it to the release.
echo "4.iv Compress the .xcframework and add the it to the release."
# SmartDeviceLink.xcframework

# 5 add docset to release (docs/docsets/)
# ?

# 6 rename docset similar to old releases
# ?

# 6 rename framework similar to old releases
# ?

echo "Complete"
