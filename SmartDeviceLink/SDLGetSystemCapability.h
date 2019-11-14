//
//  SDLGetSystemCapability.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/11/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLRPCRequest.h"
#import "SDLSystemCapabilityType.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  SDL RPC Request for expanded information about a supported system/HMI capability
 *
 *  @since SDL 4.5
 */
@interface SDLGetSystemCapability : SDLRPCRequest

/**
 *  Convenience init
 *
 *  @param type The type of system capability
 *  @return     A SDLSystemCapabilityType object
 */
- (instancetype)initWithType:(SDLSystemCapabilityType)type;

/**
 *  Convenience init
 *
 *  @param type         The type of system capability
 *  @param subscribe    Whether or not to subscribe to updates of the supplied service capability type
 *  @return             A SDLSystemCapabilityType object
 */
- (instancetype)initWithType:(SDLSystemCapabilityType)type subscribe:(BOOL)subscribe;

/**
 *  The type of system capability to get more information on
 *
 *  SDLSystemCapabilityType, Required
 */
@property (strong, nonatomic) SDLSystemCapabilityType systemCapabilityType;

/**
 *  Flag to subscribe to updates of the supplied service capability type. If true, the requester will be subscribed. If false, the requester will not be subscribed and be removed as a subscriber if it was previously subscribed.
 *
 *  Boolean, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *subscribe;

@end

NS_ASSUME_NONNULL_END
