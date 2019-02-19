//
//  SDLSystemCapability.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/10/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLRPCStruct.h"
#import "SDLSystemCapabilityType.h"

@class SDLAppServicesCapabilities;
@class SDLPhoneCapability;
@class SDLNavigationCapability;
@class SDLVideoStreamingCapability;
@class SDLRemoteControlCapabilities;

NS_ASSUME_NONNULL_BEGIN

/**
 The systemCapabilityType indicates which type of data should be changed and identifies which data object exists in this struct. For example, if the SystemCapability Type is NAVIGATION then a "navigationCapability" should exist.

 First implemented in SDL Core v4.4
 */
@interface SDLSystemCapability : SDLRPCStruct

- (instancetype)initWithAppServicesCapabilities:(SDLAppServicesCapabilities *)capability;

- (instancetype)initWithNavigationCapability:(SDLNavigationCapability *)capability;

- (instancetype)initWithPhoneCapability:(SDLPhoneCapability *)capability;

- (instancetype)initWithVideoStreamingCapability:(SDLVideoStreamingCapability *)capability;

- (instancetype)initWithRemoteControlCapability:(SDLRemoteControlCapabilities *)capability;

/**
 *  Used as a descriptor of what data to expect in this struct. The corresponding param to this enum should be included and the only other parameter included.
 */
@property (strong, nonatomic) SDLSystemCapabilityType systemCapabilityType;

/**
 *  Describes the capabilities of app services including what service types are supported and the current state of services.
 *
 *  Optional
 */
@property (nullable, strong, nonatomic) SDLAppServicesCapabilities *appServiceCapability;

/**
 *  Describes the extended capabilities of the onboard navigation system
 *
 *  Optional
 */
@property (nullable, strong, nonatomic) SDLNavigationCapability *navigationCapability;

/**
 *  Describes the extended capabilities of the module's phone feature
 *
 *  Optional
 */
@property (nullable, strong, nonatomic) SDLPhoneCapability *phoneCapability;

/**
 *  Describes the  capabilities of the module's video streaming feature
 *
 *  Optional
 */
@property (nullable, strong, nonatomic) SDLVideoStreamingCapability *videoStreamingCapability;

/**
 *  Describes the extended capabilities of the module's remote control feature
 *
 *  Optional
 */
@property (nullable, strong, nonatomic) SDLRemoteControlCapabilities *remoteControlCapability;

@end

NS_ASSUME_NONNULL_END
