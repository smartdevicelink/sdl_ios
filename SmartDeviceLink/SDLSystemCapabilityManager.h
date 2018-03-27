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

NS_ASSUME_NONNULL_BEGIN

@interface SDLSystemCapabilityManager : NSObject

@property (strong, nonatomic, readonly, nullable) SDLDisplayCapabilities *displayCapabilities;
@property (strong, nonatomic, readonly) SDLHMICapabilities *hmiCapabilities;
@property (copy, nonatomic, readonly, nullable) NSArray<SDLSoftButtonCapabilities *> *softButtonCapabilities;
@property (copy, nonatomic, readonly) NSArray<SDLButtonCapabilities *> *buttonCapabilities;
@property (strong, nonatomic, readonly) SDLPresetBankCapabilities *presetBankCapabilities;
@property (copy, nonatomic, readonly) NSArray<SDLHMIZoneCapabilities> *hmiZoneCapabilities;
@property (copy, nonatomic, readonly) NSArray<SDLSpeechCapabilities> *speechCapabilities;
@property (copy, nonatomic, readonly) NSArray<SDLPrerecordedSpeech> *prerecordedSpeech;
@property (copy, nonatomic, readonly, nullable) NSArray<SDLVRCapabilities> *vrCapabilities;
@property (copy, nonatomic, readonly) NSArray<SDLAudioPassThruCapabilities *> *audioPassThruCapabilities;
@property (copy, nonatomic, readonly) NSArray<SDLAudioPassThruCapabilities *> *pcmStreamCapabilities;
@property (strong, nonatomic, readonly) SDLNavigationCapability *navigationCapability;
@property (strong, nonatomic, readonly) SDLPhoneCapability *phoneCapability;
@property (strong, nonatomic, readonly) SDLVideoStreamingCapability *videoStreamingCapability;
@property (strong, nonatomic, readonly) SDLRemoteControlCapabilities *remoteControlCapability;

typedef void (^SDLUpdateCapabilityHandler)(NSError *error);

/**
 *  Retrieve a capability type from the remote system. This is necessary to retrieve the values of `navigationCapability`, `phoneCapability`, `videoStreamingCapability`, and `remoteControlCapability`. If you do not call this method first, those values will be nil. After calling this method, assuming there is no error in the handler, you may retrieve the capability you requested from the manager within the handler.
 *
 *  @param type The type of capability to retrieve
 *  @param handler The handler to be called when the retrieval is complete
 */
- (void)updateCapabilityType:(SDLSystemCapabilityType)type completionHandler:(SDLUpdateCapabilityHandler)handler;


@end

NS_ASSUME_NONNULL_END
