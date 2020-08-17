//
//  SDLSystemCapabilityManager.h
//  SmartDeviceLink
//
//  Created by Nicole on 3/26/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLHMIZoneCapabilities.h"
#import "SDLPrerecordedSpeech.h"
#import "SDLSpeechCapabilities.h"
#import "SDLSystemCapabilityType.h"
#import "SDLVrCapabilities.h"

@class SDLAppServicesCapabilities;
@class SDLAudioPassThruCapabilities;
@class SDLButtonCapabilities;
@class SDLDisplayCapability;
@class SDLDisplayCapabilities;
@class SDLDriverDistractionCapability;
@class SDLHMICapabilities;
@class SDLNavigationCapability;
@class SDLPhoneCapability;
@class SDLPresetBankCapabilities;
@class SDLRemoteControlCapabilities;
@class SDLSeatLocationCapability;
@class SDLSoftButtonCapabilities;
@class SDLSystemCapability;
@class SDLSystemCapabilityManager;
@class SDLVideoStreamingCapability;
@class SDLWindowCapability;

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

/**
 *  A completion handler called after a request for the capability type is returned from the remote system.
 *
 *  @param error The error returned if the request for a capability type failed. The error is nil if the request was successful.
 *  @param systemCapabilityManager The system capability manager
 */
typedef void (^SDLUpdateCapabilityHandler)(NSError * _Nullable error, SDLSystemCapabilityManager *systemCapabilityManager);

/**
 An observer block for whenever a subscription is called.

 @param capability The capability that was updated.
 */
typedef void (^SDLCapabilityUpdateHandler)(SDLSystemCapability *capability);

/**
 An observer block for whenever a subscription or value is retrieved.

 @param capability The capability that was updated.
 @param subscribed Whether or not the capability was subscribed or if the capability will only be pulled once.
 @param error An error that occurred.
 */
typedef void (^SDLCapabilityUpdateWithErrorHandler)(SDLSystemCapability * _Nullable capability, BOOL subscribed, NSError * _Nullable error);

/**
 A manager that handles updating and subscribing to SDL capabilities.
 */
@interface SDLSystemCapabilityManager : NSObject

/**
 * Provides window capabilities of all displays connected with SDL. By default, one display is connected and supported which includes window capability information of the default main window of the display. May be nil if the system has not provided display and window capability information yet.
 *
 * @see SDLDisplayCapability
 *
 * Optional, @since SDL 6.0
 */
@property (nullable, strong, nonatomic, readonly) NSArray<SDLDisplayCapability *> *displays;

/**
 * @see SDLDisplayCapabilities
 *
 * Optional
 */
@property (nullable, strong, nonatomic, readonly) SDLDisplayCapabilities *displayCapabilities __deprecated_msg("Use displays, windowCapabilityWithID: or defaultMainWindowCapability instead to access capabilities of a display/window.");

/**
 * @see SDLHMICapabilities
 *
 * Optional
 */
@property (nullable, strong, nonatomic, readonly) SDLHMICapabilities *hmiCapabilities;

/**
 * If returned, the platform supports on-screen SoftButtons
 *
 * @see SDLSoftButtonCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLSoftButtonCapabilities
 */
@property (nullable, copy, nonatomic, readonly) NSArray<SDLSoftButtonCapabilities *> *softButtonCapabilities __deprecated_msg("Use displays, windowCapabilityWithID: or defaultMainWindowCapability instead to access soft button capabilities of a window.");

/**
 * @see SDLButtonCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLButtonCapabilities
 */
@property (nullable, copy, nonatomic, readonly) NSArray<SDLButtonCapabilities *> *buttonCapabilities  __deprecated_msg("Use displays, windowCapabilityWithID: or defaultMainWindowCapability instead to access button capabilities of a window.");

/**
 * If returned, the platform supports custom on-screen Presets
 *
 * @see SDLPresetBankCapabilities
 *
 * Optional
 */
@property (nullable, strong, nonatomic, readonly) SDLPresetBankCapabilities *presetBankCapabilities  __deprecated_msg("Use displays, windowCapabilityWithID: or defaultMainWindowCapability instead to access preset bank capabilities of a window.");

/**
 * @see SDLHMIZoneCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLHMIZoneCapabilities
 */
@property (nullable, copy, nonatomic, readonly) NSArray<SDLHMIZoneCapabilities> *hmiZoneCapabilities;

/**
 * @see SDLSpeechCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLSpeechCapabilities
 */
@property (nullable, copy, nonatomic, readonly) NSArray<SDLSpeechCapabilities> *speechCapabilities;

/**
 * @see SDLPrerecordedSpeech
 *
 * Optional, Array of length 1 - 100, of SDLPrerecordedSpeech
 */
@property (nullable, copy, nonatomic, readonly) NSArray<SDLPrerecordedSpeech> *prerecordedSpeechCapabilities;

/**
 * @see SDLVRCapabilities
 *
 * True if the head unit supports voice recognition; false if not.
 */
@property (nonatomic, assign, readonly) BOOL vrCapability;

/**
 * @see SDLAudioPassThruCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLAudioPassThruCapabilities
 */
@property (nullable, copy, nonatomic, readonly) NSArray<SDLAudioPassThruCapabilities *> *audioPassThruCapabilities;

/**
 * @see SDLAudioPassThruCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLAudioPassThruCapabilities
 */
@property (nullable, strong, nonatomic, readonly) SDLAudioPassThruCapabilities *pcmStreamCapability;

/**
 * If returned, the platform supports app services
 */
@property (nullable, strong, nonatomic, readonly) SDLAppServicesCapabilities *appServicesCapabilities;

/**
 If returned, the platform supports navigation
 */
@property (nullable, strong, nonatomic, readonly) SDLNavigationCapability *navigationCapability;

/**
 If returned, the platform supports making phone calls
 */
@property (nullable, strong, nonatomic, readonly) SDLPhoneCapability *phoneCapability;

/**
 If returned, the platform supports video streaming
 */
@property (nullable, strong, nonatomic, readonly) SDLVideoStreamingCapability *videoStreamingCapability;

/**
 If returned, the platform supports remote control capabilities
 */
@property (nullable, strong, nonatomic, readonly) SDLRemoteControlCapabilities *remoteControlCapability;

/**
 If returned, the platform supports remote control capabilities for seats
 */
@property (nullable, strong, nonatomic, readonly) SDLSeatLocationCapability *seatLocationCapability;

/// If returned, the platform supports driver distraction capabilities
@property (nullable, strong, nonatomic, readonly) SDLDriverDistractionCapability *driverDistractionCapability;

/**
 * Returns the window capability object of the default main window which is always pre-created by the connected system. This is a convenience method for easily accessing the capabilities of the default main window.
 *
 * @returns The window capability object representing the default main window capabilities or nil if no window capabilities exist.
 */
@property (nullable, strong, nonatomic, readonly) SDLWindowCapability *defaultMainWindowCapability;

/**
 YES if subscriptions are available on the connected module and you will automatically be notified if the value changes on the module. If NO, calls to `subscribe` methods will subscribe to updates, but the module will not automatically notify you. You will need to call `updateWithCapabilityType:completionHandler:` to force an update if you need one (though this should be rare). This does not apply to the `DISPLAYS` capability type which you can always subscribe to.
 */
@property (assign, nonatomic, readonly) BOOL supportsSubscriptions;

/**
 Init is unavailable. Dependencies must be injected using initWithConnectionManager:

 @return nil
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 Creates a new system capability manager with a specified connection manager

 @param manager A connection manager to use to forward on RPCs

 @return An instance of SDLSystemCapabilityManager
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)manager NS_DESIGNATED_INITIALIZER;

/**
 Starts the manager. This method is used internally.
 */
- (void)start;

/**
 Stops the manager. This method is used internally.
 */
- (void)stop;

/**
 * Returns the window capability of one of your app's windows with the specified window ID that is on the primary display (i.e. the head unit itself). This is a convenience method to easily access capabilities of windows such as your apps' widget windows.
 *
 * To get the capabilities of the main window on the main display (i.e. your app's primary app screen on the head unit itself).
 *
 * @param windowID The ID of the window from which to get capabilities
 * @returns The window window capabilities of the window with the specified windowID, or nil if the window is not known or no window capabilities exist.
 */
- (nullable SDLWindowCapability *)windowCapabilityWithWindowID:(NSUInteger)windowID;

/// Returns whether or not the capability type is supported on the module. You can use this to check if subscribing to the capability will work. If this returns NO, then the feature is not supported by the head unit. If YES, the feature is supported by the head unit. You can subscribe to the capability type to get more information about the capability's support and features on the connected module.
/// @param type The SystemCapabilityType that will be checked.
/// @return Whether or not `type` is supported by the connected head unit.
- (BOOL)isCapabilitySupported:(SDLSystemCapabilityType)type NS_SWIFT_NAME(isCapabilitySupported(type:));

/**
 * This method has been superseded by the `subscribeToCapabilityType:` methods. You should use one of those methods instead unless you only want a value once (you don't want to keep a long-lasting observer) and it must be current (most capabilities do not need to be updated). If you have a separate subscription observer and are connected to a head unit that does not support subscriptions, when this method returns, it will also call all subscription callbacks that you've set up with the new value if there is one. Therefore, you can use this method to force an update to all subscriptions of that particular type on head units that don't support subscriptions (`supportsSubscriptions == NO`).
 *
 * @param type The type of capability to retrieve
 * @param handler The handler to be called when the retrieval is complete
 */
- (void)updateCapabilityType:(SDLSystemCapabilityType)type completionHandler:(SDLUpdateCapabilityHandler)handler;

/// Subscribe to a particular capability type using a block callback.
///
/// On v5.1.0+ systems (where `supportsSubscriptions == YES`):
/// This method will be called immediately with the current value if a subscription already exists and will be called every time the value is updated.
///
/// On sub-v5.1.0 systems (where `supportsSubscriptions == NO`):
/// The method will be called immediately with the current value and will _not_ be automatically called every time the value is updated, unless the `type` is `DISPLAYS` which is supported on every version. If `updateCapabilityType:completionHandler` is called and a new value is retrieved, this value will be updated then. If this is the first subscription of this `SDLSystemCapabilityType`, then the value will be retrieved and returned.
///
/// @param type The type of capability to subscribe to
/// @param block The block to be called when the capability is updated
/// @return An object that can be used to unsubscribe the block using unsubscribeFromCapabilityType:withObserver: by passing it in the observer callback, or nil if the manager can't attempt the subscription for some reason (such as the app being in HMI_NONE and the type is not DISPLAYS).
- (nullable id<NSObject>)subscribeToCapabilityType:(SDLSystemCapabilityType)type withBlock:(SDLCapabilityUpdateHandler)block __deprecated_msg("use subscribeToCapabilityType:withUpdateHandler: instead");

/// Subscribe to a particular capability type using a handler callback.
///
/// On v5.1.0+ systems (where `supportsSubscriptions == YES`):
/// This method will be called immediately with the current value if a subscription already exists and will be called every time the value is updated.
///
/// Note that when the cached value is returned, the `subscribed` flag on the handler will be false until the subscription completes successfully and a new value is retrieved.
///
/// On sub-v5.1.0 systems (where `supportsSubscriptions == NO`):
/// The method will be called immediately with the current value and will _not_ be automatically called every time the value is updated, unless the `type` is `DISPLAYS` which is supported on every version. If `updateCapabilityType:completionHandler` is called and a new value is retrieved, this value will be updated then. If this is the first subscription of this `SDLSystemCapabilityType`, then the value will be retrieved and returned.
///
/// @param type The type of capability to subscribe to
/// @param handler The block to be called when the capability is updated with an error if one occurs
/// @return An object that can be used to unsubscribe the block using unsubscribeFromCapabilityType:withObserver: by passing it in the observer callback, or nil if the manager can't attempt the subscription for some reason (such as the app being in HMI_NONE and the type is not DISPLAYS).
- (nullable id<NSObject>)subscribeToCapabilityType:(SDLSystemCapabilityType)type withUpdateHandler:(SDLCapabilityUpdateWithErrorHandler)handler NS_SWIFT_NAME(subscribe(capabilityType:updateHandler:));


/// Subscribe to a particular capability type with a selector callback.
///
/// The selector supports the following parameters:
///
/// 1. No parameters e.g. `- (void)phoneCapabilityUpdated;`
///
/// 2. One `SDLSystemCapability *` parameter, e.g. `- (void)phoneCapabilityUpdated:(SDLSystemCapability *)capability`
///
/// 3. Two parameters, one `SDLSystemCapability *` parameter, and one `NSError` parameter, e.g. `- (void)phoneCapabilityUpdated:(SDLSystemCapability *)capability error:(NSError *)error`
///
/// 4. Three parameters, one `SDLSystemCapability *` parameter, one `NSError` parameter, and one `BOOL` parameter e.g. `- (void)phoneCapabilityUpdated:(SDLSystemCapability *)capability error:(NSError *)error subscribed:(BOOL)subscribed`
///
/// On v5.1.0+ systems (where `supportsSubscriptions == YES`):
/// This method will be called immediately with the current value if a subscription already exists and will be called every time the value is updated.
///
/// On sub-v5.1.0 systems (where `supportsSubscriptions == NO`):
/// The method will be called immediately with the current value and will _not_ be automatically called every time the value is updated, unless the `type` is `DISPLAYS` which is supported on every version. If `updateCapabilityType:completionHandler` is called and a new value is retrieved, this value will be updated then. If this is the first subscription of this `SDLSystemCapabilityType`, then the value will be retrieved and returned.
///
/// @param type The type of the system capability to subscribe to
/// @param observer The object that will have `selector` called whenever the capability is updated
/// @param selector The selector on `observer` that will be called whenever the capability is updated
/// @return YES if the manager is attempting the subscription, or NO if the manager can't attempt the subscription for some reason (such as the app being in HMI_NONE and the type is not DISPLAYS), or the selector doesn't contain the correct number of parameters.
- (BOOL)subscribeToCapabilityType:(SDLSystemCapabilityType)type withObserver:(id)observer selector:(SEL)selector;

/// Unsubscribe from a particular capability type. If it was subscribed with a block / handler, the return value should be passed to the `observer` to unsubscribe the block. If it was subscribed with a selector, the `observer` object (on which the selector exists and is called) should be passed to unsubscribe the object selector.
///
/// @param type The type of the system capability to unsubscribe from
/// @param observer The object that will be unsubscribed. If a block was subscribed, the return value should be passed. If a selector was subscribed, the observer object should be passed.
- (void)unsubscribeFromCapabilityType:(SDLSystemCapabilityType)type withObserver:(id)observer;

- (void)unsubscribeObserver:(id)observer;

@end

NS_ASSUME_NONNULL_END
