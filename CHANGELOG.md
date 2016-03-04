# 4.0.3 Release Notes

### Enhancements
* Implement HTTP System Requests for policy updates

### Bug Fix
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
