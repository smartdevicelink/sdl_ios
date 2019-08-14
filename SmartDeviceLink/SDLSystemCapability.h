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
@class SDLDisplayCapability;

NS_ASSUME_NONNULL_BEGIN

/**
 *  The systemCapabilityType indicates which type of data should be changed and identifies which data object exists in this struct. For example, if the SystemCapability Type is NAVIGATION then a "navigationCapability" should exist.
 *
 *  First implemented in SDL Core v4.4
 */
@interface SDLSystemCapability : SDLRPCStruct

/**
 *  Convenience init for an App Service Capability
 *
 *  @param capability   Describes the capabilities of app services including what service types are supported and the current state of services
 *  @return             A SDLSystemCapability object
 */
- (instancetype)initWithAppServicesCapabilities:(SDLAppServicesCapabilities *)capability;

/**
 *  Convenience init for a Navigation Capability
 *
 *  @param capability   Describes the extended capabilities of the onboard navigation system
 *  @return             A SDLSystemCapability object
 */
- (instancetype)initWithNavigationCapability:(SDLNavigationCapability *)capability;

/**
 *  Convenience init for a Phone Capability
 *
 *  @param capability   Describes the extended capabilities of the module's phone feature
 *  @return             A SDLSystemCapability object
 */
- (instancetype)initWithPhoneCapability:(SDLPhoneCapability *)capability;

/**
 *  Convenience init for a Video Streaming Capability
 *
 *  @param capability   Describes the capabilities of the module's video streaming feature
 *  @return             A SDLSystemCapability object
 */
- (instancetype)initWithVideoStreamingCapability:(SDLVideoStreamingCapability *)capability;

/**
 *  Convenience init for a Remote Control Capability
 *
 *  @param capability   Describes the extended capabilities of the module's remote control feature
 *  @return             A SDLSystemCapability object
 */
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
@property (nullable, strong, nonatomic) SDLAppServicesCapabilities *appServicesCapabilities;

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

/**
 *
 *
 */
@property (nullable, strong, nonatomic) SDLDisplayCapabilities *displayCapabilities;

@end

NS_ASSUME_NONNULL_END
