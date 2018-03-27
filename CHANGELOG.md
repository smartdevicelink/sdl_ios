# 5.2.0
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

# 5.1.1
### Bug Fixes
* Fixed import statement, allows for Cocoapods release

# 5.1.0
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

# 5.0.0
No changes since RC3

# 5.0.0 Release Candidate 3 (changes since RC 2)
### Bug Fixes
* Fix a possible crash if the List Files request from the FileManager fails due to disconnection or unregistration.

# 5.0.0 Release Candidate 2 (changes since RC 1)
### Bug Fixes
* Fixed podspec
* Focus manager will only activate on iOS 9+, it uses APIs only available on iOS 9+

# 5.0.0 Release Notes
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

# 4.7.4 Release Notes
### Bug Fixes
* Fix for connecting video streaming on Core 4.4.0 (to be released) and above.

# 4.7.3 Release Notes
### Bug Fixes
* Performance fixes for streaming video.
* Fixes for background connection on IAP transports.

# 4.7.2 Release Notes
### Bug Fixes
* Fixes some head units not connecting properly due to the start service payload length not being set properly.

# 4.7.1 Release Notes
### Breaking Changes
* This bumps up the minimum supported version to 7.0 due to Xcode 9 changes. The upcoming v5.0.0 will raise the minimum version to 8.0.

### Bug Fixes
* Fixes the possibility of timers not being appropriately deallocated [#382](https://github.com/smartdevicelink/sdl_ios/issues/382).

### Tests
* Any tests must now be run on Xcode 9.
* The travis config file has been updated to run on Xcode 9.

# 4.7.0 Release Notes (since RC 1)
### Bug Fixes
* Fixed payloads being created with nil data causing a crash [#715](https://github.com/smartdevicelink/sdl_ios/issues/715).
* Fixed documentation warnings.

# 4.7.0 Release Candidate 1
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

# 4.6.1 Release Notes
### Bug Fixes
* Fixes a bug where an app would crash if connected while the app is foregrounded and the vehicle is already in motion.

### Example App
* Now compiles correctly.

# 4.6.0 Release Notes (since RC 2)
### Example App
* Added a command to send a `GetVehicleData`.

### Known Issues
* On DEBUG builds of an app, if a connected Sync Gen 3 head unit goes through a normal shut down sequence (key out, door open), the app will crash. This will not occur on RELEASE builds.

# 4.6.0 Release Candidate 2 Release Notes (since RC 1)
### Bug Fixes
* Altered the connection timeframe from 0-10 seconds to 1.5-9.5 seconds to improve connection reliability. (SDL-0067)

### Example App
* Fixes a bug causing a crash upon unexpected IAP disconnection and reconnection.

# 4.6.0 Release Candidate 1 Release Notes
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

# 4.5.5 Release Notes
### Bug Fixes
* Added a check for if `SDLManager` is already started and prevent starting it again.
* Prevent infinite loops in IAP transport.

### Example App
* Fixed incorrectly setting button state on disconnect.

# 4.5.4 Release Notes
### Bug Fixes
* Streaming video will not crash if data is unexpectedly NULL.
* SDL now compiles on Xcode 8.3.
* Lockscreen will now appear appropriately when it's remote HMI is in the background.
* Internal state machines now throw more descriptive exceptions.


# 4.5.3 Release Notes
### Bug Fixes
* `SDLManager`'s `delegate` method `hmiLevel:didChangeToLevel:` now only triggers when the HMI level changes, instead of whenever an `onHMIStatus` is received.
* Fixed a few crashes in `SDLStreamingMediaManager` for navigation video streaming.

# 4.5.2 Release Notes
### Bug Fixes
* Fixed unhandled Register App Interface Response warnings causing the manager to disconnect.
* Fixed `SDLManager stop` not actually stopping SDL.
* Fixed `SDLDebugTool` resetting its logs on disconnection.
* Fixed `SDLManager` auto-reconnection sometimes causing a crash.

### Example Project
* Connect / Disconnect button appearance fixed.

# 4.5.1 Release Notes
### Bug Fixes
* Fixed large file transfers not properly setting their offset.
* Check for nil before attempting to send an RPC request.

# 4.5.0 Release Notes (Since Beta 2)
### Bug Fixes
* Fixed an issue attempting to upload an app icon when the head unit does not support images.

# 4.5.0 Beta 2 Release Notes
### Bug Fixes
* Fixed an issue with printing incorrect Frame Data when logging.
* Fixed an issue with SDLLocationDetails' properties being incorrectly stored.
* Added in nil-checks for SDLStreamingMediaManager's startSession completionHandlers.
* Fixed an issue with a SDLPerformInteraction initializer causing an infinite loop.
* Fixed an issue with uploading a nil SDLFile would cause an infinite loop.

# 4.5.0 Beta 1 Release Notes
### Bug Fixes
* Altered how Security libraries get the app id so they can start downloads faster.
* Fixed a number of RPC initializers to have correct number sizes.
* Fixed a video session crash in rare instances when the compression session was NULL.
* Fixed waypoint RPCs missing response and notification dispatchers and incorrect spelling on some classes (the old classes are deprecated).

# 4.4.1 Release Notes
### Bug Fixes
* Subscribing to waypoints should now work (new feature & RPC in v4.4.0).

### Other
* Fixes a few failing tests that were overlooked.
* `SDLUploadFileOperation`s now use the built-in cancel mechanism instead of its own internal flag.

# 4.4.0 Release Notes
### Features
* [SDL-0003] Adds SendLocation and associated data types.
* [SDL-0004] Adds Waypointing as a feature for Last Mile Navigation.
* Adds `DisplayType` `Generic`, please continue to not use the `DisplayType` to know when features are available.

### Bug Fixes
* Fixes the completion handler of a file upload being called twice when a file failed to upload (which fixes a crash in the example project).

### Tests
* Fixes an issue where tests would fail to compile.

# 4.3.0 Release Notes (Since RC 6 + Highlights)
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

# 4.3.0 Release Candidate 6 Release Notes (Since RC 5)
### Bug Fixes
* Fixed several bugs and improved error messaging around what should happen if File Manager fails to start, for example because the head unit does not support files.

# 4.3.0 Release Candidate 5 Release Notes (Since RC 4)
### Bug Fixes
* Fixed an issue where "SmartDeviceLink.h" would not be available through cocoapods.

# 4.3.0 Release Candidate 4 Release Notes (Since RC 3)
### Bug Fixes
* Notification constants should now be compatible both with Swift 3 and with iOS 6/7.
* Fixed a few issues with the lock screen and iOS 6/7 support.
* Fixed a layout issue with the lock screen on iPhone 4S-sized phones.

### Other
* CI builds now run on Xcode 8.
* Removed xctest testing framework, now just uses xcodebuild.
* Explicitly specify which headers are public in Cocoapods spec.

# 4.3.0 Release Candidate 3 Release Notes (Since RC 2)
### Bug Fixes
* Fixed a bug where large putfiles would crash.

### Other
* Updated to base v4.2.4

# 4.3.0 Release Candidate 2 Release Notes (Since RC 1)
### Bug Fixes
* Updated project to Xcode 8 settings and turn on additional warnings and analyzer settings.
* Fixed `SDLConsoleController` not using `NSLocalizedString` macro.
* Fixed example app declaring a `UIModalPresentationStyle` enum as `UIModalTransitionStyle` causing a build error in Xcode 8.
* Update testing deps to work with Xcode 8.

### Example App
* Add iTunes file sharing to the example app to allow for easier file log retrieval.

# 4.3.0 Release Candidate 1 Release Notes (Since Beta 4)
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

# 4.3.0 Beta 4 Release Notes (Since Beta 3)
### Enhancements
* Fix resource bundle not being included via cocoapods, causing a failure on the default lock screen. Also added better failure messages. The resource bundle will still have to be manually added to your app's copy resources build phase.
* Reduced resource bundle size by optimizing lock screen images.
* RPC handlers are no longer readonly and can now be set outside of the init.
* Improved the example app with additional code and features to see how the new dev api works. Stay tuned for a few additional features.

# 4.3.0 Beta 3 Release Notes (Since Beta 2)
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

# 4.3.0 Beta 2 Release Notes (Since Beta 1)
### Enhancements
* Starting up `SDLManager` now requires a block which will pass back an error if it failed.
* `SDLManager` now provides a method to call in `AppDelegate applicationWillTerminate:` that will prevent killed apps from being unable to re-register.

### Bug Fixes
* Fixed a memory leak caused by the strong / weak block dance.

### Other
* Currently removed automatic resumption. Resumption will return in a future build as a manual configuration pass in.

# 4.3.0 Beta 1 Release Notes (Since Alpha 1)
### Breaking Changes
* State machine transition names are no longer public to allow for behind the scenes changes without minor or major version changes.

### Enhancements
* SDLFile, if initialized with NSData, will no longer write that data to disk, instead, it is stored in RAM. SDLFiles initialized with a file URL will continue to keep that data on disk until needed.
* The default lock screen text is now localized into Spanish, French, German, Japenese, and Chinese.

### Bug Fixes
* If the lifecycle manager or any of its consituent managers fail to start, the lifecycle manager will disconnect or unregister and an error will be logged.
* SDLLockScreenManager should use less RAM.
* Fixed test failures.

# 4.3.0 Alpha 1 Release Notes
### Deprecations
* Deprecate SDLProxy in favor of SDLManager. A future major release will remove and alter many public APIs, but they will not be deprecated in this release because they will not be replaced in this release.

### Enhancements
* Release a whole new way of reasoning about interacting with SDL. This new high-level API, and it is largely modular with "managers" for various aspects of SDL. This will be extended as time goes on with various new managers based on aspects of SDL and app development (#223, #241, #298). @joeljfischer, @adein, @justinjdickow, @asm09fsu
  * Add a new set of configurations that will be set before startup and allows the manager to take care of quite a bit of setup boilerplate on its own.
  * Release a Permission Manager that allows a developer to check which SDL RPCs are avaiable to use and monitor the ability to use them.
  * Release a File Manager that abstracts the process of tracking files on the remote head unit, uploading, and deleting files.
  * Release a Lock Screen Manager that tracks appropriate times to show a lock screen and comes with a default lock screen view controller that allows for some customizability.
  * All RPCs sent through the primary manager (SDLManager) are tracked and can have a block called with the request and response when the response is returned from the remote head unit.
  * All RPCs sent will have their correlation ids managed by the SDL library.
  * Particular RPCs can now have an additional block used with them that can be called under certain conditions. For example, RPCs that create buttons (such as soft buttons) can have a block handler that will be called when an event occurs on the button.
  * Underlying the new high-level API are a few dispatchers, particularly the Notification Dispatcher which sends many notifications when new RPC notifications and responses are sent from the remote head unit. This may be used by the developer now, but will become less useful as more managers are released.

# 4.2.4 Release Notes
### Bug Fixes
* Fixed Touch Manager not always firing single touches.

### Other
* Updated testing frameworks to support Xcode 8.
* Updated example app to support Xcode 8.

# 4.2.3 Release Notes
### Bug Fixes
* Fixed HTTPS URL schemes not properly uploading data (#432, #438).

# 4.2.2 Release Notes
### Bug Fixes
* Fixed HTTP URL schemes not being properly altered to HTTPS to account for App Transport Security (#432, #436).

# 4.2.1 Release Notes
### Bug Fixes
* Fixed SDLStreamingMediaManager encryption status not being set properly (#433, #434).

# 4.2.0 Release Notes (since Beta 1)
### Enhancements
* The Streaming Media Manager will now provide a CVPixelBufferPool with default settings so that you don't have to create one yourself.
* Modified Streaming Media Manager `videoSessionAuthenticated` to be `videoSessionEncrypted` and modify the value based on the Start Session ACK encryption flag.

### Bug Fixes
* Make sure to release some C objects in Streaming Media Manager

### Other
* Documentation updates.

# 4.2.0 Beta 1 Release Notes
### Enhancements
* Add an AppInfo struct to RegisterAppInterface automatically with some application details, so that the head unit may automatically launch some apps via IAP if supported (#398, #431).
* Add a touch manager to the streaming media manager. The touch manager will watch for touch events and generate gesture recognizer-like callbacks (#402, #423).
* The streaming media manager now supports custom encoder settings and better default settings, as well as automatically creates a video based on the display capabilites sent by the head unit in register app interface response (#400, #406).
* Add support for linking an external encryption library to the SDL iOS library so that SDL data on the transport may be TLS encrypted (#348).

### Bug Fixes
* Store sessionIds and service metadata together in the protocol code (#350).
* Fixed a streaming media manager enum casing issue by deprecating the incorrect cased enum and adding a correctly cased one (#383, #411).

# 4.1.5 Release Notes
### Bug Fixes
* Since Apple is disallowing virtually all HTTP requests in Jan. 2017, SDLURLSession will now take all HTTP requests and attempt them over HTTPS. Some cars off the line still have HTTP URLs hardcoded into them, therefore this is a necessary precaution.

# 4.1.4 Release Notes
### Bug Fixes
* Fixed exception causing app to crash when SDL Core disconnects in TCP debug mode. Warning: The app may enter an undefined connection state as there is currently no retry strategy in TCP debug mode.

### Other
* Update test frameworks

# 4.1.3 Release Notes
### Enhancements
* Fix unit tests attempting to be built against Xcode 7.1 instead of Xcode 7.3. (#413)
* Auto-upload Carthage archives on tag Travis builds. (#413)
* Move codecov.io settings to the repository in codecov.yml (#415)
* Add a Jazzy documentation generation script, add theme, and generate documentation for the SDL Developer Portal. (#417)

### Bugfixes
* Improve video streaming by altering video encoding settings. (#410)

### Other
* Shift project and code files into the root directory, removing the SmartDeviceLink-iOS directory. (#404)

# 4.1.2 Release Notes
### Bugfixes
* Enable additional static analyzer rules for Xcode 7.3, fix an associated nullability issue.

### Other
* New .gitignore rule to help carthage submodule users.

# 4.1.1 Release Notes
### Bug Fixes
* Fixed passing in wrong type, causing SDL Protocol v1 to fail.
* Fix `SDLRPCStruct` subclasses generating an incorrect description when logged.

### Other
* Some repository files are now linked into the Xcode project.
* Updated testing dependencies for Xcode 7.3 compatibility.

# 4.1.0 Release Notes
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

# 4.0.3 Release Notes

### Enhancements
* Implement HTTP System Requests for policy updates

### Bug Fixes
* Revert the reachability code in TCP. If you were having trouble with connecting to SDL Core, this should fix that particular bug.

### Other
* Fixed numerous broken tests
* Moved templates and CONTRIBUTING to .github
* Enable code coverage by default when testing

# 4.0.2 Release Notes

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

# 4.0.1 Release notes

### Bug Fixes
* Fixed some implicit `self` captures with blocks.

# 4.0.0 Release Notes (pre-release)

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
* Fix SDLProtocolHeader `data` method using incorrect order of operations (#84)
* Fix SDLOnLockScreenStatus `hmiLevel` checking wrong class type (#83)
* Fix SDLProtocolMessageAssembler calling it's completion handler twice (#92)
* Fix SDLRPCRequestFactory `performAudioPassThru` not settting correlation id (#79)
* Fix OnSyncPData function ID being incorrect
* Fix uninitialized variable being captured by a block in SDLProxy
* Fix misspelling of 'dictionary'
