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

@class SDLAudioPassThruCapabilities;
@class SDLButtonCapabilities;
@class SDLDisplayCapabilities;
@class SDLHMICapabilities;
@class SDLNavigationCapability;
@class SDLPhoneCapability;
@class SDLPresetBankCapabilities;
@class SDLRemoteControlCapabilities;
@class SDLSoftButtonCapabilities;
@class SDLSystemCapabilityManager;
@class SDLVideoStreamingCapability;

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN


/**
 *  A completion handler called after a request for the capability type is returned from the remote system.
 *
 *  @param error The error returned if the request for a capability type failed. The error is nil if the request was successful.
 *  @param systemCapabilityManager The system capability manager
 */
typedef void (^SDLUpdateCapabilityHandler)(NSError * _Nullable error, SDLSystemCapabilityManager *systemCapabilityManager);


@interface SDLSystemCapabilityManager : NSObject

/**
 * @see SDLDisplayCapabilities
 *
 * Optional
 */
@property (nullable, strong, nonatomic, readonly) SDLDisplayCapabilities *displayCapabilities;

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
@property (nullable, copy, nonatomic, readonly) NSArray<SDLSoftButtonCapabilities *> *softButtonCapabilities;

/**
 * @see SDLButtonCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLButtonCapabilities
 */
@property (nullable, copy, nonatomic, readonly) NSArray<SDLButtonCapabilities *> *buttonCapabilities;

/**
 * If returned, the platform supports custom on-screen Presets
 *
 * @see SDLPresetBankCapabilities
 *
 * Optional
 */
@property (nullable, strong, nonatomic, readonly) SDLPresetBankCapabilities *presetBankCapabilities;

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
 * If returned, the platform supports navigation
 *
 * @see SDLNavigationCapability
 *
 * Optional
 */
@property (nullable, strong, nonatomic, readonly) SDLNavigationCapability *navigationCapability;

/**
 * If returned, the platform supports making phone calls
 *
 * @see SDLPhoneCapability
 *
 * Optional
 */
@property (nullable, strong, nonatomic, readonly) SDLPhoneCapability *phoneCapability;

/**
 * If returned, the platform supports video streaming
 *
 * @see SDLVideoStreamingCapability
 *
 * Optional
 */
@property (nullable, strong, nonatomic, readonly) SDLVideoStreamingCapability *videoStreamingCapability;

/**
 * If returned, the platform supports remote control capabilities
 *
 * @see SDLRemoteControlCapabilities
 *
 * Optional
 */
@property (nullable, strong, nonatomic, readonly) SDLRemoteControlCapabilities *remoteControlCapability;

/**
 *  Init is unavailable. Dependencies must be injected using initWithConnectionManager:
 *
 *  @return nil
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 *  Creates a new system capability manager with a specified connection manager
 *
 *  @param manager A connection manager to use to forward on RPCs
 *
 *  @return An instance of SDLSystemCapabilityManager
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)manager NS_DESIGNATED_INITIALIZER;

/**
 *  Stops the manager. This method is used internally.
 */
- (void)stop;

/**
 *  Retrieves a capability type from the remote system. This function must be called in order to retrieve the values of `navigationCapability`, `phoneCapability`, `videoStreamingCapability` and `remoteControlCapability`. If you do not call this method first, those values will be nil. After calling this method, assuming there is no error in the handler, you may retrieve the capability you requested from the manager within the handler.
 *
 *  @param type The type of capability to retrieve
 *  @param handler The handler to be called when the retrieval is complete
 */
- (void)updateCapabilityType:(SDLSystemCapabilityType)type completionHandler:(SDLUpdateCapabilityHandler)handler;


@end

NS_ASSUME_NONNULL_END
