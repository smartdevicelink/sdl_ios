[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/SmartDeviceLink-iOS.svg?style=flat)](https://cocoapods.org/pods/SmartDeviceLink-iOS)
[![License](https://img.shields.io/cocoapods/l/SmartDeviceLink-iOS.svg?style=flat)](https://cocoapods.org/pods/SmartDeviceLink-iOS)
[![Build Status](https://img.shields.io/travis/smartdevicelink/sdl_ios/master.svg?style=flat)](https://travis-ci.org/smartdevicelink/sdl_ios)
[![codecov.io](https://img.shields.io/codecov/c/github/codecov/smartdevicelink/sdl_ios/master.svg?style=flat)](http://codecov.io/github/smartdevicelink/sdl_ios?branch=master)
[![Slack Status](http://sdlslack.herokuapp.com/badge.svg)](http://slack.smartdevicelink.org)


# SmartDeviceLink (SDL)

SmartDeviceLink (SDL) is a standard set of protocols and messages that connect applications on a smartphone to a vehicle head unit. This messaging enables a consumer to interact with their application using common in-vehicle interfaces such as a touch screen display, embedded voice recognition, steering wheel controls and various vehicle knobs and buttons. There are three main components that make up the SDL ecosystem.

  * The [Core](https://github.com/smartdevicelink/sdl_core) component is the software which Vehicle Manufacturers (OEMs)  implement in their vehicle head units. Integrating this component into their head unit and HMI based on a set of guidelines and templates enables access to various smartphone applications.
  * The optional [SDL Server](https://github.com/smartdevicelink/sdl_server) can be used by Vehicle OEMs to update application policies and gather usage information for connected applications.
  * The [iOS](https://github.com/smartdevicelink/sdl_ios) and [Android](https://github.com/smartdevicelink/sdl_android) libraries are implemented by app developers into their applications to enable command and control via the connected head unit.

<a href="http://www.youtube.com/watch?feature=player_embedded&v=AzdQdSCS24M" target="_blank"><img src="http://i.imgur.com/nm8UujD.png?1" alt="SmartDeviceLink" border="10" /></a>


## Mobile Proxy

The mobile library component of SDL is meant to run on the end user’s smart-device from within SDL enabled apps. The library allows the apps to connect to SDL enabled head-units and hardware through bluetooth, USB, and TCP. Once the library establishes a connection between the smart device and head-unit through the preferred method of transport, the two components are able to communicate using the SDL defined protocol. The app integrating this library project is then able to expose its functionality to the head-unit through text, media, and other interactive elements.


## SDL iOS

We're still working on creating documentation for each of these individual repositories, but in the meantime, you can find more information about SmartDeviceLink [on the SDL Core README](https://github.com/smartdevicelink/sdl_core/blob/master/README.md) and [on Genivi](http://projects.genivi.org/smartdevicelink/about).

See the [changelog](https://github.com/smartdevicelink/sdl_ios/blob/master/CHANGELOG.md) for release notes. This project uses [Semantic Versioning](http://semver.org/).

### Installing

##### Cocoapods

You can install this library using [Cocoapods](https://cocoapods.org/pods/SmartDeviceLink-iOS). You can get started with Cocoapods by [following their install guide](https://guides.cocoapods.org/using/getting-started.html#getting-started), and learn how to use Cocoapods to install dependencies [by following this guide](https://guides.cocoapods.org/using/using-cocoapods.html).

In your podfile, you want to add `pod 'SmartDeviceLink-iOS', '4.1.0'`. Then run `pod install` inside your terminal. With Cocoapods, we support iOS 6+.

##### Carthage

SDL iOS supports Carthage! Install using Carthage by following [this guide](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application). Carthage supports iOS 8+.

##### Dynamic Framework

Tagged to our releases is a dynamic framework file that can be drag-and-dropped into the application. Dynamic frameworks are supported on iOS 8+.

### Reference Documentation

You can find the latest reference documentation on [Cocoadocs](http://cocoadocs.org/docsets/SmartDeviceLink-iOS). Install this documentation to [Dash](http://kapeli.com/dash) or Xcode using [Docs for Xcode](https://documancer.com/xcode/). On the [docs page](http://cocoadocs.org/docsets/SmartDeviceLink-iOS), click the 'share' button in the upper right.

### Getting Help

If you see a bug, feel free to post an issue on the appropriate repository. Please see the [contribution guidelines](https://github.com/smartdevicelink/sdl_ios/blob/master/CONTRIBUTING.md) before proceeding. If you need general assistance, or have other questions, you can [sign up](http://slack.smartdevicelink.org) for the [SDL Slack](https://smartdevicelink.slack.com) and chat with other developers and the maintainers of the project.

### Running Tests
To run tests, you will need to bootstrap the Carthage testing libraries. To do so, first [install Carthage](https://github.com/Carthage/Carthage#installing-carthage).

Then, from the root project directory, run:
```bash
cd SmartDeviceLink-iOS
carthage bootstrap --platform ios
cd ../
```

At this point, you can run tests from Xcode, or, if you wish to run the tests exactly as they will be run on the CI server, [install xctool](https://github.com/facebook/xctool#installation) and run:

```bash
xctool -project SmartDeviceLink-iOS/SmartDeviceLink-iOS.xcodeproj -scheme SmartDeviceLink -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO RUN_CLANG_STATIC_ANALYZER=NO test
```

### SDL iOS Getting Started

#### Other Installation Requirements
You may want to build the [sdl_core project](https://github.com/smartdevicelink/sdl_core) to be able to see your application connecting if you don't have an iAP enabled head unit to test.

#### Enabling Background Capabilities
iOS 5 introduced the capability for an iOS application to maintain a connection to an external accessory while the application is in the background. This capability must be explicitly enabled for your application.

To enable the feature for your application, select your application's build target, go to Capabilities, enable Background Modes, and select the External accessory communication mode.

![Enable External Accessory Background Mode](http://i.imgur.com/zxn4lsb.png)

#### SDL protocol strings
Your application must support a set of smartdevicelink protocol strings in order to be connected to smartdevicelink enabled head units. Go to your application's .plist, look at the source, and add the following code under the top level `dict`. Note: This is not required if you're only testing by connected to a wifi enabled head unit, but is required for USB and Bluetooth enabled head units.

```xml
<key>UISupportedExternalAccessoryProtocols</key>
	<array>
		<string>com.smartdevicelink.prot29</string>
		<string>com.smartdevicelink.prot28</string>
		<string>com.smartdevicelink.prot27</string>
		<string>com.smartdevicelink.prot26</string>
		<string>com.smartdevicelink.prot25</string>
		<string>com.smartdevicelink.prot24</string>
		<string>com.smartdevicelink.prot23</string>
		<string>com.smartdevicelink.prot22</string>
		<string>com.smartdevicelink.prot21</string>
		<string>com.smartdevicelink.prot20</string>
		<string>com.smartdevicelink.prot19</string>
		<string>com.smartdevicelink.prot18</string>
		<string>com.smartdevicelink.prot17</string>
		<string>com.smartdevicelink.prot16</string>
		<string>com.smartdevicelink.prot15</string>
		<string>com.smartdevicelink.prot14</string>
		<string>com.smartdevicelink.prot13</string>
		<string>com.smartdevicelink.prot12</string>
		<string>com.smartdevicelink.prot11</string>
		<string>com.smartdevicelink.prot10</string>
		<string>com.smartdevicelink.prot9</string>
		<string>com.smartdevicelink.prot8</string>
		<string>com.smartdevicelink.prot7</string>
		<string>com.smartdevicelink.prot6</string>
		<string>com.smartdevicelink.prot5</string>
		<string>com.smartdevicelink.prot4</string>
		<string>com.smartdevicelink.prot3</string>
		<string>com.smartdevicelink.prot2</string>
		<string>com.smartdevicelink.prot1</string>
		<string>com.smartdevicelink.prot0</string>
		<string>com.ford.sync.prot0</string>
	</array>
```

#### Creating the SDLProxy
When creating a proxy, you will likely want a class to manage the Proxy and related functions for you. The example project located in this repository has a class called "ProxyManager" to serve this function. One important, somewhat odd note, is that when the proxy is created, it will immediately start. This means that you should only build the Proxy object when you are ready to search for connections. For production apps using iAP, this is early, since it ought to be ready for an iAP connection the entire time your app is available. However, when debugging using Wi-Fi, you may want to tie this to a button press, since the search can timeout.

Another odd note is that if a connection disconnects for any reason, you will receive an `onProxyClosed` callback through the `SDLListener` delegate (see below), and you will have to completely discard and rebuild the proxy object.

The example app's `startProxyWithTransportType` handles starting up the proxy when necessary. The proxy object should be stored as a property of it's parent class.

```objc
switch (transportType) {
    case ProxyTransportTypeTCP: {
        self.proxy = [SDLProxyFactory buildSDLProxyWithListener:self tcpIPAddress:@"192.168.1.1" tcpPort:@"1234"];
    } break;
    case ProxyTransportTypeIAP: {
        self.proxy = [SDLProxyFactory buildSDLProxyWithListener:self];
    } break;
    default: NSAssert(NO, @"Unknown transport setup: %@", @(transportType));
}
```

#### SDLProxyListener

Note in the following lines, that there is a call to pass a `listener` into the build method.

```objc
self.proxy = [SDLProxyFactory buildSDLProxyWithListener:self tcpIPAddress:[Preferences sharedPreferences].ipAddress tcpPort:[Preferences sharedPreferences].port]
self.proxy = [SDLProxyFactory buildSDLProxyWithListener:self];
```

This is an object that conforms to the `SDLProxyListener` protocol. This could be the object holding the reference to the proxy, as it is here.

#### Implement onProxyOpened and other delegate methods
The `SDLProxyListener` protocol has four required methods:

```objc
- (void)onOnDriverDistraction:(SDLOnDriverDistraction*) notification;
- (void)onOnHMIStatus:(SDLOnHMIStatus*) notification;
- (void)onProxyClosed;
- (void)onProxyOpened;
```

`onProxyOpened` is called when a connection is established between the head unit and your application. This is the place to set whatever state you need to, to know that your application is connected. It is also where you must send a register request with your app's information to the vehicle. The example app uses the following basic code:

```objc
self.state = ProxyStateConnected;
    
SDLRegisterAppInterface *registerRequest = [SDLRPCRequestFactory buildRegisterAppInterfaceWithAppName:SDLAppName languageDesired:[SDLLanguage EN_US] appID:SDLAppId];
[self.proxy sendRPC:registerRequest];
```

When the proxy is closed, you will receive a call to `onProxyClosed`. This is where you will reset the state of the proxy, because remember, when a connection is closed, it is assumed that you will destroy the current proxy. The example app runs a method called `resetProxyWithTransportType:` that runs the following:

```objc
[self stopProxy];
[self startProxyWithTransportType:transportType];
```

`stopProxy` does the following:

```objc
self.state = ProxyStateStopped;

if (self.proxy != nil) {
    [self.proxy dispose];
    self.proxy = nil;
}
```

#### onOnHMIStatus
When your app receives `onOnHMIStatus` it has changed HMI states on the head unit. For example, your application can be put into `HMI_FULL` meaning that it has full access to the vehicle screen. For more info on HMI Levels, [see the Cocoadoc documentation on the enum](http://cocoadocs.org/docsets/SmartDeviceLink-iOS/4.0.3/Classes/SDLHMILevel.html).

You will want to track your first HMI FULL, for instance with a boolean value. The example application has extremely basic tracking of this type in the `onOnHMIStatus` callback.

```objc
if ((notification.hmiLevel == [SDLHMILevel FULL]) && self.isFirstHMIFull) {
    [self showInitialData];
    self.isFirstHMIFull = NO;
}
```

#### WiFi vs. iAP

As described in the section "Creating the SDLProxy", you need will have separate setup for either WiFi (debugging) and iAP (production) code.

```objc
switch (transportType) {
    case ProxyTransportTypeTCP: {
        self.proxy = [SDLProxyFactory buildSDLProxyWithListener:self tcpIPAddress:@"192.168.1.1" tcpPort:@"1234"];
    } break;
    case ProxyTransportTypeIAP: {
        self.proxy = [SDLProxyFactory buildSDLProxyWithListener:self];
    } break;
    default: NSAssert(NO, @"Unknown transport setup: %@", @(transportType));
}
```

When creating for WiFi, you will want to know the IP address and port of the Core system you are testing with. With IAP connections, you will use the "build" method without setting an IP and Port, and IAP will automatically be activated.
