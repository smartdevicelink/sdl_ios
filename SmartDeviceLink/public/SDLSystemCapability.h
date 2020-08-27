/*
* Copyright (c) 2020, SmartDeviceLink Consortium, Inc.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
* Redistributions of source code must retain the above copyright notice, this
* list of conditions and the following disclaimer.
*
* Redistributions in binary form must reproduce the above copyright notice,
* this list of conditions and the following
* disclaimer in the documentation and/or other materials provided with the
* distribution.
*
* Neither the name of the SmartDeviceLink Consortium Inc. nor the names of
* its contributors may be used to endorse or promote products derived
* from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
* POSSIBILITY OF SUCH DAMAGE.
*/

#import "SDLRPCStruct.h"
#import "SDLSystemCapabilityType.h"

@class SDLAppServicesCapabilities;
@class SDLDisplayCapability;
@class SDLDriverDistractionCapability;
@class SDLNavigationCapability;
@class SDLPhoneCapability;
@class SDLRemoteControlCapabilities;
@class SDLSeatLocationCapability;
@class SDLVideoStreamingCapability;

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
 Convenience init for DisplayCapability list
 
 @param capabilities    Contains capabilities related to a physical screen and any associated windows
 @return                A SDLSystemCapability object
 */
- (instancetype)initWithDisplayCapabilities:(NSArray<SDLDisplayCapability *> *)capabilities;

/**
 *  Convenience init for a Remote Control Capability
 *
 *  @param capability   Describes information about the locations of each seat
 *  @return             A SDLSystemCapability object
 */
- (instancetype)initWithSeatLocationCapability:(SDLSeatLocationCapability *)capability;

/// Convenience init for a Driver Distraction capability
/// @param capability Describes capabilities when the driver is distracted
/// @return A SDLSystemCapability object
- (instancetype)initWithDriverDistractionCapability:(SDLDriverDistractionCapability *)capability;

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
 *  Describes information about the locations of each seat
 *
 *  Optional
 */
@property (nullable, strong, nonatomic) SDLSeatLocationCapability *seatLocationCapability;

/**
 Contain the display related information and all windows related to that display
 
 Optional
 
 @since SDL 6.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLDisplayCapability *> *displayCapabilities;

/**
 * Describes capabilities when the driver is distracted
 *
 * @since SDL 7.0.0
 */
@property (nullable, strong, nonatomic) SDLDriverDistractionCapability *driverDistractionCapability;

@end

NS_ASSUME_NONNULL_END
