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
 A manager that handles updating and subscribing to SDL capabilities.
 */
@interface SDLSystemCapabilityManager : NSObject

/**
 YES if subscriptions are available on the connected head unit. If NO, calls to `subscribeToCapabilityType:withBlock` and `subscribeToCapabilityType:withObserver:selector` will fail.
 */
@property (assign, nonatomic, readonly) BOOL supportsSubscriptions;

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
 *
 * @see SDLAppServicesCapabilities
 *
 * Optional
 */
@property (nullable, strong, nonatomic, readonly) SDLAppServicesCapabilities *appServicesCapabilities;

/**
 If returned, the platform supports navigation

 @see SDLNavigationCapability

 Optional
 */
@property (nullable, strong, nonatomic, readonly) SDLNavigationCapability *navigationCapability;

/**
 If returned, the platform supports making phone calls

 @see SDLPhoneCapability

 Optional
 */
@property (nullable, strong, nonatomic, readonly) SDLPhoneCapability *phoneCapability;

/**
 If returned, the platform supports video streaming

 @see SDLVideoStreamingCapability

 Optional
 */
@property (nullable, strong, nonatomic, readonly) SDLVideoStreamingCapability *videoStreamingCapability;

/**
 If returned, the platform supports remote control capabilities

 @see SDLRemoteControlCapabilities

 Optional
 */
@property (nullable, strong, nonatomic, readonly) SDLRemoteControlCapabilities *remoteControlCapability;

/**
 If returned, the platform supports remote control capabilities for seats
 
 @see SDLSeatLocationCapability
 
 Optional
 */
@property (nullable, strong, nonatomic, readonly) SDLSeatLocationCapability *seatLocationCapability;


/**
 * Returns the window capability object of the default main window which is always pre-created by the connected system. This is a convenience method for easily accessing the capabilities of the default main window.
 *
 * @returns The window capability object representing the default main window capabilities or nil if no window capabilities exist.
 */
@property (nullable, strong, nonatomic, readonly) SDLWindowCapability *defaultMainWindowCapability;

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
 *  Retrieves a capability type from the remote system. This function must be called in order to retrieve the values for `navigationCapability`, `phoneCapability`, `videoStreamingCapability`, `remoteControlCapability`, and `appServicesCapabilities`. If you do not call this method first, those values will be nil. After calling this method, assuming there is no error in the handler, you may retrieve the capability you requested from the manager within the handler.
 *
 *  @param type The type of capability to retrieve
 *  @param handler The handler to be called when the retrieval is complete
 */
- (void)updateCapabilityType:(SDLSystemCapabilityType)type completionHandler:(SDLUpdateCapabilityHandler)handler;

/**
 Subscribe to a particular capability type using a block callback

 @param type The type of capability to subscribe to
 @param block The block to be called when the capability is updated
 @return An object that can be used to unsubscribe the block using unsubscribeFromCapabilityType:withObserver: by passing it in the observer callback, or nil if subscriptions aren't available on this head unit
 */
- (nullable id<NSObject>)subscribeToCapabilityType:(SDLSystemCapabilityType)type withBlock:(SDLCapabilityUpdateHandler)block;

/**
 * Subscribe to a particular capability type with a selector callback. The selector supports the following parameters:
 *
 * 1. No parameters e.g. `- (void)phoneCapabilityUpdated;`
 * 2. One `SDLSystemCapability *` parameter e.g. `- (void)phoneCapabilityUpdated:(SDLSystemCapability *)capability`
 *
 * This method will be called immediately with the current value and called every time the value is updated on RPC v5.1.0+ systems (`supportsSubscriptions == YES`). If this method is called on a sub-v5.1.0 system (`supportsSubscriptions == NO`), the method will return `NO` and the selector will never be called.
 *
 * @param type The type of the system capability to subscribe to
 * @param observer The object that will have `selector` called whenever the capability is updated
 * @param selector The selector on `observer` that will be called whenever the capability is updated
 * @return Whether or not the subscription succeeded. `NO` if the connected system doesn't support capability subscriptions, or if the `selector` doesn't support the correct parameters (see above)
 */
- (BOOL)subscribeToCapabilityType:(SDLSystemCapabilityType)type withObserver:(id)observer selector:(SEL)selector;

/**
 * Unsubscribe from a particular capability type. If it was subscribed with a block, the return value should be passed to the `observer` to unsubscribe the block. If it was subscribed with a selector, the `observer` object should be passed to unsubscribe the object selector.
 *
 * @param type The type of the system capability to unsubscribe from
 * @param observer The object that will be unsubscribed. If a block was subscribed, the return value should be passed. If a selector was subscribed, the observer object should be passed.
 */
- (void)unsubscribeFromCapabilityType:(SDLSystemCapabilityType)type withObserver:(id)observer;

/**
 * Returns the window capability object of the primary display with the specified window ID. This is a convenient method to easily access capabilities of windows for instance widget windows of the main display.
 *
 * @param windowID The ID of the window to get capabilities
 * @returns The window capability object representing the window capabilities of the window with the specified window ID or nil if the window is not known or no window capabilities exist.
 */
- (nullable SDLWindowCapability *)windowCapabilityWithWindowID:(NSUInteger)windowID;

@end

NS_ASSUME_NONNULL_END
