# Changelog
## 6.7.0
### Versions
* Supports [SDL RPC Spec 6.0.0](https://github.com/smartdevicelink/rpc_spec/releases/tag/6.0.0) and [SDL Protocol Spec 5.2.0](https://github.com/smartdevicelink/protocol_spec/releases/tag/5.2.0).

### Testing
* Tested with Xcode 11.6
* iOS 13.5 and 13.6
* Core:
  * Manticore (Core v6.1.1, Generic HMI v0.8.1)
  * Ford Sync 3.4 (19353_DEVTEST)
  * Ford Sync 3.0 (17276_DEVTEST)
  * Ford Sync 4.0 (20016_DEVTEST)
  * Core v5.1.0 with sdl_hmi v5.2.0
  * Core v6.1.1

### Enhancements
* Added subscribe button features to the screen manager (https://github.com/smartdevicelink/sdl_ios/issues/1563).
* Added a new `SDLManager` delegate method for updating the HMI and VR language separately (https://github.com/smartdevicelink/sdl_ios/issues/1593).
* Added a new initializer to `SDLButtonPress` because the existing ones were missing a mandatory parameter (https://github.com/smartdevicelink/sdl_ios/issues/1635).
* Aligned `SDLPermissionManager` methods with Java Suite and JavaScript Suite libraries, adding methods for parameter permissions and more (https://github.com/smartdevicelink/sdl_ios/issues/1661, https://github.com/smartdevicelink/sdl_ios/issues/1667, https://github.com/smartdevicelink/sdl_ios/issues/1682).

### Bug Fixes
* Fix the video background when the app goes into the background not always showing when it should (https://github.com/smartdevicelink/sdl_ios/issues/1620).
* Improved `SDLAudioStreamManager` error messages (https://github.com/smartdevicelink/sdl_ios/issues/1622).
* Better handling of head units sending a `nil` `displayCapabilities` in the `SystemCapabilityManager` (https://github.com/smartdevicelink/sdl_ios/issues/1623).
* Fixed a deadlock that could happen on the lock screen due to some calls being asynchronous but handled synchronously (https://github.com/smartdevicelink/sdl_ios/issues/1629).
* Stop and start `SDLFocusableItemLocator` when the video stream starts and stops (https://github.com/smartdevicelink/sdl_ios/issues/1631).
* Fixed turning wifi off and back on causing secondary transport to fail (https://github.com/smartdevicelink/sdl_ios/issues/1631, https://github.com/smartdevicelink/sdl_ios/issues/1639).
* Fixed using the permission manager in Swift would sometimes crash (https://github.com/smartdevicelink/sdl_ios/issues/1636).
* Fixed Travis tests failing and moved to Github Actions CI (https://github.com/smartdevicelink/sdl_ios/issues/1640, https://github.com/smartdevicelink/sdl_ios/issues/1642, https://github.com/smartdevicelink/sdl_ios/issues/1678).
* Fixed sending an empty VR array in an `SDLMenuCell` would fail (https://github.com/smartdevicelink/sdl_ios/issues/1648).
* Fix a launch app should only happen on the main thread (https://github.com/smartdevicelink/sdl_ios/issues/1662).
* Fixed some documentation for a permission manager method to be more specific (https://github.com/smartdevicelink/sdl_ios/issues/1665).
* Fix the encryption manager not being shut down correctly after a disconnect / reconnect (https://github.com/smartdevicelink/sdl_ios/issues/1675).
* Refactor the protocol layer and merge the proxy and lifecycle layers (https://github.com/smartdevicelink/sdl_ios/issues/1680).
* Fix video session properties not being re-set upon reconnection (https://github.com/smartdevicelink/sdl_ios/issues/1683).
* Fix soft button image uploads failing if the first state has no images but other states do (https://github.com/smartdevicelink/sdl_ios/issues/1698).
* Fix a potential race condition in `SystemCapabilityManager` (https://github.com/smartdevicelink/sdl_ios/issues/1709).
* Fix a deadlock that would occur when restarting the `SDLManager` in the `managerDidDisconnect` callback (https://github.com/smartdevicelink/sdl_ios/issues/1710).
* Fix a crash that would occur when receiving an unknown RPC (https://github.com/smartdevicelink/sdl_ios/issues/1713).
* Fix the secondary transport timer starting when a primary transport connects (https://github.com/smartdevicelink/sdl_ios/issues/1716).
* Fix protocol delegates not always receiving an `EndServiceNAK` (https://github.com/smartdevicelink/sdl_ios/issues/1718).

### Other
* Use an `NSTimer` wrapper everywhere internally instead of the raw `NSTimer` (https://github.com/smartdevicelink/sdl_ios/issues/1611).
* Add security manager tests to secondary transport unit tests (https://github.com/smartdevicelink/sdl_ios/issues/1653).
* Fixed documentation for permission manager subscribe callbacks (https://github.com/smartdevicelink/sdl_ios/issues/1724).

### Example Apps
* Add icons to example app vehicle data menus (https://github.com/smartdevicelink/sdl_ios/issues/1580).
* Fixed some small icons and replaced a few icons (https://github.com/smartdevicelink/sdl_ios/issues/1581).

## 6.6.0
### Versions
* Supports [SDL RPC Spec 6.0.0](https://github.com/smartdevicelink/rpc_spec/releases/tag/6.0.0) and [SDL Protocol Spec 5.2.0](https://github.com/smartdevicelink/protocol_spec/releases/tag/5.2.0).

### Enhancements
* The secondary transport now starts only when the app has been brought to HMI Full (https://www.github.com/smartdevicelink/sdl_ios/issues/1145).
* Added RPC generator script – though it is not currently used (https://www.github.com/smartdevicelink/sdl_ios/issues/1298).
* Added helpful convenience initializers to `SDLRadioControlData` (https://www.github.com/smartdevicelink/sdl_ios/issues/1206).
* `SDLSystemCapabilityManager` enhancements and alignment with Java Suite ((https://www.github.com/smartdevicelink/sdl_ios/issues/1535).
* The `SDLManagerDelegate` now has a `videoStreamingState` callback (https://www.github.com/smartdevicelink/sdl_ios/issues/1546).
* The secondary transport will no longer be immediately shut down when the app goes to the background (https://www.github.com/smartdevicelink/sdl_ios/issues/1560).
* Deprecated `SyncPData` and `EncodedSyncPData` RPCs (https://www.github.com/smartdevicelink/sdl_ios/issues/1599).
* Deprecated `OnLockScreenStatus` and `LockScreenStatus` fake RPCs (https://www.github.com/smartdevicelink/sdl_ios/issues/1601).

### Bug Fixes
* Fix video streaming timeout when app goes from background to foreground (https://www.github.com/smartdevicelink/sdl_ios/issues/1471).
* Many lock screen fixes (https://www.github.com/smartdevicelink/sdl_ios/issues/1504, https://www.github.com/smartdevicelink/sdl_ios/issues/1523, https://www.github.com/smartdevicelink/sdl_ios/issues/1545, https://www.github.com/smartdevicelink/sdl_ios/issues/1565).
* Threading fixes around the response handler map (https://www.github.com/smartdevicelink/sdl_ios/issues/1515).
* Fixed some warnings emitted from the lock screen storyboard (https://www.github.com/smartdevicelink/sdl_ios/issues/1521).
* Fix potential race condition in shutting down and starting up `SDLProxy` (https://www.github.com/smartdevicelink/sdl_ios/issues/1532).
* Fix `SDLTouch` to better handle `NSNull` (https://www.github.com/smartdevicelink/sdl_ios/issues/1534).
* Fix empty `SetDisplayLayout.displayCapabilities` breaks the screen manager (https://www.github.com/smartdevicelink/sdl_ios/issues/1536).
* Many secondary transport fixes (https://www.github.com/smartdevicelink/sdl_ios/issues/1551, https://www.github.com/smartdevicelink/sdl_ios/issues/1561).
* Revert deprecations in RPCs relating to `NSDictionary` (https://www.github.com/smartdevicelink/sdl_ios/issues/1557).
* Change how the audio pass thru handler is called to allow sending a new one in the response handler (https://www.github.com/smartdevicelink/sdl_ios/issues/1559).
* Threading fixes around the lifecycle manager `correlationId` (https://www.github.com/smartdevicelink/sdl_ios/issues/1564).
* Fix `SDLStreamingMediaManager` returning an incorrect value for `isStreamingSupported` (https://www.github.com/smartdevicelink/sdl_ios/issues/1569).
* Fix using incorrect MTU sizes for non-RPC services (https://www.github.com/smartdevicelink/sdl_ios/issues/1577).
* Fix IAP crash when the output stream closes (https://www.github.com/smartdevicelink/sdl_ios/issues/1583).
* Fix potential threading crash in `SDLChoiceSetManager` (https://www.github.com/smartdevicelink/sdl_ios/issues/1584).
* Adding some documentation (https://www.github.com/smartdevicelink/sdl_ios/issues/1587).
* Fix a potential race condition crash in the text and graphic manager (https://www.github.com/smartdevicelink/sdl_ios/issues/1595).
* Fix `SDLImageField` initializer (https://www.github.com/smartdevicelink/sdl_ios/issues/1625).

### Example Apps
* They now show a warning message if the slider or scrollable message time out (https://www.github.com/smartdevicelink/sdl_ios/issues/1526).
* Remove example app logic for checking first HMI FULL (https://www.github.com/smartdevicelink/sdl_ios/issues/1554).
* Example app no longer uses deprecated `SDLConfiguration` (https://www.github.com/smartdevicelink/sdl_ios/issues/1607).

## 6.5.0 (Since RC 1)
### Bug Fixes
* Update testing dependencies and fix a few tests that fail after updating OCMock to 3.5.0 due to mocks not being used properly in a test (https://www.github.com/smartdevicelink/sdl_ios/issues/1517).

## 6.5.0 Release Candidate 1
### Bug Fixes
* Fix the `SDLSystemCapabilityManager subscribeToCapabilityType:withObserver:selector:` not returning a BOOL as was declared (https://www.github.com/smartdevicelink/sdl_ios/issues/1465).
* Fix the Soft Button Manager failing if the template is changed and the new template does not support soft buttons (https://www.github.com/smartdevicelink/sdl_ios/issues/1474).
* Objective-C++ projects that previously saw APIs that caused a compiler failure due to keyword restrictions will now no longer see those APIs and will see different APIs instead. All non-Objective-C++ projects will be unchanged. Because the previous release was un-compilable, we are considering this a minor change instead of a major change due to adding APIs (https://www.github.com/smartdevicelink/sdl_ios/issues/1478).
* In some cases the lock screen would show status bar rotation even though the view controller didn't rotate (https://www.github.com/smartdevicelink/sdl_ios/issues/1480).
* Fix the security manager not being set when using a secondary transport in certain cases (https://www.github.com/smartdevicelink/sdl_ios/issues/1482).
* Fix `Show.templateConfiguration` RPC parameter not getting set properly (https://www.github.com/smartdevicelink/sdl_ios/issues/1486).
* In some cases the lock screen window would cause the app's window to display incorrectly when dismissed (https://www.github.com/smartdevicelink/sdl_ios/issues/1492).
* Attempt to fix a background crash when disconnecting – note that your app will still close due to iOS' background restrictions (https://www.github.com/smartdevicelink/sdl_ios/issues/1494).
* In some cases the lock screen window would continue to hide the app's window when dismissed (https://www.github.com/smartdevicelink/sdl_ios/issues/1496).
* When the app runs more than one `UIWindow`, the lock screen manager would sometimes choose the wrong window to display when the lock window is dismissed (https://www.github.com/smartdevicelink/sdl_ios/issues/1501).

## 6.4.1
### Bug Fixes
* Update code documentation (https://www.github.com/smartdevicelink/sdl_ios/issues/983).
* Fix crashes related to apps using iOS 13 multi-window (`UIWindowScene`) APIs (https://www.github.com/smartdevicelink/sdl_ios/issues/1430).
* Fix lock screen not working properly on apps using iOS 13 multi-window APIs (https://www.github.com/smartdevicelink/sdl_ios/issues/1469).

## 6.4.0
### Versions
* Supports [SDL RPC Spec 6.0.0](https://github.com/smartdevicelink/rpc_spec/releases/tag/6.0.0) and [SDL Protocol Spec 5.2.0](https://github.com/smartdevicelink/protocol_spec/releases/tag/5.2.0).

### Enhancements
* The autocomplete options for users in searchable choice sets and popup keyboards can now support more than one item (https://www.github.com/smartdevicelink/sdl_ios/issues/790).
* The application can now be closed (put into HMI level NONE) at runtime programmatically (https://www.github.com/smartdevicelink/sdl_ios/issues/801).
* Added the ability to open the main menu or directly to any sub-menu (https://www.github.com/smartdevicelink/sdl_ios/issues/806).
* Added the ability for the module to turn on or off a gesture to dismiss the lock screen – this can also be disabled on the developer side (https://www.github.com/smartdevicelink/sdl_ios/issues/932).
* Added the ability to display an icon on an alert (https://www.github.com/smartdevicelink/sdl_ios/issues/995).
* Automatic video streaming now supports module capability parameters for scale (e.g. 1x, 2x), and pixel density (https://www.github.com/smartdevicelink/sdl_ios/issues/1007).
* Added the ability to set a title for the displayed template layout (to name the current app screen) (https://www.github.com/smartdevicelink/sdl_ios/issues/1031).
* Support for canceling popup menus, keyboards, alerts, scrollable messages, and sliders (https://www.github.com/smartdevicelink/sdl_ios/issues/1055).
* `SDLGPSData` now has a `shifted` parameter to support proprietary shifts in certain locales (https://www.github.com/smartdevicelink/sdl_ios/issues/1083).
* Additional remote control RADIO and CLIMATE module parameters have been added (https://www.github.com/smartdevicelink/sdl_ios/issues/1143).
* The RPC session can now be encrypted when the head unit has the capability and desires it. This allows all RPCs, or a subset, to be encrypted over the wire similar to the current capability with video data (https://www.github.com/smartdevicelink/sdl_ios/issues/1163).
  * A new encryption configuration has been added to configure security libraries.
    * A new delegate callback has been added to know when encryption succeeds or fails.
  * The ability to start encryption and mark RPC requests as requiring encryption has been added.
  * The library will automatically encrypt RPCs that the head unit requires to be encrypted.
* Add support for OEM-only custom (non-SDL-defined) vehicle data (https://www.github.com/smartdevicelink/sdl_ios/issues/1184).
* The MEDIA app service now supports a media image (https://www.github.com/smartdevicelink/sdl_ios/issues/1247).
* App services can now be unpublished and their manifests can now be updated (https://www.github.com/smartdevicelink/sdl_ios/issues/1260).
* Additional subscription buttons designed for navigation applications are now available (https://www.github.com/smartdevicelink/sdl_ios/issues/1269).
* Support multiple windows per display via widgets (https://www.github.com/smartdevicelink/sdl_ios/issues/1270).
* Support multiple modules per remote control module type (https://www.github.com/smartdevicelink/sdl_ios/issues/1272).
* A tile layout is now supported for the main menu and sub-menus (https://www.github.com/smartdevicelink/sdl_ios/issues/1276).
* The background string that displays while video streaming when the app is put into the background can now be disabled (https://www.github.com/smartdevicelink/sdl_ios/issues/1304).
* The lock screen can now be enabled at all times (https://www.github.com/smartdevicelink/sdl_ios/issues/1367).
* The module logo on the lock screen can now be disabled (https://www.github.com/smartdevicelink/sdl_ios/issues/1370).
* `SDLSoftButtonObject` can now be initialized without first initializing an `SDLSoftButtonState` (https://www.github.com/smartdevicelink/sdl_ios/issues/1375).
* The secondary transport feature for video streaming can now be disabled (https://www.github.com/smartdevicelink/sdl_ios/issues/1380).
* The `SDLSystemCapabilityManager` now has support for the new multi-window display capabilities with automatic backward-compatibility support (https://www.github.com/smartdevicelink/sdl_ios/issues/1386).
* `SDLHMICapabilities` now supports checking app services (https://www.github.com/smartdevicelink/sdl_ios/issues/1389).

### Bug Fixes
* Fixed the permission manager processing permission updates incorrectly (https://www.github.com/smartdevicelink/sdl_ios/issues/965).
* Multithreading throughout the iOS library has been re-implemented for simplicity and speed (https://www.github.com/smartdevicelink/sdl_ios/issues/1028).
* `SDLSyncMsgVersion` is now `SDLMsgVersion` across the project (https://www.github.com/smartdevicelink/sdl_ios/issues/1352).
* Fix the choice set manager not properly handling successes that also error (like warnings) (https://www.github.com/smartdevicelink/sdl_ios/issues/1363).
* Internal operations now properly immediately when they're canceled before starting (https://www.github.com/smartdevicelink/sdl_ios/issues/1379).
* The video streaming capability `bitrate` is now properly used by default (https://www.github.com/smartdevicelink/sdl_ios/issues/1392).
* Fixed `SDLHMICapabilities` missing parameters (https://www.github.com/smartdevicelink/sdl_ios/issues/1395, https://www.github.com/smartdevicelink/sdl_ios/issues/1423).
* Fixed unit tests on Xcode 11 (https://www.github.com/smartdevicelink/sdl_ios/issues/1406, https://www.github.com/smartdevicelink/sdl_ios/issues/1407).
* Fix video streaming should not begin if `HMICapabilities.videoStreaming` is `NO` (https://www.github.com/smartdevicelink/sdl_ios/issues/1411).
* Fix several RPC response parameters should be optional / nullable (https://www.github.com/smartdevicelink/sdl_ios/issues/1417).
* Fixed iOS 13 making the lock screen dismissible (https://www.github.com/smartdevicelink/sdl_ios/issues/1422).
* Fixed second phone connecting to head unit over iAP disconnecting the first phone (https://www.github.com/smartdevicelink/sdl_ios/issues/1431).
* Add a check before popping a buffer to prevent crashes (https://www.github.com/smartdevicelink/sdl_ios/issues/1433).
* More information is logged when asserts occur due to type mismatches (https://www.github.com/smartdevicelink/sdl_ios/issues/1439).
* Fixed `SDLLightControlCapabilities` and `SDLHMISettingsControlCapabilities` not returning correctly due to mismatched types (https://www.github.com/smartdevicelink/sdl_ios/issues/1441).
* Fixed wording in RPC and Protocol version blocking warning logs (https://www.github.com/smartdevicelink/sdl_ios/issues/1450).
* Encrypted protocol messages are logged more clearly and with additional information (https://www.github.com/smartdevicelink/sdl_ios/issues/1451).
* File Manager will still function if the `ListFiles` returns with a `DISALLOWED` `resultCode` to work around some production module bugs (https://www.github.com/smartdevicelink/sdl_ios/issues/1454).

### Example Apps
* Fixed the VR-only Perform Interaction always failing (https://www.github.com/smartdevicelink/sdl_ios/issues/1353).
* Add a slider and a scrollable message example to the example apps (https://www.github.com/smartdevicelink/sdl_ios/issues/1383).
* Obj-C and Swift example apps are now styled correctly on iOS 13 devices in dark mode (https://www.github.com/smartdevicelink/sdl_ios/issues/1428).

## 6.3.1
### Bug Fixes
* Fix unregistering for EATransport notifications can interfere with other apps' EATransport notifications (https://www.github.com/smartdevicelink/sdl_ios/issues/1329).
* Fix issues related to the background task running when the device is in the process of making an IAP connection but is in the background (https://www.github.com/smartdevicelink/sdl_ios/issues/1326, https://www.github.com/smartdevicelink/sdl_ios/issues/1327).

## 6.3.0
### Versions
* Supports [SDL RPC Spec 5.1.0](https://github.com/smartdevicelink/rpc_spec/releases/tag/5.1.0) and [SDL Protocol Spec 5.2.0](https://github.com/smartdevicelink/protocol_spec/releases/tag/5.2.0).

### Enhancements
* Support dynamic adding / deleting of menu items when they need to be replaced instead of a full delete / add (https://www.github.com/smartdevicelink/sdl_ios/issues/1144).
* The library can now be used via the [Accio Package Manager](https://github.com/JamitLabs/Accio) (https://www.github.com/smartdevicelink/sdl_ios/issues/1229).
* Update to Swift 5.0 (https://www.github.com/smartdevicelink/sdl_ios/issues/1245).
* Add RPC subscription methods to `SDLManager` for ease of use (https://www.github.com/smartdevicelink/sdl_ios/issues/1257).
* Support subscribing to SystemCapabilities with the SystemCapabilityManager (https://www.github.com/smartdevicelink/sdl_ios/issues/1271).
* Support pushing raw PCM audio buffers into the `SDLAudioStreamManager` (https://www.github.com/smartdevicelink/sdl_ios/issues/1275).

### Bug Fixes
* Fix soft button manager entering an infinite loop if artwork fails to upload (https://www.github.com/smartdevicelink/sdl_ios/issues/1177).
* Deprecate RPC superclass initializers as they are not for public use (https://www.github.com/smartdevicelink/sdl_ios/issues/1204).
* Fixed the audio stream manager shutting down when the device app was in the background. It now stays active when the app is in the background (https://www.github.com/smartdevicelink/sdl_ios/issues/1224).
* Fixed Alert RPC documentation (https://www.github.com/smartdevicelink/sdl_ios/issues/1233).
* Fix soft button multiple transitions failing (https://www.github.com/smartdevicelink/sdl_ios/issues/1234).
* Fixed numerous IAP transport issues with a near full rewrite of the related classes (https://www.github.com/smartdevicelink/sdl_ios/issues/1239, https://www.github.com/smartdevicelink/sdl_ios/issues/1263, https://www.github.com/smartdevicelink/sdl_ios/issues/1316, https://www.github.com/smartdevicelink/sdl_ios/issues/1321).
* Fixed `SDLManager` delegate methods not getting called in certain circumstances (https://www.github.com/smartdevicelink/sdl_ios/issues/1243, https://www.github.com/smartdevicelink/sdl_ios/issues/1264).
* Fixed `SDLManager.stop` crashes in certain circumstances (https://www.github.com/smartdevicelink/sdl_ios/issues/1268).
* Fixed inaccessible `SDLAudioStreamManager` API (https://www.github.com/smartdevicelink/sdl_ios/issues/1283).
* Fix setting `SDLChoiceSet``vrHelpItems` outside of the initializer not properly setting their position indexes (https://www.github.com/smartdevicelink/sdl_ios/issues/1291).

### Example Apps
* Fixed `resetConnection` causing a crash (https://www.github.com/smartdevicelink/sdl_ios/issues/1237).

### Dependencies
* Updated BiSON dependency to v1.2.0 to fix potential buffer overruns (https://www.github.com/smartdevicelink/sdl_ios/issues/1280, https://www.github.com/smartdevicelink/sdl_ios/issues/1285).

## 6.2.3
### Versions
* Supports [SDL RPC Spec 5.1.0](https://github.com/smartdevicelink/rpc_spec/releases/tag/5.1.0) and [SDL Protocol Spec 5.2.0](https://github.com/smartdevicelink/protocol_spec/releases/tag/5.2.0).

### Bug Fixes
* Fix all lockscreen related crashes when SDL is setup before the main window exists (https://www.github.com/smartdevicelink/sdl_ios/issues/1258).

## 6.2.2
### Versions
* Supports [SDL RPC Spec 5.1.0](https://github.com/smartdevicelink/rpc_spec/releases/tag/5.1.0) and [SDL Protocol Spec 5.2.0](https://github.com/smartdevicelink/protocol_spec/releases/tag/5.2.0).

### Bug Fixes
* Add an explicit exception if SDL is setup before the app's window. The app's window **must** be setup before SDL is started (https://www.github.com/smartdevicelink/sdl_ios/issues/1255).

## 6.2.1
### Versions
* Supports [SDL RPC Spec 5.1.0](https://github.com/smartdevicelink/rpc_spec/releases/tag/5.1.0) and [SDL Protocol Spec 5.2.0](https://github.com/smartdevicelink/protocol_spec/releases/tag/5.2.0).

##### Enhancements
* SmartDeviceLinkSwift updated to Swift 5.0 (https://www.github.com/smartdevicelink/sdl_ios/issues/1245).

##### Bug Fixes
* Fix `SDLAlert` documentation (https://www.github.com/smartdevicelink/sdl_ios/issues/1233).
* Fixed the audio service being stopped when the navigation app is in `HMI_BACKGROUND` (https://www.github.com/smartdevicelink/sdl_ios/issues/1235).
* Fix setting up the lock screen window causing rotation issues (https://www.github.com/smartdevicelink/sdl_ios/issues/1250).

##### Example App
* The example apps will now auto-reconnect if disconnected physically from the head unit (https://www.github.com/smartdevicelink/sdl_ios/issues/1237).
* Update the example swift app to Swift 5 (https://www.github.com/smartdevicelink/sdl_ios/issues/1172, https://www.github.com/smartdevicelink/sdl_ios/issues/1243, https://www.github.com/smartdevicelink/sdl_ios/issues/1245).

## 6.2.0
### Versions
* Supports [SDL RPC Spec 5.1.0](https://github.com/smartdevicelink/rpc_spec/releases/tag/5.1.0) and [SDL Protocol Spec 5.2.0](https://github.com/smartdevicelink/protocol_spec/releases/tag/5.2.0).

### Enhancements
* Added a screen informing the user what they must do if a video streaming app is not in the foreground on their mobile device (https://github.com/smartdevicelink/sdl_ios/issues/1058).
* `SDLArtwork` added an initializer for static icons, allowing the screen manager to handle displaying static icons in its supported fields (https://github.com/smartdevicelink/sdl_ios/issues/1062).
* Added better `SetMediaClockTimer` initializers (https://github.com/smartdevicelink/sdl_ios/issues/1071).
* All received messages are logged in verbose logging (https://github.com/smartdevicelink/sdl_ios/issues/1133).
* Added `SDLLifecycleConfiguration` properties for enforcing minimum `protocolVersion` and `rpcVersion` connections to head units, effectively blocking older head units as desired (https://github.com/smartdevicelink/sdl_ios/issues/1142).
* Added RPC support for app services, including all three current app service types: `media`, `weather`, and `navigation` (https://github.com/smartdevicelink/sdl_ios/issues/1147, https://github.com/smartdevicelink/sdl_ios/issues/1148 https://github.com/smartdevicelink/sdl_ios/issues/1162).
* Added support for the cloud app transport, enabling OEM apps to expose endpoints for cloud apps to the system policy table (https://github.com/smartdevicelink/sdl_ios/issues/1166).
* Updated Swift example app to Swift 4.2 (https://github.com/smartdevicelink/sdl_ios/issues/1185).
* Updated testing dependencies and Travis CI (https://github.com/smartdevicelink/sdl_ios/issues/1208).
* Added automatic updates and caching to the System Capability Manager for v5.1+ head units (https://github.com/smartdevicelink/sdl_ios/issues/1212).

### Bug Fixes
* Fixed IAP-Bluetooth to IAP-USB transport switching (https://github.com/smartdevicelink/sdl_ios/issues/1079).
* Fixed an issue where the manager would attempt to reconnect even if the head unit unregistered the app for a reason where the app should not reconnect (https://github.com/smartdevicelink/sdl_ios/issues/1084, https://github.com/smartdevicelink/sdl_ios/issues/1097).
* Fixed duplicate HMI status logs (https://github.com/smartdevicelink/sdl_ios/issues/1124).
* Fixed `SDLChoiceManager` not deleting test choice (https://github.com/smartdevicelink/sdl_ios/issues/1129).
* Fixed video streaming reference cycle (https://github.com/smartdevicelink/sdl_ios/issues/1130).
* Improved RTC video streaming resumption (https://github.com/smartdevicelink/sdl_ios/issues/1137).
* Updated `SendLocation` API documentation (https://github.com/smartdevicelink/sdl_ios/issues/1170).
* Added more informative exception on creation of an invalid `SDLSoftButtonState` (https://github.com/smartdevicelink/sdl_ios/issues/1126).
* Fixed numerous crashes in RELEASE builds when connected to head units that are providing invalid data (DEBUG builds will continue to crash unless the log configuration is altered to disable those assertions in DEBUG as well). (https://github.com/smartdevicelink/sdl_ios/issues/1153, https://github.com/smartdevicelink/sdl_ios/issues/1159, https://github.com/smartdevicelink/sdl_ios/issues/1161, https://github.com/smartdevicelink/sdl_ios/issues/1198, https://github.com/smartdevicelink/sdl_ios/issues/1218, https://github.com/smartdevicelink/sdl_ios/issues/1230)
* Fixed Swift 4.2 support in `SDLPermissionManager` by removing some `SDLBool` specifier protocols from `NSNumber` callbacks in `NSDictionary` (https://github.com/smartdevicelink/sdl_ios/issues/1190).
* Fix calling single tap callback checks for the hit view in the `SDLTouchManager` from a background thread. The callback itself will continue to occur on a background thread until the next major version change. (https://github.com/smartdevicelink/sdl_ios/issues/1207)
* Fixed max automatic correlation id to match protocol spec max of `INT32_MAX` instead of `UINT16_MAX`. (https://github.com/smartdevicelink/sdl_ios/issues/1214)
* Fixed some `SDLAppInterfaceUnregisteredReason` enums not being available in the sdl_ios library. (https://github.com/smartdevicelink/sdl_ios/issues/1216)
* Fixed head units that don't support choice set `menuName` required parameter causing issues. Proper errors will now be thrown. (https://github.com/smartdevicelink/sdl_ios/issues/1220)
* Fixed app attempting a reconnect after being unregistered for a `PROTOCOL_VIOLATION`. (https://github.com/smartdevicelink/sdl_ios/issues/1223)

## 6.1.2
### Bug Fixes
* Fix external accessories never reconnecting if connected over both Bluetooth and USB when one transport is disconnected (https://github.com/smartdevicelink/sdl_ios/issues/1113).

## 6.1.1
### Bug Fixes
* Fix possible crash when checking text fields in the screen manager (https://github.com/smartdevicelink/sdl_ios/issues/1122).
* Fix possible crash when checking language field of `RegisterAppInterfaceResponse` in `SDLLifecycleManager` (https://github.com/smartdevicelink/sdl_ios/issues/1127).

## 6.1.0 (Since RC 2)
### Versions
* Supports [SDL RPC Spec 5.0.0](https://github.com/smartdevicelink/rpc_spec/releases/tag/5.0.0) and [SDL Protocol Spec 5.1.0](https://github.com/smartdevicelink/protocol_spec/releases/tag/5.1.0).

### Changes
* None

## 6.1.0 Release Candidate 2
### Bug Fixes
* If a RegisterAppInterface or SetDisplayLayout fail, don't set displayCapabilities to nil in the screen manager [#1108](https://github.com/smartdevicelink/sdl_ios/issues/1108).

## 6.1.0 Release Candidate 1
### Enhancements
* `PlayPause` button name has been added for subscription [#246](https://github.com/smartdevicelink/sdl_ios/issues/246).
* Added the ability to play an audio file (such as a jingle) through `TTSChunk`, which may be used in an `Alert` or `Speak` RPC, for example [SDL-0014] [#524](https://github.com/smartdevicelink/sdl_ios/issues/524).
* Added CRC checksums to data transfers (such as images or files) and automatic retrying of failed transfers, customizable via a new `SDLFileManagerConfiguration` [SDL-0037] [#599](https://github.com/smartdevicelink/sdl_ios/issues/599) [#1013](https://github.com/smartdevicelink/sdl_ios/issues/1013) [SDL-0191] [#1043](https://github.com/smartdevicelink/sdl_ios/issues/1043).
* Added the ability for app icons to appear on the head unit without data being transferred after the first connection [SDL-0041] [#600](https://github.com/smartdevicelink/sdl_ios/issues/600).
* Added the ability to send an image as "template", this is a single color image that can be re-colored by the head unit automatically to fit with the background. e.g. on a white background the image will appear black, and on a black background, white [SDL-0062] [#626](https://github.com/smartdevicelink/sdl_ios/issues/626).
* Added a `displayName` parameter to `displayCapabilities` and deprecate `displayType` [SDL-0063] [#627](https://github.com/smartdevicelink/sdl_ios/issues/627).
* Added new vehicle data: Fuel Range [SDL-0072] [#641](https://github.com/smartdevicelink/sdl_ios/issues/641), Engine Oil Life [SDL-0082] [#706](https://github.com/smartdevicelink/sdl_ios/issues/706), Electronic Park Brake Status [SDL-0102] [#761](https://github.com/smartdevicelink/sdl_ios/issues/761), Tire Pressure [SDL-0097] [#748](https://github.com/smartdevicelink/sdl_ios/issues/748), and Turn Signal [SDL-0107] [#791](https://github.com/smartdevicelink/sdl_ios/issues/791).
* Add the ability for submenu menu cells to have icons [SDL-0085] [#719](https://github.com/smartdevicelink/sdl_ios/issues/719).
* Add new vehicle capabilities that can be remotely controlled by an application: Seat Controls [SDL-0105] [#792](https://github.com/smartdevicelink/sdl_ios/issues/792), lights, display settings, and additional audio capabilities [SDL-0099] [#755](https://github.com/smartdevicelink/sdl_ios/issues/755), [SDL-0165] [#954](https://github.com/smartdevicelink/sdl_ios/issues/954), [SDL-0182] [#1022](https://github.com/smartdevicelink/sdl_ios/issues/1022).
* Add the ability to check the status of remote control modules [SDL-0106] [#800](https://github.com/smartdevicelink/sdl_ios/issues/800), [SDL-0172] [#990](https://github.com/smartdevicelink/sdl_ios/issues/990).
* Add the ability to modify the play / pause button to show either play, pause, stop, or play / pause [SDL-0109] [#892](https://github.com/smartdevicelink/sdl_ios/issues/892).
* Support both USB / BT and WiFi transports simultaneously when streaming video on supported head units [SDL-0141] [#900](https://github.com/smartdevicelink/sdl_ios/issues/900).
* Allow apps to alter template primary, secondary, and tertiary colors while connected to a supported head unit through the RegisterAppInterface and SetDisplayLayout APIs [SDL-0147] [#909](https://github.com/smartdevicelink/sdl_ios/issues/909).
* Allow checking for the availability of a secondary graphic [SDL-0151] [#917](https://github.com/smartdevicelink/sdl_ios/issues/917).
* Support short and full appIds [SDL-0153] [#942](https://github.com/smartdevicelink/sdl_ios/issues/942).
* Allow Perform Interaction Choice Set Choices to not include voice commands [SDL-0064] [#943](https://github.com/smartdevicelink/sdl_ios/issues/943).
* Add a choice set manager to assist in presenting choice set menus and keyboard interactions [SDL-0157] [#970](https://github.com/smartdevicelink/sdl_ios/issues/970).
* Add an enum for static icons [SDL-0159] [#944](https://github.com/smartdevicelink/sdl_ios/issues/944).
* Update TCP transport for production [#946](https://github.com/smartdevicelink/sdl_ios/issues/946).
* Separate SDL example app code better [#1056](https://github.com/smartdevicelink/sdl_ios/issues/1056).

### Bug Fixes
* TCP transport failure is now reported via a notification [#911](https://github.com/smartdevicelink/sdl_ios/issues/911).
* The Obj-C and Swift example apps can now run without crashing without cleaning [#981](https://github.com/smartdevicelink/sdl_ios/issues/981).
* Swift Cocoapods subspec will now properly download lock screen assets [#1026](https://github.com/smartdevicelink/sdl_ios/issues/1026).
* The `SDLLockScreenConfiguration` `showInOptionalState` being `true` was not properly preventing dismissal of the lock screen [#1070](https://github.com/smartdevicelink/sdl_ios/issues/1070).
* Fix possible crashes in SDLAsynchronousRPCOperation on cancellation of operations [#1076](https://github.com/smartdevicelink/sdl_ios/issues/1076).
* Fix can't get CarWindow `rootViewController` [#1100](https://github.com/smartdevicelink/sdl_ios/issues/1100).
* Fix setting CarWindow `rootViewController` not on main thread [#1101](https://github.com/smartdevicelink/sdl_ios/issues/1101).
* Add audio transcode files to default log module map [#1103](https://github.com/smartdevicelink/sdl_ios/issues/1103).

## 6.0.2
### Bug Fixes
* Video streaming apps put into a phone background state can now properly stop the video streaming when it leaves a streamable HMI state. [#1047](https://github.com/smartdevicelink/sdl_ios/issues/1047)

## 6.0.1
### Bug Fixes
* Fixed a crash that could occur in development circumstances if the head unit returns "-1" for an enum
* Fixed manually sent Show RPCs causing issues when changing layouts.

## 6.0.0 (Changes since RC1)

* None

## 6.0.0 Release Candidate 2 (Changes since RC1)
### Bug Fixes
* Fixes generated file names being too long for some SDL implementations. [#976](https://github.com/smartdevicelink/sdl_ios/issues/976)
* Unauthorized apps will no longer spin in a reconnection loop. [#977](https://github.com/smartdevicelink/sdl_ios/issues/977)
* Fixes needing to clean every time one switches building the example apps. [#982](https://github.com/smartdevicelink/sdl_ios/issues/982)
* Speeds up video streaming resets when app goes from background -> foreground on the phone. [#979](https://github.com/smartdevicelink/sdl_ios/issues/979)

## 6.0.0 Release Candidate 1
### Breaking Changes
* Remove `SDLProxy`, `SDLProtocol`, `SDLTransport` and related classes and protocols. [SDL-0016] [#454](https://github.com/smartdevicelink/sdl_ios/issues/454) [SDL-0017] [#525](https://github.com/smartdevicelink/sdl_ios/issues/525) [SDL-0019] [#603](https://github.com/smartdevicelink/sdl_ios/issues/603)

### Enhancements
* Add API documentation [#97](https://github.com/smartdevicelink/sdl_ios/issues/97)
* Added a Swift example app and expanded the Obj-C example app. [#620](https://github.com/smartdevicelink/sdl_ios/issues/620)
* Add System Capability Manager, allowing easier observance of capability changes. [SDL-0088] [#916](https://github.com/smartdevicelink/sdl_ios/issues/916)
* Add Menu Manager, making setting a menu (AddCommand / AddSubmenu) much simpler. [SDL-0155] [#927](https://github.com/smartdevicelink/sdl_ios/issues/927)

### Bug Fixes
* Fix CarWindow api should allow app to manually set screen resolution by exposing protocol that should have been exposed. [#908](https://github.com/smartdevicelink/sdl_ios/issues/908)
* Fix notification of `hmiLevel` change when it has not changed. [#918](https://github.com/smartdevicelink/sdl_ios/issues/918)
* Fix SDLFileManager not calling completion handler when it is shut down before transition to Ready state, causing a memory leak. [#919](https://github.com/smartdevicelink/sdl_ios/issues/919)
* Fix connection retry counter not reset when the accessory is connected. [#921](https://github.com/smartdevicelink/sdl_ios/issues/921)
* Fix SDLTouchManager to handle all touch events in SDLOnTouchEvent. [#935](https://github.com/smartdevicelink/sdl_ios/issues/935)
* Fix SDLCarWindow does not send video after reconnection when lock screen is disabled. [#937](https://github.com/smartdevicelink/sdl_ios/issues/937)
* Simplified Proxy, Protocol, and Transport internals. [#948](https://github.com/smartdevicelink/sdl_ios/issues/948)
* Fix Screen Manager images not sent on reconnection. [#953](https://github.com/smartdevicelink/sdl_ios/issues/953)
* Fix image soft buttons being sent too early. [#955](https://github.com/smartdevicelink/sdl_ios/issues/955)
* Fix custom log modules in Swift. [#962](https://github.com/smartdevicelink/sdl_ios/issues/962)
* Fix graphics not being set after reconnects. [#963](https://github.com/smartdevicelink/sdl_ios/issues/963)
* Fix permission manager not resetting correctly on reconnection. [#964](https://github.com/smartdevicelink/sdl_ios/issues/964)
* Fix SDLShow initializer crashes. [#966](https://github.com/smartdevicelink/sdl_ios/issues/966)
* Fix mediaTrack field on ScreenManager. [#968](https://github.com/smartdevicelink/sdl_ios/issues/968)

## 5.2.0
### Enhancements
* Add a screen manager which currently handles text, graphics, and soft buttons [SDL-0134] [#862](https://github.com/smartdevicelink/sdl_ios/issues/862)
  * Add soft button object and states, which allow for declaratively designing soft buttons with multiple states
* Allow the car window orientation exception to be disabled [#867](https://github.com/smartdevicelink/sdl_ios/issues/811)
* You can now create an `SDLArtwork` without a name and a name will be generated based on a hash of the data. You can also now upload an artwork through `SDLFileManager` and have uploaded artwork names passed back to you [SDL-0124] [#865](https://github.com/smartdevicelink/sdl_ios/issues/865)
* You can now batch send RPCs either as a batch, or sequentially, waiting for the previous RPC request to respond before sending the next one. This may be useful for batch sending `addCommand`s or for sending a `performInteraction` immediately after the `createInteraction` finishes [SDL-0087] [#723](https://github.com/smartdevicelink/sdl_ios/issues/723)
* There is now a change registration manager for managing language [SDL-0054] [#617](https://github.com/smartdevicelink/sdl_ios/issues/617)
* Allow multiple `AppHMIType`s [SDL-0129] [#851](https://github.com/smartdevicelink/sdl_ios/issues/851)

### Bug Fixes
* Fix single taps often being recognized as a pan; there is now a customizable threshold at which pans will be registered; it defaults to 8px [#884](https://github.com/smartdevicelink/sdl_ios/issues/884)
* Fixed video stream would restart immediately after being stopped while in the background. It will now only restart when brought back into the foreground [#858](https://github.com/smartdevicelink/sdl_ios/issues/858)
* Fixed touch manager views being accessed in on background threads [#875](https://github.com/smartdevicelink/sdl_ios/issues/875)
* Fixed crash when using log files [#872](https://github.com/smartdevicelink/sdl_ios/issues/872)
* Properly stop the audio service in HMI level `NONE` and `BACKGROUND` [#803](https://github.com/smartdevicelink/sdl_ios/issues/803)
* Fix EA session not closing on RPC service timeout [#869](https://github.com/smartdevicelink/sdl_ios/issues/869)
* Fix EA session background not always receiving data in background [#835](https://github.com/smartdevicelink/sdl_ios/issues/835)
* Silence an output stream write warning [#850](https://github.com/smartdevicelink/sdl_ios/issues/850)
* Improve `SDLAddCommand` initializer to fix an `iconValue` error [#846](https://github.com/smartdevicelink/sdl_ios/issues/846)
* Fix `SDLUploadFileOperation` not finishing on error [#860](https://github.com/smartdevicelink/sdl_ios/issues/860)
* Fix `AudioStreamingState` not being notified when `LifecycleManager` is ready [#863](https://github.com/smartdevicelink/sdl_ios/issues/863)
* Fix some runtime main thread warnings [#852](https://github.com/smartdevicelink/sdl_ios/issues/852)
* Work around a module `ListFiles` bug on previous SDL Core versions [#827](https://github.com/smartdevicelink/sdl_ios/issues/827)
* CarWindow will no longer crash on iOS 9 [#904](https://github.com/smartdevicelink/sdl_ios/issues/904)

## 5.1.1
### Bug Fixes
* Fixed import statement, allows for Cocoapods release

## 5.1.0
### Enhancements
* Log unsuccessful RPC responses automatically [#811](https://github.com/smartdevicelink/sdl_ios/issues/811).
* IAP Transport reconnection optimizations [#816](https://github.com/smartdevicelink/sdl_ios/issues/816).
* Adds `SDLAudioStreamManager` that does on-the-fly transcoding of audio files to an SDL compatible PCM format and can send that audio to be played. This is for `NAVIGATION` applications only [SDL-0113] [#795](https://github.com/smartdevicelink/sdl_ios/issues/795).
* CarWindow automated ViewController based streaming [SDL-0111] [#794](https://github.com/smartdevicelink/sdl_ios/issues/794).
  * Add automatic video streaming via screenshotting.
  * Update the Lock Screen to use a UIWindow on top of any other UI.
  * SDLStreamingMediaManager now manages framerate more strictly using a CADisplayLink and uses this to sync touch manager and car window updates to the framerate.
  * Several `SDLStreamingMediaConfiguration` additions to support CarWindow.
  * Update SDLTouchManager to sync callbacks with the framerate, this fixes many issues with drawing at inopportune times. There is a BOOL to retain old behavior.

### Bug Fixes
* Enabled additional Xcode 9 warnings when building the project and fixed many warnings, mainly around implicit casts [#814](https://github.com/smartdevicelink/sdl_ios/issues/814).
* Fix `SDLSlider` initializer infinite recursion [#808](https://github.com/smartdevicelink/sdl_ios/issues/808).
* Fix crash if disconnected while setting up the app icon [#833](https://github.com/smartdevicelink/sdl_ios/issues/833).
* Force manual IAP session `stop` calls to run on the main queue [#831](https://github.com/smartdevicelink/sdl_ios/issues/831).
* Navigation audio stream is no longer viewed as available in `HMI NONE` [#803](https://github.com/smartdevicelink/sdl_ios/issues/803).

### Other
* Remove an unused testing library from the Cartfile [#823](https://github.com/smartdevicelink/sdl_ios/issues/823).

## 5.0.0
No changes since RC3

## 5.0.0 Release Candidate 3 (changes since RC 2)
### Bug Fixes
* Fix a possible crash if the List Files request from the FileManager fails due to disconnection or unregistration.

## 5.0.0 Release Candidate 2 (changes since RC 1)
### Bug Fixes
* Fixed podspec
* Focus manager will only activate on iOS 9+, it uses APIs only available on iOS 9+

## 5.0.0 Release Notes
### Breaking Changes
* `SDLProxy.streamingMediaManager` is now removed. If you wish to use a streaming media manager, you must use `SDLManager.streamingMediaManager`. The streaming media manager has been entirely redesigned and now takes into account both phone and head unit app lifecycles [SDL-0033](https://github.com/smartdevicelink/sdl_ios/issues/583). There is now a streaming media configuration added to `SDLConfiguration`.
* `SDLJingle` constants have been removed [#7](https://github.com/smartdevicelink/sdl_ios/issues/7).
* Public files `SDLJsonEncoder.h`, `SDLJsonDecoder.h`, `SDLDecoder.h`, and `SDLEncoder.h` have been removed [#8](https://github.com/smartdevicelink/sdl_ios/issues/8).
* `SDLSiphonServer` has been removed; if something similar is needed, it may be custom built and inserted into the `SDLLogManager` [#85](https://github.com/smartdevicelink/sdl_ios/issues/85).
* RPC array and dictionary properties are now immutable [#152](https://github.com/smartdevicelink/sdl_ios/issues/152).
* `SDLOnWaypointChange`, a misspelling of `SDLOnWayPointChange` has been removed [#489](https://github.com/smartdevicelink/sdl_ios/issues/489).
* `SDLRPCStruct` and all RPC subclasses now take an immutable dictionary to decode [#122](https://github.com/smartdevicelink/sdl_ios/issues/122) [SDL-0005](https://github.com/smartdevicelink/sdl_ios/issues/151), [SDL-0005](https://github.com/smartdevicelink/sdl_ios/issues/507).
* SDL enums are now all stringly typed in Objective-C, and swift enums in Swift [#20](https://github.com/smartdevicelink/sdl_ios/issues/20) [SDL-0006](https://github.com/smartdevicelink/sdl_ios/issues/425).
* iOS 6 and iOS 7 are no longer supported [SDL-0008](https://github.com/smartdevicelink/sdl_ios/issues/419) [SDL-0024](https://github.com/smartdevicelink/sdl_ios/issues/526).
* Use nullability annotations throughout the project [#73](https://github.com/smartdevicelink/sdl_ios/issues/73) [SDL-0018](https://github.com/smartdevicelink/sdl_ios/issues/484).
* Remove `SDLRPCRequestFactory`, initializers now exist on most RPC classes [SDL-0020](https://github.com/smartdevicelink/sdl_ios/issues/485).
* `SDLTTSChunkFactory` was removed, use the initializers on `SDLTTSChunk` instead [SDL-0021](https://github.com/smartdevicelink/sdl_ios/issues/486).
* Handler events now provide better parameters instead of generic ones [SDL-0027](https://github.com/smartdevicelink/sdl_ios/issues/537).

### Enhancements
* Most properties are now nonatomic, which should speed up the library significantly [#49](https://github.com/smartdevicelink/sdl_ios/issues/49).
* `SDLLockScreenViewController` now uses template images, reducing the size of the library [#450](https://github.com/smartdevicelink/sdl_ios/issues/450).
* RPC classes now conform to `NSCopying` [SDL-0011](https://github.com/smartdevicelink/sdl_ios/issues/523).
* Added convenience methods for pulling out SDL notifications from `NSNotification` callbacks [#553](https://github.com/smartdevicelink/sdl_ios/issues/553).
* `SDLTouchManager` now supports gesture cancellation [#673](https://github.com/smartdevicelink/sdl_ios/issues/673).
* `SDLStreamingMediaManager` now supports automatic `GetSystemCapability` calls [#686](https://github.com/smartdevicelink/sdl_ios/issues/686).
* `SDLRegisterAppInterfaceResponse` fixed `pcmCapabilities` not being exposed [#714](https://github.com/smartdevicelink/sdl_ios/issues/714).
* Generics have been added for collections throughout the library [SDL-0007](https://github.com/smartdevicelink/sdl_ios/issues/444).
* `SDLFileManager` will not stream from a file on disk if possible [SDL-0025](https://github.com/smartdevicelink/sdl_ios/issues/536).
* `SDLFileManager` added methods for sending multiple files in one call [SDL-0029](https://github.com/smartdevicelink/sdl_ios/issues/558).
* Added additional `SDLManager` delegate methods for all `onHMIStatus` state changes [SDL-0032](https://github.com/smartdevicelink/sdl_ios/issues/569).
* Added a handler to `SDLPerformAudioPassThru` [SDL-0035](https://github.com/smartdevicelink/sdl_ios/issues/585).
* `SDLStreamingMediaManager` now supports H.264 + RTP [SDL-0048](https://github.com/smartdevicelink/sdl_ios/issues/619).
* Added SDL Remote Control baseline [SDL-0071](https://github.com/smartdevicelink/sdl_ios/issues/650).
* Focusable items can now be sent (to Core 4.4+) and a manager exists that will automatically handle finding and sending those rects if a `UIWindow` is set in the `SDLStreamingMediaConfiguration`. They will also be passed back to the developer through the `SDLTouchManagerDelegate` [SDL-0075](https://github.com/smartdevicelink/sdl_ios/issues/664) [SDL-0081](https://github.com/smartdevicelink/sdl_ios/issues/698) [SDL-0090](https://github.com/smartdevicelink/sdl_ios/issues/728).

### Bug Fixes
* Services are now properly ended with hash ids [#661](https://github.com/smartdevicelink/sdl_ios/issues/661).
* Constants are now unified into one style [#711](https://github.com/smartdevicelink/sdl_ios/issues/711).
* Fix streaming media manager always assumed 30fps streaming; it can now be custom set by developers in the video encoding dictionary [#717](https://github.com/smartdevicelink/sdl_ios/issues/717).

### Example App

### Other
* SDL constants are now constants instead of `#define` [#3](https://github.com/smartdevicelink/sdl_ios/issues/3).
* Some protocol property and enum names were incorrect but now fixed [#275](https://github.com/smartdevicelink/sdl_ios/issues/275).
* Internal getters and setters on RPC classes no longer repeat code everywhere [#493](https://github.com/smartdevicelink/sdl_ios/issues/493).
* `SDLOnLockScreenStatus` does not use constants for property keys [#497](https://github.com/smartdevicelink/sdl_ios/issues/497).
* Removed deprecated methods [#679](https://github.com/smartdevicelink/sdl_ios/issues/679).

## 4.7.4 Release Notes
### Bug Fixes
* Fix for connecting video streaming on Core 4.4.0 (to be released) and above.

## 4.7.3 Release Notes
### Bug Fixes
* Performance fixes for streaming video.
* Fixes for background connection on IAP transports.

## 4.7.2 Release Notes
### Bug Fixes
* Fixes some head units not connecting properly due to the start service payload length not being set properly.

## 4.7.1 Release Notes
### Breaking Changes
* This bumps up the minimum supported version to 7.0 due to Xcode 9 changes. The upcoming v5.0.0 will raise the minimum version to 8.0.

### Bug Fixes
* Fixes the possibility of timers not being appropriately deallocated [#382](https://github.com/smartdevicelink/sdl_ios/issues/382).

### Tests
* Any tests must now be run on Xcode 9.
* The travis config file has been updated to run on Xcode 9.

## 4.7.0 Release Notes (since RC 1)
### Bug Fixes
* Fixed payloads being created with nil data causing a crash [#715](https://github.com/smartdevicelink/sdl_ios/issues/715).
* Fixed documentation warnings.

## 4.7.0 Release Candidate 1
### Enhancements
* This library implements RPC Spec v4.5.0, Protocol Spec v5.0.0.
* Added App type enum: `PROJECTION`, for an app that uses video streaming for its interface yet is not a navigation app [SDL-0031](https://github.com/smartdevicelink/sdl_evolution/blob/master/proposals/0031-mobile-projection.md).
* Added new TouchType enum for touch canceled [SDL-0049](https://github.com/smartdevicelink/sdl_evolution/blob/master/proposals/0049-touch-cancellation.md).
* Expanded the SyncMsgVersion struct on Register App Interface Response to include a patch version [SDL-0050](https://github.com/smartdevicelink/sdl_ios/issues/607).
* Support new protocol spec with constructed control frame payloads [SDL-0052](https://github.com/smartdevicelink/sdl_evolution/blob/master/proposals/0052-constructed-payloads.md) [SDL-0078](https://github.com/smartdevicelink/sdl_evolution/blob/master/proposals/0078-control_frame_payloads_v1_0_0.md).
* Added GetSystemCapability RPC request for retrieving additional capabilities. This also expanded the HMICapabilities struct in the RegisterAppInterfaceResponse [SDL-0055](https://github.com/smartdevicelink/sdl_evolution/blob/master/proposals/0055-system_capabilities_query.md) [SDL-0058](https://github.com/smartdevicelink/sdl_evolution/blob/master/proposals/0058-video-streaming-capabilities.md).
* Added language enums for various additional languages [SDL-0060](https://github.com/smartdevicelink/sdl_evolution/blob/master/proposals/0060-support-indian-english-thai.md) and [SDL-0076](https://github.com/smartdevicelink/sdl_evolution/blob/master/proposals/0076-Support-For-Additional-Languages.md).
* Expanded the Show RPC to include metadata types for text fields [SDL-0073](https://github.com/smartdevicelink/sdl_evolution/blob/master/proposals/0073-Adding-Metadata-Types.md).
* Added SendHapticData RPC to send rectangles of touchable buttons in video streaming. This allows the head units with haptic interface devices (such as a selection wheel) to highlight selectable areas [SDL-0075](https://github.com/smartdevicelink/sdl_evolution/blob/master/proposals/0075-HID-Support-Plug-in.md).
* Support IAP multisession with a new protocol string `com.smartdevicelink.multisession` [SDL-0080](https://github.com/smartdevicelink/sdl_evolution/blob/master/proposals/0080-Support-for-MultiSession-protocol-string.md). **Please check the README and add the new protocol string to your apps! This is improve your successful connection rate.**

### Bug Fixes
* Added background task handling for IAP connections, fixes a possible bug with connections [#591](https://github.com/smartdevicelink/sdl_ios/issues/640).
* Fixed a deadlock that could occassionally occur on control session disconnections [#643](https://github.com/smartdevicelink/sdl_evolution/blob/master/proposals/0076-Support-For-Additional-Languages.md).
* Fixed library crash when in DEBUG mode on normal shutdown sequences [#637](https://github.com/smartdevicelink/sdl_evolution/blob/master/proposals/0076-Support-For-Additional-Languages.md).
* Fixed IAP control session not always being cleaned up [#648](https://github.com/smartdevicelink/sdl_ios/issues/648).
* Fix a rare crash on disconnection that could occur when the response dispatcher was not cleared properly [#666](https://github.com/smartdevicelink/sdl_ios/issues/666).
* Fix some blocks holding retain cycles [#665](https://github.com/smartdevicelink/sdl_ios/issues/665).
* Updated proxy to no longer throw an exception when unknown protocol headers are received. This resolves an issue with corrupted protocol headers [#671](https://github.com/smartdevicelink/sdl_ios/issues/671).

### Other
* Added a note to the documentation regarding file name length maximums [#640](https://github.com/smartdevicelink/sdl_ios/issues/640).

## 4.6.1 Release Notes
### Bug Fixes
* Fixes a bug where an app would crash if connected while the app is foregrounded and the vehicle is already in motion.

### Example App
* Now compiles correctly.

## 4.6.0 Release Notes (since RC 2)
### Example App
* Added a command to send a `GetVehicleData`.

### Known Issues
* On DEBUG builds of an app, if a connected Sync Gen 3 head unit goes through a normal shut down sequence (key out, door open), the app will crash. This will not occur on RELEASE builds.

## 4.6.0 Release Candidate 2 Release Notes (since RC 1)
### Bug Fixes
* Altered the connection timeframe from 0-10 seconds to 1.5-9.5 seconds to improve connection reliability. (SDL-0067)

### Example App
* Fixes a bug causing a crash upon unexpected IAP disconnection and reconnection.

## 4.6.0 Release Candidate 1 Release Notes
### Bug Fixes
* Fix setting lifecycle configuration `appType` to `nil`.
* If an array would return `NSNull`, return an empty array instead.
* Removed uses of `@import` for compatibility issues.
* Added some Xcode 8.3 compatibility fixes.
* Fixed reconnection attempts unable to be stopped, or it would crash.
* Fix `SDLMenuParams initWithMenuParams:parentId:position:` improperly setting `position`.
* IAP transport now does read/writes on a background thread.

### Other
* We now use a new podspec: "SmartDeviceLink", and deprecated the current one ("SmartDeviceLink-iOS"), please update your podfiles. This will be necessary for some features in v5.0.

### Known Issues
* When an app is connected over USB, the USB is disconnected, then reconnected, the app will crash.

## 4.5.5 Release Notes
### Bug Fixes
* Added a check for if `SDLManager` is already started and prevent starting it again.
* Prevent infinite loops in IAP transport.

### Example App
* Fixed incorrectly setting button state on disconnect.

## 4.5.4 Release Notes
### Bug Fixes
* Streaming video will not crash if data is unexpectedly NULL.
* SDL now compiles on Xcode 8.3.
* Lockscreen will now appear appropriately when it's remote HMI is in the background.
* Internal state machines now throw more descriptive exceptions.


## 4.5.3 Release Notes
### Bug Fixes
* `SDLManager`'s `delegate` method `hmiLevel:didChangeToLevel:` now only triggers when the HMI level changes, instead of whenever an `onHMIStatus` is received.
* Fixed a few crashes in `SDLStreamingMediaManager` for navigation video streaming.

## 4.5.2 Release Notes
### Bug Fixes
* Fixed unhandled Register App Interface Response warnings causing the manager to disconnect.
* Fixed `SDLManager stop` not actually stopping SDL.
* Fixed `SDLDebugTool` resetting its logs on disconnection.
* Fixed `SDLManager` auto-reconnection sometimes causing a crash.

### Example Project
* Connect / Disconnect button appearance fixed.

## 4.5.1 Release Notes
### Bug Fixes
* Fixed large file transfers not properly setting their offset.
* Check for nil before attempting to send an RPC request.

## 4.5.0 Release Notes (Since Beta 2)
### Bug Fixes
* Fixed an issue attempting to upload an app icon when the head unit does not support images.

## 4.5.0 Beta 2 Release Notes
### Bug Fixes
* Fixed an issue with printing incorrect Frame Data when logging.
* Fixed an issue with SDLLocationDetails' properties being incorrectly stored.
* Added in nil-checks for SDLStreamingMediaManager's startSession completionHandlers.
* Fixed an issue with a SDLPerformInteraction initializer causing an infinite loop.
* Fixed an issue with uploading a nil SDLFile would cause an infinite loop.

## 4.5.0 Beta 1 Release Notes
### Bug Fixes
* Altered how Security libraries get the app id so they can start downloads faster.
* Fixed a number of RPC initializers to have correct number sizes.
* Fixed a video session crash in rare instances when the compression session was NULL.
* Fixed waypoint RPCs missing response and notification dispatchers and incorrect spelling on some classes (the old classes are deprecated).

## 4.4.1 Release Notes
### Bug Fixes
* Subscribing to waypoints should now work (new feature & RPC in v4.4.0).

### Other
* Fixes a few failing tests that were overlooked.
* `SDLUploadFileOperation`s now use the built-in cancel mechanism instead of its own internal flag.

## 4.4.0 Release Notes
### Features
* [SDL-0003] Adds SendLocation and associated data types.
* [SDL-0004] Adds Waypointing as a feature for Last Mile Navigation.
* Adds `DisplayType` `Generic`, please continue to not use the `DisplayType` to know when features are available.

### Bug Fixes
* Fixes the completion handler of a file upload being called twice when a file failed to upload (which fixes a crash in the example project).

### Tests
* Fixes an issue where tests would fail to compile.

## 4.3.0 Release Notes (Since RC 6 + Highlights)
### Highlights
* Adds a lifecycle manager to replace `SDLProxy` and manages much more of the lifecycle based on a declarative `SDLConfiguration`.
* Adds a file manager to streamline uploading and deleting files.
* Adds a lock screen manager to streamline lock screens and also provides a customizable default lock screen.
* Adds a permission manager to streamline knowing when RPCs are available for use.
* Adds the ability to use blocks to be notified about RPC responses.
* Adds the ability to use blocks to be notified about certain RPC notifications (such as button presses).

### (Since RC 6)
### Features
* Added an `SDLProxy` property to `SDLManager` to allow for edge cases in v4.3. This property will be removed in v5.0.

### Deprecations
* `SDLRPCRequestFactory` is now deprecated. The methods have been replaced as initialzers on the respective RPC methods. These intiailizers have been improved as well.
* `SDLTTSChunkFactory` is now deprecated. The methods have been replaced as initialzers on the respective RPC methods.

### Bug Fixes
* Fixed a bug where a non-existent file could attempt to upload, causing havoc.
* Fix some test framework stuff related to Xcode 8.
* No longer crashes when RegisterAppInterfaceResponse errors.
* RegisterAppInterface no longer crashes when attempting to connect a navigation app to a non-navigation capable head unit.

### Example App
* The example app now shows some example Permission Manager usage and logs to console a few permission manager observer blocks.

## 4.3.0 Release Candidate 6 Release Notes (Since RC 5)
### Bug Fixes
* Fixed several bugs and improved error messaging around what should happen if File Manager fails to start, for example because the head unit does not support files.

## 4.3.0 Release Candidate 5 Release Notes (Since RC 4)
### Bug Fixes
* Fixed an issue where "SmartDeviceLink.h" would not be available through cocoapods.

## 4.3.0 Release Candidate 4 Release Notes (Since RC 3)
### Bug Fixes
* Notification constants should now be compatible both with Swift 3 and with iOS 6/7.
* Fixed a few issues with the lock screen and iOS 6/7 support.
* Fixed a layout issue with the lock screen on iPhone 4S-sized phones.

### Other
* CI builds now run on Xcode 8.
* Removed xctest testing framework, now just uses xcodebuild.
* Explicitly specify which headers are public in Cocoapods spec.

## 4.3.0 Release Candidate 3 Release Notes (Since RC 2)
### Bug Fixes
* Fixed a bug where large putfiles would crash.

### Other
* Updated to base v4.2.4

## 4.3.0 Release Candidate 2 Release Notes (Since RC 1)
### Bug Fixes
* Updated project to Xcode 8 settings and turn on additional warnings and analyzer settings.
* Fixed `SDLConsoleController` not using `NSLocalizedString` macro.
* Fixed example app declaring a `UIModalPresentationStyle` enum as `UIModalTransitionStyle` causing a build error in Xcode 8.
* Update testing deps to work with Xcode 8.

### Example App
* Add iTunes file sharing to the example app to allow for easier file log retrieval.

## 4.3.0 Release Candidate 1 Release Notes (Since Beta 4)
### Enhancements
* Removed all usages of NSLog. Now all logs can be turned on or off.
* SDL logs are now off by default in the default lifecycle configuration, console logs are on by default in the debug lifecycle configuration.
* SDLLockScreenViewController is now public and may be subclassed and used as a custom view controller. If subclassed, the vehicleIcon property will be set if the remote system sends one.

### Bug Fixes
* Fixed an issue with dynamic frameworks accessing the default lock screen resources.
* Fixed a crash relating to an OnAppInterfaceUnregistered notification.

### Example App
* Fixed initial data being sent multiple times.
* Fixed CreateInteractionChoiceSet being sent multiple times and sometimes not working.
* Fixed implementing a delegate method that no longer exists.
* Fixed UI buttons not updating upon connecting.
* Added a soft button.

## 4.3.0 Beta 4 Release Notes (Since Beta 3)
### Enhancements
* Fix resource bundle not being included via cocoapods, causing a failure on the default lock screen. Also added better failure messages. The resource bundle will still have to be manually added to your app's copy resources build phase.
* Reduced resource bundle size by optimizing lock screen images.
* RPC handlers are no longer readonly and can now be set outside of the init.
* Improved the example app with additional code and features to see how the new dev api works. Stay tuned for a few additional features.

## 4.3.0 Beta 3 Release Notes (Since Beta 2)
### Breaking Changes
* `resumeHash` is now a configuration property and is not automatically handled.
* `SDLFile` and `SDLArtwork` initializers no longer contain "ephemeral", these are renamed to simply start with "file" since they are the default case.
* `SDLManagerDelegate` no longer has the method `managerDidBecomeReady`. Use the ready block on `start` instead.
* `SDLManagerDelegate` parameters are now nonnull.
* `SDLLockScreenConfiguration` `showInOptional` is now `showInOptionalState`.
* `SDLLifecycleConfiguration` `port` is now a `UInt16` instead of a `NSString`.
* Many block parameters changed names to be more consistent and descriptive.

### Enhancements
* The `OnKeyboardInput` RPC notification is now properly included and sent.
* `SDLLifecycleManager` now only sends the "Ready" notification if registration succeeded.
* `SDLManagerDelegate` `hmiLevel:didChangeToLevel:` is now sent right after becoming ready with the current HMI level.
* `SDLLifecycleConfiguration` `ipAddress` is now null_resettable.
* `SDLLifecycleConfiguration` can now contain security managers which will properly be added to the internal `SDLProxy` as appropriate.
* `SDLLifecycleConfiguration` now has a `logFlags` parameter which can be set to alter how SDL logs out data or to prevent it from doing so at all.
* If `RegisterAppInterfaceResponse` returns `WARNINGS` or `RESUME_FAILED` still successfully connect, but set the error properly of the ready block with the relevant information.
* Added backward compatible `NSNotification` subclasses to more clearly describe what type of object it contains.
* Documentation enhancements.

### Bug Fixes
* `SDLFileManager` `deleteRemoteFileWithName:completionHandler:` no longer crashes if no completion handler is set.
* `SDLFileManager` `uploadRemoteFileWithName:completionHandler:` no longer crashes if no completion handler is set.
* `SDLFileManager` will more efficiently clean up temporary files.
* Remove some unneeded methods from `SDLLockScreenViewController`.
* Properly send `AppHMIType` and `TTSName` set in `SDLLifecycleConfiguration` to the `RegisterAppInterface`.
* Strong / weak dance bugs fixed.
* Unit test fixes.

### Internal enhancements
* `SDLStateMachine` now has some public keys to help accessing data internally.
* `SDLResponseDispatcher` updates: fixing a method name, fixing an enum equality check, clarity updates.
* `SDLLifecycleManager` remove `stateTransitionNotificationName`.
* Some `NSOperation` subclass code was shifted to an intermediate superclass.
* Fixed some instance variables not having generics.
* Updated code to match v4.2.3.

## 4.3.0 Beta 2 Release Notes (Since Beta 1)
### Enhancements
* Starting up `SDLManager` now requires a block which will pass back an error if it failed.
* `SDLManager` now provides a method to call in `AppDelegate applicationWillTerminate:` that will prevent killed apps from being unable to re-register.

### Bug Fixes
* Fixed a memory leak caused by the strong / weak block dance.

### Other
* Currently removed automatic resumption. Resumption will return in a future build as a manual configuration pass in.

## 4.3.0 Beta 1 Release Notes (Since Alpha 1)
### Breaking Changes
* State machine transition names are no longer public to allow for behind the scenes changes without minor or major version changes.

### Enhancements
* SDLFile, if initialized with NSData, will no longer write that data to disk, instead, it is stored in RAM. SDLFiles initialized with a file URL will continue to keep that data on disk until needed.
* The default lock screen text is now localized into Spanish, French, German, Japenese, and Chinese.

### Bug Fixes
* If the lifecycle manager or any of its consituent managers fail to start, the lifecycle manager will disconnect or unregister and an error will be logged.
* SDLLockScreenManager should use less RAM.
* Fixed test failures.

## 4.3.0 Alpha 1 Release Notes
### Deprecations
* Deprecate SDLProxy in favor of SDLManager. A future major release will remove and alter many public APIs, but they will not be deprecated in this release because they will not be replaced in this release.

### Enhancements
* Release a whole new way of reasoning about interacting with SDL. This new high-level API, and it is largely modular with "managers" for various aspects of SDL. This will be extended as time goes on with various new managers based on aspects of SDL and app development (https://www.github.com/smartdevicelink/sdl_ios/issues/223, https://www.github.com/smartdevicelink/sdl_ios/issues/241, https://www.github.com/smartdevicelink/sdl_ios/issues/298). @joeljfischer, @adein, @justinjdickow, @asm09fsu
  * Add a new set of configurations that will be set before startup and allows the manager to take care of quite a bit of setup boilerplate on its own.
  * Release a Permission Manager that allows a developer to check which SDL RPCs are avaiable to use and monitor the ability to use them.
  * Release a File Manager that abstracts the process of tracking files on the remote head unit, uploading, and deleting files.
  * Release a Lock Screen Manager that tracks appropriate times to show a lock screen and comes with a default lock screen view controller that allows for some customizability.
  * All RPCs sent through the primary manager (SDLManager) are tracked and can have a block called with the request and response when the response is returned from the remote head unit.
  * All RPCs sent will have their correlation ids managed by the SDL library.
  * Particular RPCs can now have an additional block used with them that can be called under certain conditions. For example, RPCs that create buttons (such as soft buttons) can have a block handler that will be called when an event occurs on the button.
  * Underlying the new high-level API are a few dispatchers, particularly the Notification Dispatcher which sends many notifications when new RPC notifications and responses are sent from the remote head unit. This may be used by the developer now, but will become less useful as more managers are released.

## 4.2.4 Release Notes
### Bug Fixes
* Fixed Touch Manager not always firing single touches.

### Other
* Updated testing frameworks to support Xcode 8.
* Updated example app to support Xcode 8.

## 4.2.3 Release Notes
### Bug Fixes
* Fixed HTTPS URL schemes not properly uploading data (https://www.github.com/smartdevicelink/sdl_ios/issues/432, https://www.github.com/smartdevicelink/sdl_ios/issues/438).

## 4.2.2 Release Notes
### Bug Fixes
* Fixed HTTP URL schemes not being properly altered to HTTPS to account for App Transport Security (https://www.github.com/smartdevicelink/sdl_ios/issues/432, https://www.github.com/smartdevicelink/sdl_ios/issues/436).

## 4.2.1 Release Notes
### Bug Fixes
* Fixed SDLStreamingMediaManager encryption status not being set properly (https://www.github.com/smartdevicelink/sdl_ios/issues/433, https://www.github.com/smartdevicelink/sdl_ios/issues/434).

## 4.2.0 Release Notes (since Beta 1)
### Enhancements
* The Streaming Media Manager will now provide a CVPixelBufferPool with default settings so that you don't have to create one yourself.
* Modified Streaming Media Manager `videoSessionAuthenticated` to be `videoSessionEncrypted` and modify the value based on the Start Session ACK encryption flag.

### Bug Fixes
* Make sure to release some C objects in Streaming Media Manager

### Other
* Documentation updates.

## 4.2.0 Beta 1 Release Notes
### Enhancements
* Add an AppInfo struct to RegisterAppInterface automatically with some application details, so that the head unit may automatically launch some apps via IAP if supported (https://www.github.com/smartdevicelink/sdl_ios/issues/398, https://www.github.com/smartdevicelink/sdl_ios/issues/431).
* Add a touch manager to the streaming media manager. The touch manager will watch for touch events and generate gesture recognizer-like callbacks (https://www.github.com/smartdevicelink/sdl_ios/issues/402, https://www.github.com/smartdevicelink/sdl_ios/issues/423).
* The streaming media manager now supports custom encoder settings and better default settings, as well as automatically creates a video based on the display capabilites sent by the head unit in register app interface response (https://www.github.com/smartdevicelink/sdl_ios/issues/400, https://www.github.com/smartdevicelink/sdl_ios/issues/406).
* Add support for linking an external encryption library to the SDL iOS library so that SDL data on the transport may be TLS encrypted (https://www.github.com/smartdevicelink/sdl_ios/issues/348).

### Bug Fixes
* Store sessionIds and service metadata together in the protocol code (https://www.github.com/smartdevicelink/sdl_ios/issues/350).
* Fixed a streaming media manager enum casing issue by deprecating the incorrect cased enum and adding a correctly cased one (https://www.github.com/smartdevicelink/sdl_ios/issues/383, https://www.github.com/smartdevicelink/sdl_ios/issues/411).

## 4.1.5 Release Notes
### Bug Fixes
* Since Apple is disallowing virtually all HTTP requests in Jan. 2017, SDLURLSession will now take all HTTP requests and attempt them over HTTPS. Some cars off the line still have HTTP URLs hardcoded into them, therefore this is a necessary precaution.

## 4.1.4 Release Notes
### Bug Fixes
* Fixed exception causing app to crash when SDL Core disconnects in TCP debug mode. Warning: The app may enter an undefined connection state as there is currently no retry strategy in TCP debug mode.

### Other
* Update test frameworks

## 4.1.3 Release Notes
### Enhancements
* Fix unit tests attempting to be built against Xcode 7.1 instead of Xcode 7.3. (https://www.github.com/smartdevicelink/sdl_ios/issues/413)
* Auto-upload Carthage archives on tag Travis builds. (https://www.github.com/smartdevicelink/sdl_ios/issues/413)
* Move codecov.io settings to the repository in codecov.yml (https://www.github.com/smartdevicelink/sdl_ios/issues/415)
* Add a Jazzy documentation generation script, add theme, and generate documentation for the SDL Developer Portal. (https://www.github.com/smartdevicelink/sdl_ios/issues/417)

### Bugfixes
* Improve video streaming by altering video encoding settings. (https://www.github.com/smartdevicelink/sdl_ios/issues/410)

### Other
* Shift project and code files into the root directory, removing the SmartDeviceLink-iOS directory. (https://www.github.com/smartdevicelink/sdl_ios/issues/404)

## 4.1.2 Release Notes
### Bugfixes
* Enable additional static analyzer rules for Xcode 7.3, fix an associated nullability issue.

### Other
* New .gitignore rule to help carthage submodule users.

## 4.1.1 Release Notes
### Bug Fixes
* Fixed passing in wrong type, causing SDL Protocol v1 to fail.
* Fix `SDLRPCStruct` subclasses generating an incorrect description when logged.

### Other
* Some repository files are now linked into the Xcode project.
* Updated testing dependencies for Xcode 7.3 compatibility.

## 4.1.0 Release Notes
### Enhancements
* The `LAUNCH_APP` system request was implemented.
* The proxy now tracks application state and relays that information to the Head Unit on v4 and above.

### Bug Fixes
* `[SDLProxyListener onProxyOpened]` will only be called when the RPC service starts, instead of any service.
* Sending heartbeat has been deprecated. The iOS proxy will now only respond to heartbeats.
* `SYSTEM_REQUEST` RPC now properly uploads and returns data.
* `SDLStreamingMediaManager`'s version check now correctly compares versions

### Other
* Updates to the README with "Getting Started" code, and updated information on testing.
* License copyright updated to 2016.
* All testing frameworks are removed from the repository and must be bootstrapped when wanted.

### Deprecations
* Methods relating to sending heartbeat have been deprecated. This should not affect your app in any way. These lower-level classes will be removed in future versions.

## 4.0.3 Release Notes

### Enhancements
* Implement HTTP System Requests for policy updates

### Bug Fixes
* Revert the reachability code in TCP. If you were having trouble with connecting to SDL Core, this should fix that particular bug.

### Other
* Fixed numerous broken tests
* Moved templates and CONTRIBUTING to .github
* Enable code coverage by default when testing

## 4.0.2 Release Notes

### Bug Fixes
* Debug logging is a bit better designed and is faster, and file logging happens on a separate queue.
* IAP code no longer causes an unnecessary 3 minute background timer to be set. External Accessory applications already get all the background time they need.
* SDLProxyListener delegate callbacks had some misnamed parameters 'request' should be 'response'.
* SDLProxyListener was marking the wrong type for a passed delegate object. `onOnLockScreenNotification:` now correctly passes a type `SDLOnLockScreenStatus` instead of an `SDLLockScreenStatus`.
* Return `nil` if an object was never set to an RPC. This fixes many unit tests.
* Don't allow `SDLRPCStruct` to initialize with a `nil` backing store. This fixes unit tests.
* MTU size has been fixed to be base 8 based instead of base 10.

### Other
* Apple broke SDL's app launching scheme in iOS 9.0, so this code has been removed from the project. Apple fixed a bug in iOS 9.2 that alleviates much of the missing functionality.
* The example app no longer has video and audio code, and its app type is now `MEDIA` instead of `NAVIGATION`.
* Travis CI builds are fixed
* Pull-Request and Issue templates have been added

## 4.0.1 Release notes

### Bug Fixes
* Fixed some implicit `self` captures with blocks.

## 4.0.0 Release Notes (pre-release)

## Final Release (2015-10-5)
* Example app plist updated with required [ATS](https://developer.apple.com/library/prerelease/ios/technotes/App-Transport-Security-Technote/) keys.

## Release Candidate 2 (2015-09-23)
* Fix a warning for passing in an NSUInteger to an int parameter.

## Release Candidate 1 (2015-09-19)

### Enhancements
* Lock screen icon is now fetched
* Hex string parsing is now roughly twice as fast.

### Bug Fixes
* Web request delegates weren't always called.
* Streaming audio fixes.
* Large chunks of data passed over TCP no longer uses far too much memory.
* Xcode 7 warnings fixed.
* Test frameworks updated for Swift 2.0.
* Build server fixes.


## Alpha 4 (2015-09-08)

### Enhancements
* Documentation update to SDLHMILevel.
* Formatted files.
* SDLChangeRegistration RPC updated with new parameters.
* Heartbeat is now implemented for v3 head units and greater.
* Callback methods in SDLProxyListener protocol implemented for new RPCs.
* Buffer size for transport greatly increased for v3 and greater.
* Now compatible with iOS 6+ instead of just iOS 7+ using Cocoapods.
* Video and Audio streaming is now implemented. Video Streaming is iOS 8+ only. The object will reject you if you are using an older version at runtime.

### Bugfixes
* Properly reset the timer for IAP transport.


## Alpha 3 (2015-06-22)

### Bug Fixes
* Prevent NULL pointer calls on SDLPolicyDataParser, SDLV1ProtocolHeader, and SDLV2ProtocolHeader
* Fix transport not connecting if the app is launched after the device is connected to a head unit.


## Alpha 2 (2015-06-04)

### API Breaking Changes
* 28 header files moved to 'project' scope, making them unavailable to developers.
* Headers now use class forwarding (`@class`) instead of full imports whenever possible.
* SDLDebugToolConsole is given its own file
* SDLRPCStruct is given its own file
* SDLHMIZoneCapablities, SDLVRCapabilities, SDLVRHelpItem letter case fixed
* Fixed 'persistent' spelling and removed 'sync' in `+[SDLRPCRequestFactory buildPutFileWithFileName:fileType:persistentFile:correlationID:]`
* Removed unused ISDLProxy protocol and file
* SDLHMILevel enum names altered to match the rest of the enums
* Fixed spelling of SDLProxyListener `onEncodedSyncPDataResponse:` method
* SDLRPCRequestFactory `buildRegisterAppInterfaceWithAppName:ttsName:vrSynonyms:isMediaApp:languageDesired:hmiDisplayLanguageDesired:appID:` to take immutable arrays instead of mutable arrays, to match all the other methods
* Removed SDLTransport protocol and file
* Removed SDLInterfaceProtocol protocol and file

### Enhancements
* Completely new project structure. This will enable future support for optional packages through Cocoapods (via subspecs) and frameworks
* Cocoapods distribution support
* Carthage distribution support
* Add a very basic example app
* Unit tests, using Quick, Nimble, and OCMock third party libraries (only used for unit testing)
* Partial documentation coverage
* Enable static analysis
* Initializers now return `instancetype`
* SDLEnums store values in an immutable NSArray
* Add initializers to SDLObjectWithPriority
* Add a `.clang-format` file
* Add SDLHMICapabilities struct
* Add new enum values for TextFieldName, ImageFieldName, KeyboardEvent, Result, and RequestType
* Add SDLSendLocation RPC
* Add SDLDialNumber RPC
* Add quicklook support to SDLEnum objects
* Protocols now conform to NSObject
* Add new RegisterAppInterfaceResponse parameters
* Add support for SDL 4.0 app launching
* Refactor IAP transport
* Add thread index to log format

### Bugfixes
* Fix all SDLRPCMessages being initialized being set with 'request' type
* Fix all instances of 'receive' being spelled incorrectly
* Fix attempting to copy an SDLEnum in `+[SDLRPCRequestFactory buildPutFileWithFileName:fileType:persistentFile:correlationId:]`
* Fix SDLProtocolHeader `data` method using incorrect order of operations (https://www.github.com/smartdevicelink/sdl_ios/issues/84)
* Fix SDLOnLockScreenStatus `hmiLevel` checking wrong class type (https://www.github.com/smartdevicelink/sdl_ios/issues/83)
* Fix SDLProtocolMessageAssembler calling it's completion handler twice (https://www.github.com/smartdevicelink/sdl_ios/issues/92)
* Fix SDLRPCRequestFactory `performAudioPassThru` not settting correlation id (https://www.github.com/smartdevicelink/sdl_ios/issues/79)
* Fix OnSyncPData function ID being incorrect
* Fix uninitialized variable being captured by a block in SDLProxy
* Fix misspelling of 'dictionary'
