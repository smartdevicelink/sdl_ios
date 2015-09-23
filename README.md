##### Note: Please see the [release/4.0.0](https://github.com/smartdevicelink/sdl_ios/tree/release/4.0.0) branch of sdl_ios for the most recent version. Significant changes have been made since the latest stable release and the in-progress develop branch. When released, it will include distribution via Carthage and Cocoapods. The current release candidate has Cocoapods support, see below for installation instructions.

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/SmartDeviceLink-iOS.svg?style=flat)](https://cocoapods.org/pods/SmartDeviceLink-iOS)
[![License](https://img.shields.io/cocoapods/l/SmartDeviceLink-iOS.svg?style=flat)](https://cocoapods.org/pods/SmartDeviceLink-iOS)
[![Build Status](https://img.shields.io/travis/smartdevicelink/sdl_ios/release%2F4.0.0.svg?style=flat)](https://travis-ci.org/smartdevicelink/sdl_ios)
[![codecov.io](https://img.shields.io/codecov/c/github/codecov/smartdevicelink/sdl_ios/release%2F4.0.0.svg?style=flat)](http://codecov.io/github/smartdevicelink/sdl_ios?branch=release/4.0.0)


# SmartDeviceLink (SDL)

SmartDeviceLink (SDL) is a standard set of protocols and messages that connect applications on a smartphone to a vehicle head unit. This messaging enables a consumer to interact with their application using common in-vehicle interfaces such as a touch screen display, embedded voice recognition, steering wheel controls and various vehicle knobs and buttons. There are three main components that make up the SDL ecosystem.

  * The [Core](https://github.com/smartdevicelink/sdl_core) component is the software which Vehicle Manufacturers (OEMs)  implement in their vehicle head units. Integrating this component into their head unit and HMI based on a set of guidelines and templates enables access to various smartphone applications.
  * The optional [SDL Server](https://github.com/smartdevicelink/sdl_server) can be used by Vehicle OEMs to update application policies and gather usage information for connected applications.
  * The [iOS](https://github.com/smartdevicelink/sdl_ios) and [Android](https://github.com/smartdevicelink/sdl_android) libraries are implemented by app developers into their applications to enable command and control via the connected head unit.


## Mobile Proxy

The mobile library component of SDL is meant to run on the end user’s smart-device from within SDL enabled apps. The library allows the apps to connect to SDL enabled head-units and hardware through bluetooth, USB, and TCP. Once the library establishes a connection between the smart device and head-unit through the preferred method of transport, the two components are able to communicate using the SDL defined protocol. The app integrating this library project is then able to expose its functionality to the head-unit through text, media, and other interactive elements.


## SDL iOS

We're still working on creating documentation for each of these individual repositories, but in the meantime, you can find more information about SmartDeviceLink [on the SDL Core README](https://github.com/smartdevicelink/sdl_core/blob/master/README.md) and [on Genivi](http://projects.genivi.org/smartdevicelink/about).

See the [changelog](https://github.com/smartdevicelink/sdl_ios/blob/release/4.0.0/CHANGELOG.md) for release notes. This project uses [Semantic Versioning](http://semver.org/).

### Installing

##### Cocoapods

You can install this library using [Cocoapods](https://cocoapods.org/pods/SmartDeviceLink-iOS). You can get started with Cocoapods by [following their install guide](https://guides.cocoapods.org/using/getting-started.html#getting-started), and learn how to use Cocoapods to install dependencies [by following this guide](https://guides.cocoapods.org/using/using-cocoapods.html).

In your podfile, you want to add `pod 'SmartDeviceLink-iOS', '4.0.0-RC.2'`. Then run `pod install` inside your terminal.

##### Carthage

Carthage currently only supports stable versions, support will come when SDL iOS releases version 4.0.0 stable.

### Reference Documentation

You can find the latest reference documentation on [Cocoadocs](http://cocoadocs.org/docsets/SmartDeviceLink-iOS). Install this documentation to [Dash](http://kapeli.com/dash) or Xcode using [Docs for Xcode](https://documancer.com/xcode/). On the [docs page](http://cocoadocs.org/docsets/SmartDeviceLink-iOS), click the 'share' button in the upper right.
