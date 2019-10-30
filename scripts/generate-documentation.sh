#!/bin/bash
set -o nounset
set -o errexit

if hash jazzy 2>/dev/null; then
cd ../
jazzy --clean --objc --framework-root SmartDeviceLink --sdk iphonesimulator --umbrella-header SmartDeviceLink/SmartDeviceLink.h --theme theme --output docs
fi