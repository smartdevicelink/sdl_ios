//
//  SDLSystemCapability.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/10/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLRPCStruct.h"
#import "SDLSystemCapabilityType.h"

@class SDLPhoneCapability;
@class SDLNavigationCapability;
@class SDLVideoStreamingCapability;
@class SDLRemoteControlCapabilities;

NS_ASSUME_NONNULL_BEGIN

/**
 The systemCapabilityType indicates which type of data should be changed and identifies which data object exists in this struct. For example, if the SystemCapability Type is NAVIGATION then a "navigationCapability" should exist.
 * First implemented in SDL Core v4.4
 */
@interface SDLSystemCapability : SDLRPCStruct

- (instancetype)initWithNavigationCapability:(SDLNavigationCapability *)capability;

- (instancetype)initWithPhoneCapability:(SDLPhoneCapability *)capability;

- (instancetype)initWithVideoStreamingCapability:(SDLVideoStreamingCapability *)capability;

- (instancetype)initWithRemoteControlCapability:(SDLRemoteControlCapabilities *)capability;

@property (strong, nonatomic) SDLSystemCapabilityType systemCapabilityType;

@property (nullable, strong, nonatomic) SDLNavigationCapability *navigationCapability;

@property (nullable, strong, nonatomic) SDLPhoneCapability *phoneCapability;

@property (nullable, strong, nonatomic) SDLVideoStreamingCapability *videoStreamingCapability;

@property (nullable, strong, nonatomic) SDLRemoteControlCapabilities *remoteControlCapability;

@end

NS_ASSUME_NONNULL_END
