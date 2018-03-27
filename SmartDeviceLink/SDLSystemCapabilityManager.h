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
@class SDLVideoStreamingCapability;

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

@interface SDLSystemCapabilityManager : NSObject

@property (nullable, strong, nonatomic, readonly) SDLDisplayCapabilities *displayCapabilities;
@property (nullable, strong, nonatomic, readonly) SDLHMICapabilities *hmiCapabilities;
@property (nullable, copy, nonatomic, readonly) NSArray<SDLSoftButtonCapabilities *> *softButtonCapabilities;
@property (nullable, copy, nonatomic, readonly) NSArray<SDLButtonCapabilities *> *buttonCapabilities;
@property (nullable, strong, nonatomic, readonly) SDLPresetBankCapabilities *presetBankCapabilities;
@property (nullable, copy, nonatomic, readonly) NSArray<SDLHMIZoneCapabilities> *hmiZoneCapabilities;
@property (nullable, copy, nonatomic, readonly) NSArray<SDLSpeechCapabilities> *speechCapabilities;
@property (nullable, copy, nonatomic, readonly) NSArray<SDLPrerecordedSpeech> *prerecordedSpeech;
@property (nullable, copy, nonatomic, readonly) NSArray<SDLVRCapabilities> *vrCapabilities;
@property (nullable, copy, nonatomic, readonly) NSArray<SDLAudioPassThruCapabilities *> *audioPassThruCapabilities;
@property (nullable, copy, nonatomic, readonly) NSArray<SDLAudioPassThruCapabilities *> *pcmStreamCapabilities;
@property (nullable, strong, nonatomic, readonly) SDLNavigationCapability *navigationCapability;
@property (nullable, strong, nonatomic, readonly) SDLPhoneCapability *phoneCapability;
@property (nullable, strong, nonatomic, readonly) SDLVideoStreamingCapability *videoStreamingCapability;
@property (nullable, strong, nonatomic, readonly) SDLRemoteControlCapabilities *remoteControlCapability;

typedef void (^SDLUpdateCapabilityHandler)(NSError * _Nullable error);

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
 *  Retrieve a capability type from the remote system. This is necessary to retrieve the values of `navigationCapability`, `phoneCapability`, `videoStreamingCapability`, and `remoteControlCapability`. If you do not call this method first, those values will be nil. After calling this method, assuming there is no error in the handler, you may retrieve the capability you requested from the manager within the handler.
 *
 *  @param type The type of capability to retrieve
 *  @param handler The handler to be called when the retrieval is complete
 */
- (void)updateCapabilityType:(SDLSystemCapabilityType)type completionHandler:(SDLUpdateCapabilityHandler)handler;


@end

NS_ASSUME_NONNULL_END
