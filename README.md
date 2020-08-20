[![Accio supported](https://img.shields.io/badge/Accio-supported-0A7CF5.svg?style=flat)](https://github.com/JamitLabs/Accio)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/SmartDeviceLink-iOS.svg?style=flat)](https://cocoapods.org/pods/SmartDeviceLink-iOS)
[![License](https://img.shields.io/cocoapods/l/SmartDeviceLink-iOS.svg?style=flat)](https://cocoapods.org/pods/SmartDeviceLink-iOS)
![SmartDeviceLink Tests](https://github.com/smartdevicelink/sdl_ios/workflows/SmartDeviceLink%20Tests/badge.svg)
[![codecov](https://codecov.io/gh/smartdevicelink/sdl_ios/branch/master/graph/badge.svg)](https://codecov.io/gh/smartdevicelink/sdl_ios)
[![Documentation](docs/badge.svg)](https://smartdevicelink.com/en/guides/iOS/getting-started/installation/)
[![Slack Status](http://sdlslack.herokuapp.com/badge.svg)](http://slack.smartdevicelink.com) 

# What is SmartDeviceLink (SDL)

[SmartDeviceLink (SDL)](https://www.smartdevicelink.com) is a standard set of protocols and messages that connect applications on a smartphone to a vehicle head unit. This messaging enables a consumer to interact with their application using common in-vehicle interfaces such as a touch screen display, embedded voice recognition, steering wheel controls and various vehicle knobs and buttons. There are three main components that make up the SDL ecosystem.

* The [Core](https://github.com/smartdevicelink/sdl_core) component is the software which Vehicle Manufacturers (OEMs)  implement in their vehicle head units. Integrating this component into their head unit and HMI based on a set of guidelines and templates enables access to various smartphone applications.
* The optional [SDL Server](https://github.com/smartdevicelink/sdl_server) can be used by Vehicle OEMs to update application policies and gather usage information for connected applications.
* The [iOS](https://github.com/smartdevicelink/sdl_ios), [Android / Java Suite](https://github.com/smartdevicelink/sdl_android), and [JavaScript](https://github.com/smartdevicelink/sdl_javascript_suite) libraries are implemented by app developers into their applications to enable command and control via the connected head unit.
* To suggest new features to SDL, including the iOS library, go to the [SDL Evolution](https://github.com/smartdevicelink/sdl_evolution) github project.
* To understand if a contribution should be entered as an iOS Pull Request or Issue, or an SDL Evolution Proposal, please reference [this document](https://github.com/smartdevicelink/sdl_evolution/blob/master/proposals_versus_issues.md).


## SDL iOS App Library
The mobile library component of SDL is meant to run on the end user’s smart-device from within SDL enabled apps. The library allows the apps to connect to SDL enabled head-units and hardware through Bluetooth, USB, and TCP. Once the library establishes a connection between the smart device and head-unit through the preferred method of transport, the two devices are able to communicate using the SDL defined protocol. The app integrating this library project is then able to expose its functionality to the head-unit through text, media, and other interactive elements.

You can find guides and documentation on how to use this library at the [SmartDeviceLink website](https://smartdevicelink.com/en/guides/iOS/getting-started/installation/). You can find the upcoming releases roadmap at the [SDL Evolution Github](https://github.com/smartdevicelink/sdl_evolution#recent-and-upcoming-releases).

### Installing
To install this library as a framework in your app, see the [Installation Guide](https://smartdevicelink.com/en/guides/iOS/getting-started/installation/). There are instructions on how to install using the dependency managers CocoaPods, Carthage, and Accio, as well as how to install the library framework manually.

#### Adding a Dynamic Framework
Tagged to our releases is a dynamic framework file that can be drag-and-dropped into the application. Dynamic frameworks are supported on iOS 8+. **WARNING: You cannot submit your app to the app store with the framework as is. You MUST strip the simulator part of the framework first. Strip the x64 and i386 portions first like so:**

```bash
lipo -remove i386 -remove x86_64 -o SmartDeviceLink.framework/SmartDeviceLink SmartDeviceLink.framework/SmartDeviceLink
```

You can check the current architectures like so:

```bash
lipo -info SmartDeviceLink.framework/SmartDeviceLink
```

### Getting Help
If you have questions, first view our guides on the [SmartDeviceLink website](https://smartdevicelink.com/en/guides/iOS/getting-started/installation/).

If you see a bug, please post an issue on the appropriate repository. Please see the [contribution guidelines](https://github.com/smartdevicelink/sdl_ios/blob/master/.github/CONTRIBUTING.md) before proceeding. If you need general assistance, or have other questions, you can [sign up](http://slack.smartdevicelink.com) for the [SDL Slack](https://smartdevicelink.slack.com) and chat with other developers and the maintainers of the project.

### Example Apps
This library repository contains two example apps: one written in Objective-C and one in Swift. If you have CocoaPods installed, you can easily run one of the example apps by executing `pod try SmartDeviceLink` in your terminal. Alternatively, you can clone or download the project, but before attempting to build and run the example apps you must follow the [installation steps](#preparing-for-development).

There are additional example apps available [in the example organization](https://github.com/smartdevicelink-examples/), these require CocoaPods to install dependencies.

### Contributing to the Project
We welcome contributors to the project, but it helps to know a few things about how the project is organized.

1. All Pull Requests _must_ fix an issue. Before creating a PR for a bug or feature, ensure that there is an open issue for it. If there is not, open one!
2. We recommend telling the project maintainers that you intend to contribute a PR for an issue. This allows us to internally track what PRs will be contributed and to plan time to review your PR. Furthermore, we may ask you not to work on a PR for that issue for various reasons (see below).
3. We welcome PRs for bug fixes! If there's a confirmed issue for a bug, we would welcome a bug fix. The PR will require a review from a project maintainer before it can be merged.
4. PRs for features require additional planning. Features must be approved by the SDLC using the [Evolution Process](https://github.com/smartdevicelink/sdl_evolution) before an issue can be opened. Furthermore, a feature must be approved to be developed for a release by the SDLC before a PR can be opened. Finally, a PR cannot be merged if the underlying feature requires or should have alignment across multiple projects until PRs for all those projects are ready for review.

#### Preparing for Development
To prepare the library for development, you will need to take a few steps:

1. Clone this repository.
1. Install submodules with `git submodule init` and `git submodule update`.
1. Install [testing dependencies](#running-tests).
1. Ensure that you can run the [Example test apps](#example-apps).

#### Creating or Updating an RPC
When creating or updating an RPC, you will need to install and use the [RPC generator](https://github.com/smartdevicelink/sdl_ios/tree/master/generator). The generator must be used to ensure that the content is correct. To use the generator, the RPC must be updated on the [RPC spec repository](https://github.com/smartdevicelink/rpc_spec).

#### Running Tests
To run tests, you will need to bootstrap the Carthage testing libraries. To do so, first [install Carthage](https://github.com/Carthage/Carthage#installing-carthage).

Then, from the root project directory, run:
```bash
carthage bootstrap --platform ios
cd ../
```

At this point, you can run tests from Xcode, or, if you wish to run the tests exactly as they will be run on the CI server, run:

```bash
xcodebuild build-for-testing -project SmartDeviceLink-iOS.xcodeproj -destination platform=iOS Simulator,name=iPhone 11,OS=13.5 -scheme SmartDeviceLink

set -o pipefail && xcodebuild test-without-building -project SmartDeviceLink-iOS.xcodeproj -destination platform=iOS Simulator,name=iPhone 11,OS=13.5 -scheme SmartDeviceLink -configuration Debug ONLY_ACTIVE_ARCH=NO RUN_CLANG_STATIC_ANALYZER=NO GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES GCC_GENERATE_TEST_COVERAGE_FILES=YES ENABLE_TESTABILITY=YES
```

##### Lock Screen Screenshot Tests
We run some additional tests using [iOSSnapshotTestCase](https://github.com/uber/ios-snapshot-test-case). These tests generate the lock screen view controller and compare it to generated screenshots. By default, the generated screenshots use the iPhone 11 simulator and if you run the unit tests on that simulator, the tests should pass by default.

###### Re-Generating Lock Screen Screenshots
If you need to change which simulator is used to generate the screenshots, or if you need to re-generate the screenshots for another reason, you can. Go to `SDLLockScreenViewControllerSnapshotTests.m` and take the following steps:

1. Uncomment the following line:

```objc
// self.recordMode = YES;
```

2. Run unit tests on the simulator that you want to use to generate the screenshots. Tests should fail because record mode is on.
3. Re-comment out the line.
4. Run unit tests again; they should pass this time.
